#!/usr/bin/env bash
# Prepare an Undertale installation ZIP for goodluckOS.
# Uses Cobalt's precompiled Butterscotch ARMHF runtime and the user's own data.win.

set -Eeuo pipefail

ASSET_URL='https://github.com/cobaltgit/Butterscotch/releases/download/onion-v2/Undertale_MiyooMini_Onion_v2.zip'
ASSET_SHA256='ee002450a92e30a75ebde1c395d186a8d14eea1eb1983c581cd7a3dbb371fc23'

STEAM_GAME_DIR="${UNDERTALE_GAME_DIR:-/mnt/c/Program Files (x86)/Steam/steamapps/common/Undertale}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ZIP_OUT="${UNDERTALE_PACKAGE_OUT:-$SCRIPT_DIR/Undertale-goodluckOS.zip}"

WORK="$(mktemp -d -t undertale-glos.XXXXXX)"
cleanup() {
    rm -rf -- "$WORK"
}
trap cleanup EXIT

fail() {
    printf '\nERROR: %s\n' "$*" >&2
    exit 1
}

printf 'Undertale / goodluckOS package preparation\n'
printf 'Steam game directory: %s\n' "$STEAM_GAME_DIR"

# Check the user's game data.
[[ -f "$STEAM_GAME_DIR/data.win" ]] ||
    fail "data.win not found: $STEAM_GAME_DIR/data.win"

# Check required tools.
for tool in python3 unzip sha256sum file stat du; do
    command -v "$tool" >/dev/null 2>&1 ||
        fail "$tool is required."
done

if ! command -v curl >/dev/null 2>&1 &&
   ! command -v wget >/dev/null 2>&1; then
    fail "curl or wget is required."
fi

mkdir -p \
    "$WORK/download" \
    "$WORK/extracted" \
    "$WORK/package/.local/share/applications" \
    "$WORK/package/ports/undertale"

ARCHIVE="$WORK/download/Undertale_MiyooMini_Onion_v2.zip"

printf '\n[1/5] Downloading Butterscotch runtime...\n'

if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 --retry-delay 2 "$ASSET_URL" -o "$ARCHIVE"
else
    wget -O "$ARCHIVE" "$ASSET_URL"
fi

printf '\nVerifying archive SHA256...\n'
printf '%s  %s\n' "$ASSET_SHA256" "$ARCHIVE" | sha256sum -c -

printf '\n[2/5] Extracting and checking ARM runner...\n'

unzip -q "$ARCHIVE" -d "$WORK/extracted"

mapfile -d '' RUNNERS < <(
    find "$WORK/extracted" -type f -name butterscotch -print0
)

((${#RUNNERS[@]} > 0)) ||
    fail "The archive does not contain a butterscotch executable."

RUNNER="${RUNNERS[0]}"
RUNNER_DIR="$(dirname -- "$RUNNER")"
FILE_INFO="$(file "$RUNNER" 2>/dev/null || true)"

printf '%s\n' "$FILE_INFO"

[[ "$FILE_INFO" == *'ELF 32-bit'* && "$FILE_INFO" == *'ARM'* ]] ||
    fail "The runner is not a 32-bit ARM ELF executable."

DATA_SIZE="$(stat -c '%s' "$STEAM_GAME_DIR/data.win")"

((DATA_SIZE > 1000000)) ||
    fail "data.win looks unexpectedly small ($DATA_SIZE bytes)."

# Preserve all runtime files shipped alongside the executable.
cp -a "$RUNNER_DIR/." "$WORK/package/ports/undertale/"

cp -f \
    "$STEAM_GAME_DIR/data.win" \
    "$WORK/package/ports/undertale/data.win"

chmod +x "$WORK/package/ports/undertale/butterscotch"

printf '\n[3/5] Creating goodluckOS launcher and Puppy entry...\n'

cat > "$WORK/package/.local/share/applications/undertale.puppy" <<'PUPPY'
[Entry]
CATEGORY=Games
NAME=Undertale
DESCRIPTION=Undertale - Butterscotch
COMMAND=sh /home/player/ports/undertale/start-undertale.sh
PUPPY

cat > "$WORK/package/ports/undertale/start-undertale.sh" <<'LAUNCHER'
#!/bin/sh

PORT_DIR="/home/player/ports/undertale"
DEBUG_LOG="/home/player/undertale-launcher-debug.log"

exec >> "$DEBUG_LOG" 2>&1

echo "===== UNDERTALE DEBUG ====="
date
echo "HOME=$HOME"
uname -a

echo "===== DOSYA KONTROLÜ ====="
for p in "$PORT_DIR" "$PORT_DIR/butterscotch" "$PORT_DIR/data.win"; do
    [ -e "$p" ] && ls -ld "$p" || echo "EKSIK: $p"
done

[ -d "$PORT_DIR" ] || exit 90
cd "$PORT_DIR" || exit 90

[ -f "$PORT_DIR/data.win" ] || exit 92
[ -f "$PORT_DIR/butterscotch" ] || exit 91

chmod +x "$PORT_DIR/butterscotch"

# Keep save files on the HOME partition.
mkdir -p "$PORT_DIR/saves"

export SDL_VIDEODRIVER=kmsdrm

echo "===== KAYIT KONUMU ====="
echo "$PORT_DIR/saves"

echo "===== BUTTERSCOTCH BAŞLIYOR ====="

# Use an if statement so a non-zero game exit code is logged
# instead of terminating the launcher before RESULT is assigned.
if "$PORT_DIR/butterscotch" \
    --lazy-rooms \
    --lazy-textures \
    --disable-log-colours \
    --save-folder "$PORT_DIR/saves" \
    "$PORT_DIR/data.win"
then
    RESULT=0
else
    RESULT=$?
fi

echo "===== EXIT CODE: $RESULT ====="
exit "$RESULT"
LAUNCHER

chmod +x "$WORK/package/ports/undertale/start-undertale.sh"

cat > "$WORK/package/ports/undertale/BUILD-REPORT.txt" <<REPORT
Runner release: cobaltgit/Butterscotch onion-v2
Archive SHA256: $ASSET_SHA256

Runner:
$FILE_INFO

Game data:
$(file "$WORK/package/ports/undertale/data.win")
$(stat -c 'data.win size: %s bytes' "$WORK/package/ports/undertale/data.win")

Launcher:
start-undertale.sh

Save directory:
ports/undertale/saves/

Debug log:
/home/player/undertale-launcher-debug.log
REPORT

printf '\n[4/5] Validating package...\n'

[[ -x "$WORK/package/ports/undertale/butterscotch" ]] ||
    fail "Runner executable is missing."

[[ -s "$WORK/package/ports/undertale/data.win" ]] ||
    fail "data.win is missing or empty."

[[ -s "$WORK/package/ports/undertale/start-undertale.sh" ]] ||
    fail "Launcher is missing."

[[ -s "$WORK/package/.local/share/applications/undertale.puppy" ]] ||
    fail "Puppy entry is missing."

printf '\n[5/5] Creating installation ZIP...\n'

python3 - "$WORK/package" "$ZIP_OUT" <<'PY'
import stat
import sys
import zipfile
from pathlib import Path

root = Path(sys.argv[1])
output = Path(sys.argv[2])

output.parent.mkdir(parents=True, exist_ok=True)

if output.exists():
    output.unlink()

with zipfile.ZipFile(
    output,
    "w",
    compression=zipfile.ZIP_DEFLATED,
    compresslevel=6
) as archive:
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue

        relative = path.relative_to(root).as_posix()
        info = zipfile.ZipInfo.from_file(path, relative)

        # Preserve Unix file permissions, including executable bits.
        info.create_system = 3
        mode = stat.S_IFREG | stat.S_IMODE(path.stat().st_mode)
        info.external_attr = mode << 16

        with path.open("rb") as source:
            archive.writestr(
                info,
                source.read(),
                compress_type=zipfile.ZIP_DEFLATED
            )
PY

printf '\nDONE\n'
printf 'Package: %s\n' "$ZIP_OUT"
printf 'Size: '
du -h "$ZIP_OUT" | awk '{print $1}'

printf '\nArchive contents:\n'
unzip -l "$ZIP_OUT"

printf '\nExtract this ZIP into the root of the goodluckOS HOME partition.\n'
