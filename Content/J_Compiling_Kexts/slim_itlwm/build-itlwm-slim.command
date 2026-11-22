#!/bin/bash
# Double-click launcher for the itlwm Slim Builder.
# Keep this file in the same folder as build-itlwm-slim.py (the itlwm root).

cd "$(dirname "$0")" || exit 1

if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 not found. Install the Xcode command line tools first:"
    echo "  xcode-select --install"
    echo
    read -n 1 -s -r -p "Press any key to close this window..."
    exit 1
fi

python3 build-itlwm-slim.py "$@"
status=$?

echo
read -n 1 -s -r -p "Press any key to close this window..."
echo
exit $status
