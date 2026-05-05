# KDE Plasma 6 Power Menu

A customizable power menu Plasmoid for KDE Plasma 6 with custom command support.

## About
This extension provides a Powermenu plasmoid. you can easily. add and manage custom shell commands.

## Requirements
- **KDE Plasma 6**: This plasmoid requires the Plasma 6 desktop environment.
- **kpackagetool6**: Required for installation from the command line.
- **plasma5support**: Provides the executable data engine to run custom bash commands asynchronously.
- **plasma-sdk** (Optional): Useful for developers to test the widget using `plasmoidviewer`.

## Installation

### 1. Install Dependencies
Before installing the plasmoid, ensure you have the necessary KDE development and package tools installed on your system.

**Arch Linux and Derivatives (EndeavourOS, Manjaro, etc.)**
```bash
sudo pacman -S kpackage plasma5support
```

**Fedora**
```bash
sudo dnf install kf6-kpackage plasma5support
```

**Ubuntu and Debian Derivatives (Kubuntu, KDE Neon, etc.)**
```bash
sudo apt install kpackagetool plasma5support
```
*(Note: Package names may vary slightly depending on your exact distribution version. `kpackagetool6` is typically included in `kpackage` or `plasma-sdk` packages).*

### 2. Install the Plasmoid

1. Clone or download this repository to your local machine.
2. Open a terminal and navigate to the project directory:
   ```bash
   cd /path/to/KDE-powerMenu
   ```
3. Install the plasmoid using `kpackagetool6`:
   ```bash
   kpackagetool6 -i .
   ```
   *(Note: If you are updating an existing installation, use `kpackagetool6 -u .` instead)*
4. Once installed, right-click on your Plasma panel or desktop, select **Add Widgets**, and search for **Power Menu** to add it to your setup.

## Future Goals
- [ ] Add support for custom global keyboard shortcuts for individual commands.
- [ ] Allow reordering of the custom commands and standard actions.
- [ ] Provide options to selectively hide specific standard power actions entirely.
