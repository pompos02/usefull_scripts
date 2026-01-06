# this is a script to install a font in your windows machine without installing it globally (user scoped)
#
# Change "MyFont.ttf" with the actual name of the font
$font = "C:\Temp\MyFont.ttf"
$dest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\MyFont.ttf"

New-Item -ItemType Directory `
  -Path "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" `
  -Force | Out-Null

Copy-Item $font $dest -Force

New-ItemProperty `
  -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" `
  -Name "MyFont (TrueType)" `
  -PropertyType String `
  -Value $dest `
  -Force
