# Plasma Analog Clock

A configurable analog clock widget (plasmoid) for KDE Plasma 6.

<p align="center">
  <img src="contents/ui/pinkClock.png" width="220" alt="Plasma Analog Clock">
</p>

## Features

- Configurable analog clock face
- Optional second hand (adaptive refresh rate)
- Custom colors:
  - Clock face
  - Hour, minute, and second hands
  - Noon marker and dash marks
- Multiple background styles
- Selectable font for the “12” marker
- Optional shadow effects
- Preserves correct aspect ratio at all sizes
- Optimized repainting for low CPU usage

## Version

**v1.1.0** — January 23, 2026

### Changes
- Fixed tooltip time updates
- Performance improvements
- Corrected file names and directory layout
- Updated for KDE Plasma 6

## Installation

### Method 1 — Install from file (recommended)

1. Right-click the desktop or panel
2. Select **Add Widgets**
3. Click **Get New Widgets**
4. Choose **Install from File**
5. Select the `.plasmoid` file

### Method 2 — Manual install (extracted archive)

Extract into:

~/.local/share/plasma/plasmoids/


### Method 3 — Developer install

kpackagetool6 --type Plasma/Applet --install /path/to/io.github.styphonthal.PlasmaAnalogClock
kquitapp6 plasmashell || true
systemctl --user restart plasma-plasmashell.service


## Usage

After installation:

- Open **Add Widgets**
- Search for **Plasma Analog Clock**
- Drag it onto the desktop or panel
- Right-click → **Configure** to customize

## Configuration Options

- Show or hide second hand
- Background style
- Noon font selection
- Clock face color
- Hand colors
- Shadow effects

## Planned Improvements

- Configurable hand shapes
- Different Effects outside of shadow
- Additional background styles
- Optional date display
- Smooth hand animation option
- Preset themes
- AM/PM setting

## Requirements

- KDE Plasma 6.0 or newer
- Qt 6

## License

GPL-2.0-or-later
