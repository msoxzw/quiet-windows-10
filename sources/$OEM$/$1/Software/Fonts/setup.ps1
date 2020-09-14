Push-Location $PSScriptRoot

# Download and install the latest Source Han Super OTC
$source = 'https://github.com/adobe-fonts/source-han-super-otc/releases/latest/download/SourceHan.ttc'
$destination = Join-Path $env:SystemRoot 'Fonts' | Join-Path -ChildPath (Split-Path $source -Leaf)
do {
    bitsadmin /transfer 'Downloading Source Han Super OTC' /dynamic $source $destination
} until ($?)

Get-Item '*.reg' | ForEach-Object {reg import $_}


# The default fonts for Chinese, Japanese, and Korean (CJK) languages in Internet Explorer are changed to Source Han
New-Item '..\Config\Registry\Internet Explorer Fonts.reg' -ItemType SymbolicLink -Value 'Internet Explorer.reg' -Force

# The default fonts for Chinese, Japanese, and Korean (CJK) languages in Chromium based browsers are changed to Source Han
'..\Config\Files\LocalAppData', $env:LocalAppData | Get-ChildItem -Filter 'User Data' -Recurse -Directory | Join-Path -ChildPath '*\Preferences' -Resolve | ForEach-Object {-join (Get-Content $_, 'Chromium.json' -Raw) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}

# The default fonts for Chinese, Japanese, and Korean (CJK) languages in Mozilla applications are changed to Source Han
Get-ItemPropertyValue 'HKLM:\Software\Mozilla\*\*\Main' 'Install Directory' | ForEach-Object {Copy-Item 'Mozilla.js' (Join-Path $_ 'defaults\pref\fonts.js')}

Pop-Location
