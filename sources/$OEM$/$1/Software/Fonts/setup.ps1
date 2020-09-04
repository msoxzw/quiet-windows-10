Push-Location $PSScriptRoot

# Download and install the latest Source Han Super OTC
Start-BitsTransfer 'https://github.com/adobe-fonts/source-han-super-otc/releases/latest/download/SourceHan.ttc' (Join-Path $env:SystemRoot 'Fonts')
if (-not $?) {return}

Get-Item '*.reg' | ForEach-Object {reg import $_}


# The default fonts for Chinese, Japanese, and Korean (CJK) languages in Internet Explorer are changed to Source Han
New-Item '..\Config\Registry\Internet Explorer Fonts.reg' -ItemType SymbolicLink -Value 'Internet Explorer.reg' -Force

# The default fonts for Chinese, Japanese, and Korean (CJK) languages in Chromium based browsers are changed to Source Han
'..\Config\Files\LocalAppData', $env:LocalAppData | Get-ChildItem -Filter 'User Data' -Recurse -Directory | Join-Path -ChildPath '*\Preferences' -Resolve | ForEach-Object {-join (Get-Content $_, 'Chromium.json' -Raw) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}

# The default fonts for Chinese, Japanese, and Korean (CJK) languages in Mozilla applications are changed to Source Han
Get-ItemPropertyValue 'HKLM:\Software\Mozilla\*\*\Main' 'Install Directory' | ForEach-Object {Copy-Item 'Mozilla.js' (Join-Path $_ 'defaults\pref\fonts.js')}

Pop-Location
