## Make quiet Windows 10

A series of tweaks make Windows 10 as quiet, slim, private as possible.

### Installation

Drag and drop a Windows disc image to the
[`Drag and drop a disc image to create installation media.cmd`](https://github.com/msoxzw/quiet-windows-10/blob/master/Drag%20and%20drop%20a%20disc%20image%20to%20create%20installation%20media.cmd)
to create installation media. If the installation media exists, just copy
[`sources`](https://github.com/msoxzw/quiet-windows-10/tree/master/sources)
folder to its root directory. Windows Setup will use these files automatically during installation.

The recommended Windows direct download location is https://tb.rg-adguard.net/, which is identical to
[`Windows Disc Image.url`](https://github.com/msoxzw/quiet-windows-10/blob/master/Windows%20Disc%20Image.url).

Window Education edition is recommended, because it is best concerning privacy.

### Goals

Automatic deployment and encryption

Automatic install, upgrade, and clean when idle by
[Chocolatey](https://chocolatey.org/) and [CCleaner](https://www.ccleaner.com/)

All removed apps can be reinstalled via GUI

Well-nigh all tweaked setting can be changed by GUI

As less redundant setting and magic number as possible

### Features

Skip OOBE in the installation

Remove all apps except Microsoft Edge and Microsoft Store

Turn off all startup apps (Prevent OneDrive installation from inception)

Turn off all privacy settings and all app permissions

Clear all shortcuts in start menu, taskbar, and desktop

Provide some software direct download link, [Microsoft Office automatic installation](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Microsoft/Office),
and configurations that focus on privacy and quiet, including:
[7-Zip](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/7-Zip.reg),
[Acrobat Reader DC](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/Acrobat%20Reader%20DC.reg),
[aria2](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/USERPROFILE/.aria2),
[bash](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/USERPROFILE/.bash_profile),
[CCleaner](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/CCleaner.reg),
[Chromium based browsers](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Chromium),
[Firefox](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Mozilla),
[Git](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/System/Git.reg),
[HashCheck Shell Extension](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/HashCheck.reg),
[Intel Bluetooth](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/Specific/Intel%20Bluetooth.reg),
[Intel Graphics](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/Specific/Intel%20Graphics.reg),
[Internet Explorer](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/Internet%20Explorer.reg),
[Internet Explorer Tracking Protection Lists](https://github.com/msoxzw/quiet-windows-10/tree/master/sources/%24OEM%24/%241/Software/Microsoft/Internet%20Explorer),
[IPython](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/USERPROFILE/.ipython),
[IrfanView](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/AppData/IrfanView),
[JetBrains IDE](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/USERPROFILE/.idea),
[madVR](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/settings.bin),
[Microsoft Edge Legacy](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/Microsoft%20Edge.reg),
[MPC-BE and MPC-HC](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Media%20Player%20Classic.reg),
[mpv](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/AppData/mpv),
[Notepad++](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/AppData/Notepad++),
[Nvidia Graphics](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/Specific/Nvidia%20Graphics.reg),
[qBittorrent](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Files/AppData/qBittorrent),
[Thunderbird](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Mozilla),
[Windows Media Player](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Registry/Windows%20Media%20Player.reg).

### Caveat

Please customize [`sources/$OEM$/$1/Software/Config/Wallpaper/img.png`](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Config/Wallpaper/img.png)
because it will be set as default desktop background and lock screen image. Furthermore, lock screen image
will be synced with desktop background. Default image is personally preferred high resolution picture.

Pay attention to [`sources/$OEM$/$1/Software/Install.ps1`](https://github.com/msoxzw/quiet-windows-10/blob/master/sources/%24OEM%24/%241/Software/Install.ps1#L3)
since it will automatically download and install some software with good reputation in the background, including:

`7zip adobereader aria2 ccleaner.portable firefox git hashcheck irfanviewplugins mpv notepadplusplus qbittorrent thunderbird`

Please adjust this application list according to your situation.

e.g. You would like to super high quality video and music playback solution, 
then may install the following software:

`choco install foobar2000 madvr xysubfilter mpc-be -y` or `choco install foobar2000 madvr xysubfilter mpc-hc-clsid2 -y`

### Some useful references

[Windows Setup Command-Line Options](https://docs.microsoft.com/windows-hardware/manufacture/desktop/windows-setup-command-line-options#15)

[Manage connections from Windows 10](https://docs.microsoft.com/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services)

[How to stop Firefox from making automatic connections](https://support.mozilla.org/kb/how-stop-firefox-making-automatic-connections)

[Privacy Tools](https://www.privacytools.io/)

[Windows 10 Tutorials](https://www.tenforums.com/tutorials/)

