# Aroma Launcher

Aroma Launcher is a nostalgic Homebrew Launcher-style frontend for the Wii U, built specifically for the Aroma environment.

It recreates the feel of the classic Wii U Homebrew Launcher while adding support for modern Aroma homebrew formats and a few quality-of-life features.

## Features

- Launch `.wuhb` applications
- Launch `.rpx` applications
- Browse `.elf` applications
- WUHB metadata and icon support
- RPX metadata support through `meta.xml`
- Wii U GamePad touchscreen support
- Animated water background
- Smooth selection and page animations
- Invalid/corrupt WUHB and RPX detection
- Rescan applications without restarting
- Background-only mode
- Classic Homebrew Launcher-inspired mode
- TV and GamePad support

## Supported Formats

### WUHB
Fully supported.

WUHB applications can be browsed, display metadata/icons, and launched directly from Aroma Launcher.

### RPX
Fully supported.

RPX applications can be browsed and launched through Aroma's RPX loader.

### ELF
Browse-only.

ELF files are displayed in Aroma Launcher, but you can't load them in the Launcher.

## Controls

| Button | Action |
| --- | --- |
| D-Pad | Navigate / select applications |
| A | Open / confirm |
| B | Back / return to Wii U Menu |
| L / R | Previous / next page |
| ZL / ZR | Switch between WUHB, RPX and ELF |
| X | Credits |
| + | Rescan applications |
| - | Hide / show the UI |
| Touchscreen | Select applications and confirmation buttons |

When the UI is hidden with **-**, only the animated background is displayed.

Press **-** again to restore the interface.

## Installation

1. Download the latest `.wuhb` file from the Releases page.
2. Create an Aroma Launcher folder inside:

   `/wiiu/apps/`

3. Place the WUHB inside the folder.

Example:

```text
SD Card
└── wiiu
    └── apps
        └── AromaLauncher
            └── AromaLauncher.wuhb