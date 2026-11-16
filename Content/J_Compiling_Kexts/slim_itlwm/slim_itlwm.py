#!/usr/bin/env python3
"""
slim_itlwm.py - build a slimmed AirportItlwm/itlwm kext from laobamac/itlwm

Automates the "remove unused firmware, then compile" workflow from
OC-Little-Translated (Slimming_Intel_WiFI_BT_Kexts.md) for the laobamac fork.

What differs from the guide (this fork, as of Nov 2026):
  * Firmware lives in itlwm/firmware and is named iwm-*, iwn-* and
    iwlwifi-*-NN.ucode (+ .pnvm). The guide's iwlwifi-7265-*.ucode style names
    do not exist here, so the card -> firmware map is parsed from the driver
    source instead of being hardcoded.
  * No Lilu is needed. Only MacKernelSDK is (cloned into the checkout,
    pinned to the README/CI commit unless --sdk-latest).
  * scripts/fw_gen.sh does nothing if include/FwBinary.cpp already exists, so
    this script deletes it. Otherwise the old, fat firmware blob gets reused.
  * The AirportItlwm-* schemes already depend on fw_gen; no separate step.

Only the Wi-Fi kext is handled. IntelBluetoothFirmware is a separate repo.

Examples:
  ./slim_itlwm.py --list
  ./slim_itlwm.py --card AX210 --dry-run
  ./slim_itlwm.py --card 7265 --scheme AirportItlwm-Sequoia
  ./slim_itlwm.py --keep iwm-7265 --no-build
  ./slim_itlwm.py --restore

Slimming is optional and only saves size. If you keep the wrong firmware the
card will not initialise. When in doubt, use --card (it keeps every firmware
the driver may pick for that card) or the prebuilt release.
"""

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO_URL = "https://github.com/laobamac/itlwm.git"
SDK_URL = "https://github.com/acidanthera/MacKernelSDK.git"
SDK_COMMIT = "3f750085caa17ec3a7880f11c11bf4f48cd6a164"  # pinned in README/CI
SCHEMES = ("AirportItlwm-Tahoe", "AirportItlwm-Sequoia", "itlwm")

FW_REL = Path("itlwm/firmware")
FWBINARY_REL = Path("include/FwBinary.cpp")


def die(msg):
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(1)


def run(cmd, cwd=None, capture=False):
    print("  $", " ".join(str(c) for c in cmd))
    try:
        return subprocess.run(cmd, cwd=cwd, check=True, text=True,
                              capture_output=capture)
    except subprocess.CalledProcessError as e:
        die(f"command failed ({e.returncode}): {' '.join(map(str, cmd))}")
    except FileNotFoundError:
        die(f"command not found: {cmd[0]}")


def human(n):
    for unit in ("B", "KB", "MB", "GB"):
        if n < 1024 or unit == "GB":
            return f"{n:.0f} {unit}" if unit == "B" else f"{n:.1f} {unit}"
        n /= 1024


# --------------------------------------------------------------- source setup
def ensure_source(src):
    if (src / "itlwm.xcodeproj").is_dir():
        return
    if src.exists() and any(src.iterdir()):
        die(f"{src} exists but is not an itlwm checkout")
    print(f"Cloning {REPO_URL} -> {src}")
    run(["git", "clone", "--depth", "1", REPO_URL, str(src)])


def ensure_sdk(src, latest=False):
    """git clone MacKernelSDK into <src>/MacKernelSDK (pinned commit unless latest)."""
    sdk = src / "MacKernelSDK"
    if not (sdk / "Headers").is_dir():
        if sdk.exists() and any(sdk.iterdir()):
            die(f"{sdk} exists but looks incomplete - delete it and re-run")
        print(f"Cloning {SDK_URL} -> {sdk}")
        run(["git", "clone", SDK_URL, str(sdk)])
    if latest:
        return
    head = run(["git", "rev-parse", "HEAD"], cwd=sdk, capture=True).stdout.strip()
    if head != SDK_COMMIT:
        print(f"Checking out pinned MacKernelSDK commit {SDK_COMMIT[:10]} "
              f"(the commit the fork's README/CI builds with)")
        run(["git", "checkout", "-q", "--detach", SDK_COMMIT], cwd=sdk)


# ------------------------------------------------------- card -> firmware map
def parse_cards(src):
    """Return {label: {firmware filenames}} parsed from the driver sources."""
    cards = {}

    def add(label, fw):
        cards.setdefault(label, set()).add(fw)

    fw_re = re.compile(r'fwname\s*=\s*"([^"]+)"')

    # iwx (AX200 and newer, plus CNVi 9560). Firmware is chosen at runtime from
    # PCI id + chip revision via iwl_cfg structs, so map every cfg symbol and
    # every marketing name that points at it. A name search therefore keeps ALL
    # candidate firmware for that card.
    iwx = src / "itlwm/hal_iwx/ItlIwx.cpp"
    if iwx.exists():
        text = iwx.read_text(errors="replace")
        name_syms = dict(re.findall(r'const\s+char\s+(\w+)\s*\[\]\s*=\s*"([^"]+)"', text))
        cfg_fw, cfg_name, cur = {}, {}, None
        for line in text.splitlines():
            m = re.match(r'\s*(?:static\s+)?const\s+struct\s+iwl_cfg\s+(\w+)\s*=\s*\{', line)
            if m:
                cur = m.group(1)
                continue
            if cur:
                m = fw_re.search(line)
                if m:
                    cfg_fw[cur] = m.group(1)
                m = re.search(r'\.name\s*=\s*"([^"]+)"', line)
                if m:
                    cfg_name[cur] = m.group(1)
                if line.startswith("}"):
                    cur = None
        for cfg, fw in cfg_fw.items():
            add(f"[iwx] {cfg}", fw)
            if cfg in cfg_name:
                add(f"[iwx] {cfg_name[cfg]}", fw)
        for cfg, sym in re.findall(r'\b(\w+_cfg)\s*,\s*(\w+)\s*\)', text):
            if cfg in cfg_fw and sym in name_syms:
                add(f"[iwx] {name_syms[sym]}", cfg_fw[cfg])

    # iwm / iwn: switch (...) { case A: case B: ... fwname = "x"; break; }
    # (a case may assign twice, e.g. iwn 6005 -> iwn-6030 or iwn-6005 by PCI id)
    def scan(files, tag, case_re):
        pending = []
        for f in files:
            for line in f.read_text(errors="replace").splitlines():
                m = case_re.search(line)
                if m:
                    pending.append(re.sub(r'_\d+$', '', m.group(1)) if tag == "iwm" else m.group(1))
                    continue
                m = fw_re.search(line)
                if m:
                    for p in pending:
                        add(f"[{tag}] {p}", m.group(1))
                elif re.search(r'\bbreak\s*;', line):
                    pending = []

    scan(sorted((src / "itlwm/hal_iwm").glob("*.cpp")), "iwm",
         re.compile(r'case\s+PCI_PRODUCT_INTEL_(\w+)\s*:'))
    iwn = src / "itlwm/hal_iwn/ItlIwn.cpp"
    if iwn.exists():
        scan([iwn], "iwn", re.compile(r'case\s+IWN_HW_REV_TYPE_(\w+)\s*:'))
    return cards


def list_firmware(fw_dir):
    return {p.name: p.stat().st_size for p in sorted(fw_dir.iterdir()) if p.is_file()}


def cmd_list(cards, files):
    print("Card/config -> firmware (parsed from driver source)")
    print("(iwn entries are chip generations, e.g. 6005 also covers Advanced-N 6205;"
          " iwx entries list every config the driver may pick for that card)")
    width = min(max(len(l) for l in cards) + 2, 72)
    for label in sorted(cards):
        for fw in sorted(cards[label]):
            flag = "" if fw in files else "   (not shipped in itlwm/firmware)"
            print(f"  {label:<{width}} {fw}{flag}")
    print("\nFirmware files in tree")
    for name, size in files.items():
        print(f"  {human(size):>9}  {name}")
    print(f"  {human(sum(files.values())):>9}  total")


# ------------------------------------------------------------------ selection
def resolve_keep(args, cards, files):
    keep = set()
    for q in args.card or []:
        hits = {l: f for l, f in cards.items() if q.lower() in l.lower()}
        if not hits:
            die(f"no card matches '{q}' (try --list; iwn cards are matched by chip "
                f"generation such as 6000/6005/2030/135)")
        print(f"Card '{q}':")
        for label, fws in sorted(hits.items()):
            shipped = fws & set(files)
            print(f"  {label}: {', '.join(sorted(fws))}")
            for fw in sorted(fws - set(files)):
                print(f"    note: {fw} is referenced by the driver but not shipped")
            keep |= shipped
        if len({fw for f in hits.values() for fw in f} & set(files)) > 1:
            print("  note: several firmware match; all are kept because the driver "
                  "picks one at runtime from the chip revision")
    for k in args.keep or []:
        pat = re.compile(re.escape(k) + r'(-\d+(\.ucode)?)?')
        m = {f for f in files if f == k or pat.fullmatch(f)}
        if not m:
            die(f"--keep '{k}' matches no firmware file (try --list)")
        keep |= m
    # AX210-class devices also need <ucode base>.pnvm (same rule as ItlIwx.cpp)
    for f in list(keep):
        if f.endswith(".ucode"):
            pnvm = f.rsplit("-", 1)[0] + ".pnvm"
            if pnvm in files:
                keep.add(pnvm)
    if not keep:
        die("nothing selected: use --card and/or --keep")
    return keep


# ------------------------------------------------------------ slim / restore
def backup_dir(src):
    # Must live OUTSIDE itlwm/firmware: zlib_compress_fw.py walks that dir recursively.
    return src / ".firmware_removed"


def restore(src, quiet=False):
    bak = backup_dir(src)
    if not bak.is_dir():
        if not quiet:
            print("Nothing to restore.")
        return
    fw_dir = src / FW_REL
    n = 0
    for p in bak.iterdir():
        shutil.move(str(p), str(fw_dir / p.name))
        n += 1
    bak.rmdir()
    if not quiet:
        print(f"Restored {n} firmware file(s).")


def slim(src, keep, files, dry):
    fw_dir = src / FW_REL
    drop = sorted(set(files) - keep)
    kept_sz = sum(files[f] for f in keep)
    drop_sz = sum(files[f] for f in drop)
    print("\nKeeping:")
    for f in sorted(keep):
        print(f"  + {human(files[f]):>9}  {f}")
    print(f"Removing {len(drop)} file(s), {human(drop_sz)} "
          f"(firmware {human(kept_sz + drop_sz)} -> {human(kept_sz)}, before zlib)")
    if dry:
        print("(dry run, nothing changed)")
        return
    bak = backup_dir(src)
    bak.mkdir(exist_ok=True)
    for f in drop:
        shutil.move(str(fw_dir / f), str(bak / f))


# ---------------------------------------------------------------------- build
def preflight():
    if sys.platform != "darwin":
        die("building needs macOS + Xcode; use --no-build to only slim the sources")
    if not shutil.which("xcodebuild"):
        die("xcodebuild not found - install Xcode (in /Applications) and run it once")


def build(src, args):
    gen = src / FWBINARY_REL
    if gen.exists():  # fw_gen.sh skips generation when this exists
        gen.unlink()
        print(f"Removed stale {FWBINARY_REL}")
    sha = run(["git", "rev-parse", "--short", "HEAD"], cwd=src,
              capture=True).stdout.strip() if (src / ".git").exists() else "local"
    products = src / "build/products"
    if args.clean:
        shutil.rmtree(src / "build", ignore_errors=True)
    run(["xcodebuild", "-project", "itlwm.xcodeproj", "-scheme", args.scheme,
         "-configuration", args.config, "-jobs", str(args.jobs), "ARCHS=x86_64",
         f"SYMROOT={products}", f"OBJROOT={src / 'build/obj'}",
         "CODE_SIGNING_ALLOWED=NO", f"GIT_COMMIT=_{sha}", "build"], cwd=src)
    kexts = sorted((products / args.config).rglob("*.kext"))
    if not kexts:
        die(f"build finished but no .kext found under {products / args.config}")
    out = Path(args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)
    print("\nResult:")
    for k in kexts:
        dest = out / k.name
        shutil.rmtree(dest, ignore_errors=True)
        shutil.copytree(k, dest, symlinks=True)
        size = sum(p.stat().st_size for p in dest.rglob("*") if p.is_file())
        print(f"  {dest}  ({human(size)})")


# ----------------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", default="./itlwm-laobamac", help="itlwm checkout (cloned if missing)")
    ap.add_argument("--card", action="append", metavar="TEXT",
                    help="keep firmware for cards whose name matches TEXT, e.g. AX210, 7265, 6205")
    ap.add_argument("--keep", nargs="+", metavar="FW",
                    help="keep specific firmware, e.g. iwm-7265 or iwlwifi-so-a0-gf-a0 (.pnvm added automatically)")
    ap.add_argument("--list", action="store_true", help="show cards, firmware and sizes, then exit")
    ap.add_argument("--restore", action="store_true", help="put removed firmware back, then exit")
    ap.add_argument("--dry-run", action="store_true", help="show what would be removed")
    ap.add_argument("--no-build", action="store_true", help="only slim the source tree")
    ap.add_argument("--scheme", default=SCHEMES[0], choices=SCHEMES)
    ap.add_argument("--config", default="Release", choices=("Release", "Debug"))
    ap.add_argument("--out", default="./slimmed-kexts")
    ap.add_argument("--jobs", type=int, default=3)
    ap.add_argument("--clean", action="store_true", help="wipe build/ before compiling")
    ap.add_argument("--sdk-latest", action="store_true",
                    help="use the latest MacKernelSDK instead of the commit pinned by the fork")
    args = ap.parse_args()

    src = Path(args.src).resolve()
    ensure_source(src)
    if not (args.list or args.restore or args.dry_run):
        ensure_sdk(src, args.sdk_latest)

    if args.restore:
        restore(src)
        return

    # always compute the selection from the full firmware set
    if not args.dry_run:
        restore(src, quiet=True)
    fw_dir = src / FW_REL
    if not fw_dir.is_dir():
        die(f"{fw_dir} not found - layout changed?")
    files = list_firmware(fw_dir)
    cards = parse_cards(src)

    if args.list:
        cmd_list(cards, files)
        return

    keep = resolve_keep(args, cards, files)
    if not (args.dry_run or args.no_build):
        preflight()
    slim(src, keep, files, args.dry_run)
    if args.dry_run or args.no_build:
        if args.no_build and not args.dry_run:
            gen = src / FWBINARY_REL
            if gen.exists():
                gen.unlink()
        return
    build(src, args)
    print("\nCopy the kext to EFI/OC/Kexts, reboot and check Wi-Fi. If the card does "
          "not initialise, run --restore or use the prebuilt release.")


if __name__ == "__main__":
    main()
