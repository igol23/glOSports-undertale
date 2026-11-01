# Building the Undertale goodluckOS Package

This project uses a precompiled ARMHF version of Butterscotch. It does not currently compile Butterscotch from source.

## 1. Requirements

- Linux or WSL2 with Ubuntu
- Python 3
- `curl` or `wget`
- `unzip`
- `sha256sum`
- `file`
- A legally obtained Undertale v1.08 Windows game installation

Install the required tools on Ubuntu:

```bash
sudo apt update
sudo apt install -y python3 curl unzip coreutils file
```

## 2. Butterscotch Runtime

This project uses the precompiled Undertale-specific runtime from Cobalt's Butterscotch fork:

- Repository: https://github.com/cobaltgit/Butterscotch
- Release: `onion-v2`
- Archive: `Undertale_MiyooMini_Onion_v2.zip`

The downloaded archive is verified using SHA256 before extraction.

Expected SHA256:

```text
ee002450a92e30a75ebde1c395d186a8d14eea1eb1983c581cd7a3dbb371fc23
```

The extracted executable is checked to ensure it is a 32-bit ARM ELF binary.

The original runtime files are preserved, including the SDL library shipped with the archive.

**Important:** The Butterscotch executable is precompiled by the upstream project. This repository does not currently provide instructions for compiling Butterscotch from source.

## 3. Prepare the Package

The package preparation helper is:

```text
prepare-undertale-goodluckOS.sh
```

After obtaining this script from the repository, run:

```bash
chmod +x prepare-undertale-goodluckOS.sh
./prepare-undertale-goodluckOS.sh
```

By default, the script looks for the Steam game installation at:

```text
/mnt/c/Program Files (x86)/Steam/steamapps/common/Undertale
```

If your game is installed elsewhere, set `UNDERTALE_GAME_DIR`:

```bash
UNDERTALE_GAME_DIR="/path/to/Undertale" ./prepare-undertale-goodluckOS.sh
```

The output ZIP location can be customized with `UNDERTALE_PACKAGE_OUT`.

## 4. Generated Package

The helper creates an installation ZIP containing the Puppy launcher entry, the Butterscotch runtime files, the user's `data.win`, and the goodluckOS launcher.

The package is designed to be extracted into the root of the goodluckOS HOME partition.

## 5. Target Device

Tested target configuration:

- GA36-MB v1.2
- Allwinner A23
- Mali-400 GPU
- 512 MB RAM
- goodluckOS 0.1.0

## 6. Notes

- Users must provide their own legally obtained Undertale game files.
- This repository does not distribute Undertale game assets.
- Butterscotch is a work in progress; compatibility and performance may vary.
- This is a package preparation guide, not a source compilation guide.
