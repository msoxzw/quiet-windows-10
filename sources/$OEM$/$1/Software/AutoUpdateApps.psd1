@{
  'adobereader' = 'Adobe\Reader\Install.ps1'
  'microsoft-edge' = {& 'Chromium\Install.ps1' -Product edge -SystemLevel}
  'microsoft-edge-insider' = {& 'Chromium\Install.ps1' -Product edge -Channel beta -SystemLevel}
  'microsoft-edge-insider-dev' = {& 'Chromium\Install.ps1' -Product edge -Channel dev -SystemLevel}
  'microsoft-edge-insider-canary' = {& 'Chromium\Install.ps1' -Product edge -Channel canary}
  'firefox' = {& 'Mozilla\Install.ps1' -Product firefox}
  'firefox-beta' = {& 'Mozilla\Install.ps1' -Product firefox -Channel beta}
  'firefox-dev' = {& 'Mozilla\Install.ps1' -Product firefox -Channel aurora}
  'firefox-nightly' = {& 'Mozilla\Install.ps1' -Product firefox -Channel nightly}
  'googlechrome' = {& 'Chromium\Install.ps1' -Product chrome -SystemLevel}
  'googlechrome.beta' = {& 'Chromium\Install.ps1' -Product chrome -Channel beta -SystemLevel}
  'googlechrome.dev' = {& 'Chromium\Install.ps1' -Product chrome -Channel dev -SystemLevel}
  'googlechrome.canary' = {& 'Chromium\Install.ps1' -Product chrome -Channel canary}
  'thunderbird' = {& 'Mozilla\Install.ps1' -Product thunderbird}
  'thunderbird-beta' = {& 'Mozilla\Install.ps1' -Product thunderbird -Channel beta}
  'thunderbird-nightly' = {& 'Mozilla\Install.ps1' -Product thunderbird -Channel nightly}
}