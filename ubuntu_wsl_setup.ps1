# Set up logging
$logFile = "$env:TEMP\setup_log.txt"
Start-Transcript -Path $logFile -Append

function Write-ColorOutput {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [String]$Text,
        [Parameter(Mandatory=$false, Position=1)]
        [ConsoleColor]$ForegroundColor = $Host.UI.RawUI.ForegroundColor
    )
    $currentForegroundColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Text
    $Host.UI.RawUI.ForegroundColor = $currentForegroundColor
}


Write-ColorOutput "====== Setup Script Start =======" -ForegroundColor Green

# Install JetBrains Mono Nerd Font with elevated permissions
Write-ColorOutput "Installing JetBrains Mono Nerd Font..."
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip"
$fontZipPath = "$env:TEMP\JetBrainsMono.zip"
$fontInstallPath = "$env:WINDIR\Fonts"

Invoke-WebRequest -Uri $fontUrl -OutFile $fontZipPath

$fontInstallProcess = Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", "Expand-Archive -Path '$fontZipPath' -DestinationPath '$fontInstallPath' -Force" -Verb RunAs -PassThru
$fontInstallProcess.WaitForExit()

if ($fontInstallProcess.ExitCode -eq 0) {
    Remove-Item $fontZipPath
    Write-ColorOutput "JetBrains Mono Nerd Font installed successfully." -ForegroundColor Green
} else {
    Write-ColorOutput "Failed to install JetBrains Mono Nerd Font." -ForegroundColor Red
}

# Enable WSL
$wslEnabled = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled"
$vmPlatformEnabled = (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq "Enabled"

if (-not $wslEnabled -or -not $vmPlatformEnabled) {
    Write-ColorOutput "Enabling WSL and Virtual Machine Platform..."
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    Write-ColorOutput "WSL and Virtual Machine Platform enabled. Restart required." -ForegroundColor Yellow
    $restartNeeded = $true
} else {
    Write-ColorOutput "WSL and Virtual Machine Platform are already enabled. Skipping..." -ForegroundColor Yellow
}

# Download and Install WSL2 Linux Kernel
$wsl2Installed = (Get-ChildItem -Path "$env:ProgramFiles\Linux Integration" -Filter "*lxss*" -Recurse -ErrorAction SilentlyContinue)
if (-not $wsl2Installed) {
    Write-ColorOutput "Downloading and installing WSL2 Linux Kernel..."
    $wsl2UpdateUrl = "https://github.com/your-repo/wsl_update_x64.msi"  # Replace with the URL to the WSL2 update file in your repo
    $wsl2UpdatePath = "$env:TEMP\wsl_update_x64.msi"

    Invoke-WebRequest -Uri $wsl2UpdateUrl -OutFile $wsl2UpdatePath
    Start-Process msiexec.exe -Wait -ArgumentList "/i $wsl2UpdatePath /quiet"
    Remove-Item $wsl2UpdatePath

    Write-ColorOutput "WSL2 Linux Kernel installed successfully." -ForegroundColor Green
} else {
    Write-ColorOutput "WSL2 Linux Kernel is already installed. Skipping..." -ForegroundColor Yellow
}

# Install Scoop
$scoopInstalled = (Get-Command scoop -ErrorAction SilentlyContinue)
if (-not $scoopInstalled) {
    Write-ColorOutput "Installing Scoop package manager..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    $env:PATH += ";$env:USERPROFILE\scoop\shims"

    Write-ColorOutput "Scoop installed successfully." -ForegroundColor Green
} else {
    Write-ColorOutput "Scoop is already installed. Skipping..." -ForegroundColor Yellow
}

# Install and Configure Alacritty
$alacrittyInstalled = (Get-Command alacritty -ErrorAction SilentlyContinue)
if (-not $alacrittyInstalled) {
    Write-ColorOutput "Installing and configuring Alacritty..."
    scoop install alacritty
    scoop bucket add extras
    scoop install alacritty-themes

    $alacrittyConfigPath = "$env:USERPROFILE\.config\alacritty\alacritty.yml"
    $alacrittyConfig = @"
#background_opacity = 1.0
#bracketed_paste = false

[colors.bright]
black = "#665c54"
blue = "#83a598"
cyan = "#8ec07c"
green = "#b8bb26"
magenta = "#d3869b"
red = "#fb4934"
white = "#fbf1c7"
yellow = "#fabd2f"

[colors.normal]
black = "#1d2021"
blue = "#83a598"
cyan = "#8ec07c"
green = "#b8bb26"
magenta = "#d3869b"
red = "#fb4934"
white = "#d5c4a1"
yellow = "#fabd2f"

[colors.primary]
background = "#1d2021"
foreground = "#d5c4a1"

[cursor]
style = "Block"
unfocused_hollow = true

[font]
size = 14.0

[font.bold]
family = "JetBrainsMono Nerd Font"
style = "Bold"

[font.glyph_offset]
x = 0
y = 0

[font.italic]
family = "JetBrainsMono Nerd Font"
style = "Italic"

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"

[font.offset]
x = 0
y = 0

[[keyboard.bindings]]
action = "Paste"
key = "V"
mods = "Control|Shift"

[[keyboard.bindings]]
action = "Copy"
key = "C"
mods = "Control|Shift"

[[keyboard.bindings]]
action = "Quit"
key = "Q"
mods = "Command"

[[keyboard.bindings]]
action = "SpawnNewInstance"
key = "N"
mods = "Command"

[mouse]
hide_when_typing = true

[window]
startup_mode = "Windowed"

[window.dimensions]
columns = 0
lines = 0

[window.padding]
x = 0
y = 0
"@

    New-Item -Path "$env:USERPROFILE\.config\alacritty" -ItemType Directory -Force | Out-Null
    Set-Content -Path $alacrittyConfigPath -Value $alacrittyConfig

    Write-ColorOutput "Alacritty installed and configured successfully." -ForegroundColor Green
} else {
    Write-ColorOutput "Alacritty is already installed. Skipping..." -ForegroundColor Yellow
}

# Install Ubuntu 22.04 from Microsoft Store
$ubuntuInstalled = (Get-AppxPackage -Name "CanonicalGroupLimited.Ubuntu22.04LTS" -ErrorAction SilentlyContinue)
if (-not $ubuntuInstalled) {
    Write-ColorOutput "Installing Ubuntu 22.04 from Microsoft Store..."
    Start-Process "https://apps.microsoft.com/detail/9pn20msr04dw"

    Write-ColorOutput "Ubuntu 22.04 installation started. Complete the installation manually." -ForegroundColor Yellow
} else {
    Write-ColorOutput "Ubuntu 22.04 is already installed. Skipping..." -ForegroundColor Yellow
}

# Wrap up
if ($restartNeeded) {
    Write-ColorOutput "A restart is required to complete the setup. Please restart your computer." -ForegroundColor Yellow
}

Write-ColorOutput "====== Setup Script Complete =======" -ForegroundColor Green
Stop-Transcript