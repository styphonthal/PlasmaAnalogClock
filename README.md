Plasma Analog Clock ⏰

A configurable analog clock widget for KDE Plasma 6

✨ Features

Configurable analog clock face

Optional second hand (auto-adjusts refresh rate)

Custom colors for:

Clock face

Hour / minute / second hands

Noon marker & dash marks

Multiple background styles

Font selection for the “12” marker

Optional soft shadow effects

Maintains correct aspect ratio at all sizes

Optimized repainting for low CPU usage

📦 Version

v1.1.0 — January 23, 2026

What’s new

Fixed tooltip time updates

Performance improvements (adaptive repaint timer)

Corrected file names & layout

Fully updated for Plasma 6

🔧 Installation
Method 1 — KDE Widget Loader (Recommended)

Right-click the desktop or panel

Select Add Widgets

Click Get New Widgets

Choose Install from File

Select the .plasmoid file

Method 2 — Manual Install (Extracted Archive)
mkdir -p ~/.local/share/plasma/plasmoids
tar -xzf PlasmaAnalogClock-1.1.0.tar.gz -C ~/.local/share/plasma/plasmoids

Method 3 — Developer Install
kpackagetool6 --type Plasma/Applet --install /path/to/io.github.styphonthal.PlasmaAnalogClock
kquitapp6 plasmashell || true
systemctl --user restart plasma-plasmashell.service

▶ Usage

After installation:

Right-click the desktop or panel

Choose Add Widgets

Search for Plasma Analog Clock

Drag it onto your desktop or panel

Right-click → Configure to customize

🧭 Configuration Options

Show / hide second hand

Background style

Font for noon marker

Clock face fill color

Hand colors

Shadow effects

🚧 Planned Features

Improved color selector

Improved font selector

Additional background styles

Optional date display

🖥️ Requirements

KDE Plasma 6.0+

Qt 6

KPackage support enabled (default in Plasma)

📜 License

GPL-2.0-or-later
