# Undertale on GA36 - goodluckOS

A community Undertale port setup for GA36 / R36S clone handhelds.

## Device
- GA36-MB v1.1
- Allwinner A33
- Mali-400
- 512 MB RAM
- goodluckOS 0.1.0

## Requirements
- A compatible ARMHF SDL2 Butterscotch runner
- Your own legally obtained Undertale game files
- goodluckOS

## Installation
1. Obtain the Butterscotch ARMHF runner from:
   https://github.com/ButterscotchRunner/Butterscotch
2. Place the runner as `ports/undertale/butterscotch`.
3. Place your own `data.win` and required game assets in `ports/undertale/`.
4. Copy the port folder to the SD card.
5. Launch Undertale from goodluckOS.

## Screenshots

Undertale running on the GA36-MB (R36S clone) with goodluckOS 0.1.0.

| Intro | Main Menu |
| ----- | --------- |
| ![Undertale intro](screenshots/undertale-ga36-1.jpg.jpeg) | ![Undertale main menu](screenshots/undertale-ga36-2.jpg.jpeg) |

| Gameplay | Name Entry |
| -------- | ---------- |
| ![Undertale gameplay](screenshots/undertale-ga36-3.jpg.jpeg) | ![Undertale name entry](screenshots/undertale-ga36-4.jpg.jpeg) |

| Dialogue | Flowey Battle |
| -------- | ------------- |
| ![Undertale dialogue](screenshots/undertale-ga36-5.jpg.jpeg) | ![Undertale battle with Flowey](screenshots/undertale-ga36-6.jpg.jpeg) |

## Debug overlay
The launcher omits the `--debug` argument to prevent the FPS/RAM debug overlay from appearing.

## Credits
- ButterscotchRunner: https://github.com/ButterscotchRunner/Butterscotch
- Undertale: Toby Fox

This project does not distribute Undertale game assets.
