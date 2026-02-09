# ==============================
# User configuration (ONLY change this)
# ==============================
$FontName = "MyFont"

# ==============================
# Derived paths (do not change)
# ==============================
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir  = Join-Path $ScriptRoot $FontName
$DestDir    = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$RegPath    = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

# Validate source directory
if (-not (Test-Path $SourceDir)) {
    throw "Font directory not found: $SourceDir"
}

# Ensure destination directory exists
New-Item -ItemType Directory -Path $DestDir -Force | Out-Null

# Install all TTF fonts in the directory
Get-ChildItem -Path $SourceDir -Filter *.ttf | ForEach-Object {

    $DestFont = Join-Path $DestDir $_.Name

    # Copy font file
    Copy-Item $_.FullName $DestFont -Force

    # Register font (per-user)
    $FontRegName = "$($_.BaseName) (TrueType)"

    New-ItemProperty `
        -Path $RegPath `
        -Name $FontRegName `
        -PropertyType String `
        -Value $DestFont `
        -Force | Out-Null
}
