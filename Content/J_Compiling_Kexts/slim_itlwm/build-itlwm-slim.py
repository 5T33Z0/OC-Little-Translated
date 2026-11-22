#!/usr/bin/env python3
"""
itlwm Slim Builder
Builds itlwm / AirportItlwm kexts that only contain the firmware needed by
your Intel Wi-Fi card, from an isolated copy of an itlwm source checkout.
"""

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT.parent / "itlwm-Slimmed"
BUILDS = ROOT / "Builds"

PROJECT = "itlwm.xcodeproj"
FIRMWARE_SUBDIR = Path("itlwm") / "firmware"
FWBINARY = Path("include") / "FwBinary.cpp"

SDK_URL = "https://github.com/acidanthera/MacKernelSDK.git"
# Commit the fork's README/CI builds with (macOS Sequoia/Tahoe).
SDK_COMMIT = "3f750085caa17ec3a7880f11c11bf4f48cd6a164"

# Card hints (taken from the OC-Little-Translated slimming guide and the
# device tables in the itlwm source). They are only hints: always verify
# your firmware, e.g. via the IOModel property in IORegistryExplorer.
HINTS = {
    "iwn-1000": "Centrino Wireless-N 1000 / 1030",
    "iwn-105": "Centrino Wireless-N 105",
    "iwn-135": "Centrino Wireless-N 135",
    "iwn-2000": "Centrino Wireless-N 2200",
    "iwn-2030": "Centrino Wireless-N 2230",
    "iwn-6000": "Centrino Advanced-N 6200 / Ultimate-N 6300",
    "iwm-3160-17": "Dual Band Wireless-AC 3160",
    "iwm-3168-29": "Dual Band Wireless-AC 3168",
    "iwm-7260-17": "Dual Band Wireless-N / AC 7260",
    "iwm-7265-17": "Dual Band Wireless-AC 7265 / 3165",
    "iwm-8000C-36": "Dual Band Wireless-AC 8260",
    "iwm-8265-36": "Dual Band Wireless-AC 8265 / 8275",
    "iwm-9000-46": "Wireless-AC 9461 / 9462 / 9560",
    "iwm-9260-46": "Wireless-AC 9260",
    "iwlwifi-cc-a0": "Wi-Fi 6 AX200, Killer AX1650",
    "iwlwifi-QuZ-a0-hr-b0": "Wi-Fi 6 AX201 / AX101, Killer AX1650i / AX1675 "
                            "(some AX201 steppings use Qu-* instead)",
    "iwlwifi-ty-a0-gf-a0": "Wi-Fi 6 AX210, Killer AX1675x",
    "iwlwifi-so-a0-gf4-a0": "Wi-Fi 6E AX211, Killer AX1690",
}


def abort(message):
    print(f"\n[ERROR] {message}")
    raise SystemExit(1)


def confirm(prompt, default=True):
    suffix = "[Y/n]" if default else "[y/N]"
    answer = input(f"{prompt} {suffix}: ").strip().lower()
    if not answer:
        return default
    return answer in ("y", "yes")


def directory_size(path):
    return sum(f.stat().st_size for f in path.rglob("*") if f.is_file())


def format_size(size):
    return f"{size / (1024 * 1024):.2f} MB"


# --------------------------------------------------------------------------
# Firmware
# --------------------------------------------------------------------------

def firmware_groups(fw_dir):
    """Group firmware files that belong together.

    iwlwifi-<name>-<ver>.ucode and iwlwifi-<name>.pnvm form one group;
    iwm-* and iwn-* are single files.
    """
    if not fw_dir.is_dir():
        abort(f"Firmware directory not found: {fw_dir}")

    groups = {}
    for file in fw_dir.iterdir():
        if not file.is_file() or file.name.startswith("."):
            continue
        if file.name.endswith(".ucode"):
            key = re.sub(r"-\d+\.ucode$", "", file.name)
        elif file.name.endswith(".pnvm"):
            key = file.name[: -len(".pnvm")]
        else:
            key = file.name
        groups.setdefault(key, []).append(file)

    if not groups:
        abort(f"No firmware files found in {fw_dir}")

    return {k: sorted(groups[k]) for k in sorted(groups, key=str.lower)}


def group_size(files):
    return sum(f.stat().st_size for f in files)


def search_groups(groups, term):
    """All words must appear in the firmware name or the card hint."""
    words = term.lower().split()
    return [
        key for key in groups
        if all(w in f"{key} {HINTS.get(key, '')}".lower() for w in words)
    ]


def show_groups(groups, keys, selected):
    print(f"\nFirmware ({len(keys)}):\n")
    for index, key in enumerate(keys, 1):
        mark = "*" if key in selected else " "
        files = groups[key]
        size = format_size(group_size(files))
        extra = " + pnvm" if any(f.name.endswith(".pnvm") for f in files) else ""
        hint = HINTS.get(key, "")
        line = f" {mark}[{index:3}] {key:<24} {size:>9}{extra}"
        if hint:
            line += f"  <- {hint}"
        print(line)


def parse_numbers(value, count):
    parts = [p for p in re.split(r"[,\s]+", value.strip()) if p]
    if not parts or not all(p.isdigit() for p in parts):
        return None
    numbers = [int(p) for p in parts]
    if any(n < 1 or n > count for n in numbers):
        return None
    return numbers


def pick_from(groups, keys, selected):
    if not keys:
        print("No matching firmware found.")
        return

    show_groups(groups, keys, selected)

    while True:
        value = input(
            "\nSelect number(s), comma-separated (or 'b' to go back): "
        ).strip().lower()
        if value in ("b", "back"):
            return
        numbers = parse_numbers(value, len(keys))
        if numbers is None:
            print("Invalid selection.")
            continue
        for n in numbers:
            key = keys[n - 1]
            if key not in selected:
                selected.append(key)
        return


def select_firmware(groups):
    all_keys = list(groups)
    lookup = {k.lower(): k for k in all_keys}
    selected = []

    while True:
        print("\nFirmware selection")
        if selected:
            print(f"  Selected: {', '.join(selected)}")
        print("  [1] Search firmware or card model")
        print("  [2] List all firmware")
        print("  [3] Continue with selection")
        print("  [4] Clear selection")
        print("  [5] Exit")

        choice = input("\nSelect option: ").strip()

        if choice == "1":
            term = input(
                "\nEnter firmware name or card model (e.g. iwm-9000-46, AX210): "
            ).strip().lower()
            if not term:
                print("Please enter a search term.")
                continue
            if term in lookup:
                key = lookup[term]
                if key not in selected:
                    selected.append(key)
                print(f"Added {key}.")
                continue
            pick_from(groups, search_groups(groups, term), selected)

        elif choice == "2":
            pick_from(groups, all_keys, selected)

        elif choice == "3":
            if selected:
                return selected
            print("Select at least one firmware first.")

        elif choice == "4":
            selected.clear()

        elif choice == "5":
            raise SystemExit(0)

        else:
            print("Invalid option.")


def firmware_label(keys):
    if len(keys) <= 2:
        return "+".join(keys)
    return f"{keys[0]}+{len(keys) - 1}more"


# --------------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------------

def project_targets():
    pbxproj = ROOT / PROJECT / "project.pbxproj"
    if not pbxproj.is_file():
        abort(f"Project file not found: {pbxproj}")

    text = pbxproj.read_text(errors="replace")
    names = re.findall(
        r'Build configuration list for PBXNativeTarget "([^"]+)"', text
    )
    targets = []
    for name in names:
        if name not in targets:
            targets.append(name)

    if not targets:
        abort("No build targets found in the Xcode project.")

    # itlwm first, AirportItlwm-* afterwards in project order
    return sorted(targets, key=lambda t: t != "itlwm")


def select_targets(targets):
    print("\nBuild targets\n")
    for index, target in enumerate(targets, 1):
        print(f"  [{index:2}] {target}")

    while True:
        value = input(
            "\nSelect number(s), comma-separated, 'a' for all targets "
            "or 'q' to exit: "
        ).strip().lower()
        if value in ("q", "quit", "exit"):
            raise SystemExit(0)
        if value in ("a", "all"):
            return list(targets)
        numbers = parse_numbers(value, len(targets))
        if numbers is None:
            print("Invalid selection.")
            continue
        chosen = []
        for n in numbers:
            if targets[n - 1] not in chosen:
                chosen.append(targets[n - 1])
        return chosen


def kext_location(target):
    """Expected product path, following CONFIGURATION_BUILD_DIR in the project."""
    release = OUTPUT / "build" / "Release"
    if target.startswith("AirportItlwm-"):
        label = target.removeprefix("AirportItlwm-")
        return release / label / "AirportItlwm.kext"
    return release / "itlwm.kext"


def final_name(target, fw_label):
    if target.startswith("AirportItlwm-"):
        os_label = target.removeprefix("AirportItlwm-").replace(" ", "")
        return f"AirportItlwm-{os_label}-{fw_label}.kext"
    return f"itlwm-{fw_label}.kext"


# --------------------------------------------------------------------------
# Source handling
# --------------------------------------------------------------------------

def source_version():
    version = "Unknown"
    commit = "Not available"

    if (ROOT / ".git").exists():
        try:
            version = subprocess.run(
                ["git", "describe", "--tags", "--always"],
                cwd=ROOT, capture_output=True, text=True, check=True
            ).stdout.strip()
            commit = subprocess.run(
                ["git", "rev-parse", "--short", "HEAD"],
                cwd=ROOT, capture_output=True, text=True, check=True
            ).stdout.strip()
            return version, commit
        except (subprocess.CalledProcessError, FileNotFoundError):
            pass

    return version, "Source archive (no Git metadata)"


def preflight():
    if sys.platform != "darwin":
        abort("This script must be run on macOS.")
    if shutil.which("xcodebuild") is None:
        abort("xcodebuild not found. Install Xcode and its command line tools.")
    if not (ROOT / PROJECT).exists():
        abort("Run this script from the itlwm repository root.")
    if not (ROOT / FIRMWARE_SUBDIR).is_dir():
        abort(f"Firmware folder missing: {ROOT / FIRMWARE_SUBDIR}")


def git(args, cwd=None, capture=False):
    try:
        result = subprocess.run(
            ["git", *args], cwd=cwd, capture_output=capture, text=True
        )
    except FileNotFoundError:
        abort("git not found. Install the Xcode command line tools "
              "(xcode-select --install).")
    if result.returncode != 0:
        detail = f"\n{result.stderr.strip()}" if capture and result.stderr else ""
        abort(f"git {' '.join(args)} failed "
              f"(exit code {result.returncode}).{detail}")
    return result


def sdk_complete(sdk):
    return (
        (sdk / "Headers").is_dir()
        and (sdk / "Library" / "x86_64" / "libkmod.a").is_file()
    )


def ensure_sdk(latest=False):
    """Clone MacKernelSDK into <root>/MacKernelSDK and pin it to SDK_COMMIT.

    With latest=True an existing or freshly cloned SDK is used as is.
    """
    sdk = ROOT / "MacKernelSDK"

    if not sdk_complete(sdk):
        if sdk.exists() and any(sdk.iterdir()):
            abort(f"{sdk} exists but looks incomplete. "
                  "Delete it and run the script again.")
        print(f"\nMacKernelSDK not found. Cloning {SDK_URL} ...")
        git(["clone", SDK_URL, str(sdk)])
        if not sdk_complete(sdk):
            abort("MacKernelSDK was cloned but looks incomplete.")

    if latest:
        print("Using MacKernelSDK as is (--latest-sdk).")
        return

    if not (sdk / ".git").exists():
        print("MacKernelSDK is not a Git checkout; cannot verify its version.")
        return

    head = git(["rev-parse", "HEAD"], cwd=sdk, capture=True).stdout.strip()
    if head != SDK_COMMIT:
        print(f"\nChecking out pinned MacKernelSDK commit {SDK_COMMIT[:10]} "
              "(the commit the fork's README builds with) ...")
        git(["checkout", "-q", "--detach", SDK_COMMIT], cwd=sdk, capture=True)


def prepare():
    if OUTPUT.exists():
        if not confirm(f"\n{OUTPUT} already exists. Replace it?", default=False):
            abort("Cancelled.")
        shutil.rmtree(OUTPUT)

    print("\nCreating isolated working copy...")
    shutil.copytree(
        ROOT,
        OUTPUT,
        ignore=shutil.ignore_patterns(
            ".git", "build", "Builds", "DerivedData", "__pycache__", ".DS_Store"
        ),
    )

    # A stale generated firmware file would make fw_gen skip regeneration.
    stale = OUTPUT / FWBINARY
    if stale.exists():
        stale.unlink()


def slim_firmware(groups, selected):
    keep = {f.name for key in selected for f in groups[key]}
    fw_dir = OUTPUT / FIRMWARE_SUBDIR

    before = directory_size(fw_dir)
    removed = 0
    for file in fw_dir.iterdir():
        if file.is_file() and file.name not in keep:
            file.unlink()
            removed += 1

    left = sorted(f.name for f in fw_dir.iterdir() if f.is_file())
    if set(left) != keep:
        abort("Firmware folder does not match the selection after slimming.")

    print("\nKept firmware:")
    for name in left:
        print(f"  {name}")
    print(f"\nRemoved {removed} firmware file(s)")
    print(f"Firmware folder: {format_size(before)} -> "
          f"{format_size(directory_size(fw_dir))}")

    return len(keep)


# --------------------------------------------------------------------------
# Building
# --------------------------------------------------------------------------

def run(label, command):
    print(f"\n{label}\n")
    result = subprocess.run(command, cwd=OUTPUT)
    if result.returncode != 0:
        abort(f"{label} failed (exit code {result.returncode}).")


def generate_firmware(expected_count):
    run(
        "Generating firmware data...",
        ["xcodebuild", "-project", PROJECT, "-target", "fw_gen",
         "-configuration", "Release", "-sdk", "macosx"],
    )

    generated = OUTPUT / FWBINARY
    if not generated.is_file():
        abort(f"Firmware generation did not create {FWBINARY}.")

    match = re.search(
        r"const int fwNumber = (\d+);", generated.read_text(errors="replace")
    )
    if not match or int(match.group(1)) != expected_count:
        found = match.group(1) if match else "unknown"
        abort(f"{FWBINARY} contains {found} firmware file(s), "
              f"expected {expected_count}.")


def build_target(target):
    run(
        f"Building {target}...",
        [
            "xcodebuild",
            "-project", PROJECT,
            "-target", target,
            "-configuration", "Release",
            "ARCHS=x86_64",
            "CODE_SIGNING_ALLOWED=NO",
            f"SYMROOT={OUTPUT / 'build'}",
            "build",
        ],
    )

    kext = kext_location(target)
    if not kext.is_dir():
        abort(f"Build completed but expected kext was not found: {kext}")
    return kext


def main():
    parser = argparse.ArgumentParser(
        description="Build itlwm / AirportItlwm kexts with only the "
                    "firmware you need."
    )
    parser.add_argument(
        "--latest-sdk", action="store_true",
        help="use MacKernelSDK as is instead of the pinned commit",
    )
    args = parser.parse_args()

    preflight()
    ensure_sdk(latest=args.latest_sdk)
    version, commit = source_version()

    print("\n==========================================")
    print("             ITLWM SLIM BUILDER")
    print("==========================================")
    print(f"itlwm: {version}")
    print(f"Git:   {commit}")

    groups = firmware_groups(ROOT / FIRMWARE_SUBDIR)
    targets = project_targets()

    selected = select_firmware(groups)
    chosen_targets = select_targets(targets)
    fw_label = firmware_label(selected)

    print("\n==========================================")
    print("             BUILD CONFIGURATION")
    print("==========================================")
    print(f"Firmware:  {', '.join(selected)}")
    print(f"Targets:   {', '.join(chosen_targets)}")
    print(f"itlwm:     {version}")
    print(f"Git:       {commit}")

    keep_working = confirm(
        "\nKeep the slimmed working directory after building?", default=True
    )
    if not confirm("\nProceed with slimming and compiling?", default=True):
        abort("Cancelled.")

    finals = {t: BUILDS / final_name(t, fw_label) for t in chosen_targets}
    existing = [p for p in finals.values() if p.exists()]
    if existing:
        print()
        for path in existing:
            print(f"  {path}")
        if not confirm("These outputs already exist. Replace them?", default=False):
            abort("Cancelled.")

    prepare()
    expected = slim_firmware(groups, selected)
    generate_firmware(expected)

    results = []
    for target in chosen_targets:
        kext = build_target(target)
        BUILDS.mkdir(parents=True, exist_ok=True)
        final = finals[target]
        if final.exists():
            shutil.rmtree(final)
        shutil.copytree(kext, final)
        results.append((final, directory_size(final)))

    print("\n==========================================")
    print("           ITLWM BUILD SUCCESSFUL")
    print("==========================================")
    print(f"Firmware:          {', '.join(selected)}")
    print(f"itlwm:             {version}")
    print()
    for path, size in results:
        print(f"  {path.name}  ({format_size(size)})")
    print(f"\nOutput folder:     {BUILDS}")

    if keep_working:
        print(f"Working directory: {OUTPUT}")
    else:
        shutil.rmtree(OUTPUT)
        print("Working directory: removed")

    print("==========================================")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nCancelled by user.")
        raise SystemExit(130)
