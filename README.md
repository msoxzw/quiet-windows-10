## Make quiet Windows 10

A series of tweaks make Windows 10 as quiet, slim, private as possible.

### Installation

Copy `sources` folder to the root of the installation media. Windows Setup will use
these files automatically during installation.

The recommended Windows 10 direct download location is https://tb.rg-adguard.net/

### Goals

Automatic deployment and encryption

Automatic install, upgrade, and clean when idle by "chocolatey"

All removed apps can be reinstalled via GUI

Well-nigh all tweaked setting can be changed by GUI

As less redundant setting and magic number as possible

### Features

Skip OOBE in the installation

Remove all apps except Microsoft Store

Remove all Windows capabilities except language capabilities

Turn off all startup apps (Prevent OneDrive installation from inception)

Turn off all privacy settings and all app permissions

Clear all shortcuts in start menu, taskbar, and desktop

Provide some software direct download link

### Caveat

Please customize `sources/$OEM$/$1/Software/Config/Wallpaper/img.png` because it will be
set as default desktop background and lock screen image. Furthermore, lock screen image
will be synced with desktop background. Default image is personally preferred high 
resolution picture.

Pay attention to `sources/$OEM$/$1/Software/Install.cmd` since it will automatically
download and install some software with good reputation in the background, including:

`7zip adobereader aria2 ccleaner.portable ffmpeg firefox git hashcheck irfanviewplugins mpv notepadplusplus qbittorrent stubby thunderbird`

Please adjust this application list according to your situation.

e.g. You would like to super high quality video and music playback solution, 
then may install the following software:

`foobar2000 madvr xysubfilter mpc-be or mpc-hc-clsid2`

Mind `sources/$OEM$/$1/Software/Fonts` because it will automatically download, install,
and configure latest "Source Han Super OTC" to improve CJK characters rendering. Please remove
 or rename this folder to avoid it if you do not need it.

### Some useful references

[Windows Setup Command-Line Options](https://docs.microsoft.com/windows-hardware/manufacture/desktop/windows-setup-command-line-options#15)

[Manage connections from Windows 10](https://docs.microsoft.com/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services)

[How to stop Firefox from making automatic connections](https://support.mozilla.org/kb/how-stop-firefox-making-automatic-connections)

[Privacy Tools](https://www.privacytools.io/)

[Windows 10 Tutorial](https://www.tenforums.com/tutorials/)

