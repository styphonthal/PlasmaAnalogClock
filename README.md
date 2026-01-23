# PlasmaAnalogClock

This is a configurable clock plasmid/widget for KDE Plasma DE.

Version 1.1 (1/23/26)
- Fixed ToolTips so it updates
- Performance improvements
- Corrected file names and locations
- Updated for latest Plasma 6

Future plans:
- fix color selector
- fix font selector
- add different backgrounds
- Add date?

Three ways to install:

    1. Click on "add widget", go to "Get new", and choose "load from file", you would use the .plasmid file for that
    2. Download the compressed file, and expand in your ~/.local/share/plasma/plasmoids directory
    3. Copy the files directed to your ~/.local/share/plasma/plasmoids directory.

TO RUN: 

Method 1: nothing, it should be installed and selectable

Method 2 and 3:

In terminal type:
kpackagetool6 --type Plasma/Applet --install "directoryYouDownloadedToo"
kquitapp6 plasmashell || true
systemctl --user restart plasma-plasmashell.service
