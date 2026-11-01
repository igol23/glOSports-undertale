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

Undertale running on GA36-MB with goodluckOS 0.1.0.

<p align="center">
  <img src="screenshots/undertale-ga36-1.jpg" width="32%" alt="Undertale intro">
  <img src="screenshots/undertale-ga36-2.jpg" width="32%" alt="Undertale main menu">
  <img src="screenshots/undertale-ga36-3.jpg" width="32%" alt="Undertale gameplay">
</p>
<p align="center">
  <img src="screenshots/undertale-ga36-4.jpg" width="32%" alt="Undertale name entry">
  <img src="screenshots/undertale-ga36-5.jpg" width="32%" alt="Undertale dialogue">
  <img src="screenshots/undertale-ga36-6.jpg" width="32%" alt="Flowey battle">
</p>

## Debug overlay
The launcher omits the `--debug` argument to prevent the FPS/RAM debug overlay from appearing.

## Credits
- ButterscotchRunner: https://github.com/ButterscotchRunner/Butterscotch
- Undertale: Toby Fox

This project does not distribute Undertale game assets.
