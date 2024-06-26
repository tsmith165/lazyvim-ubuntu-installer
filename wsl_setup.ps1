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

# Check if JetBrains Mono Nerd Font is already installed
$fontName = "JetBrainsMono"
$fontInstalled = (New-Object System.Drawing.Text.InstalledFontCollection).Families | Where-Object { $_.Name -like "$fontName*" }

if ($fontInstalled) {
    Write-ColorOutput "JetBrains Mono Nerd Font is already installed. Skipping installation." -ForegroundColor Yellow
} else {
    # Install JetBrains Mono Nerd Font
    Write-ColorOutput "Installing JetBrains Mono Nerd Font..."
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip"
    $fontZipPath = "$env:TEMP\JetBrainsMono.zip"
    $fontExtractPath = "$env:TEMP\JetBrainsMono"

    Write-ColorOutput "Downloading font zip file from: $fontUrl" -ForegroundColor Cyan
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontZipPath

    Write-ColorOutput "Extracting font files to: $fontExtractPath" -ForegroundColor Cyan
    Expand-Archive -Path $fontZipPath -DestinationPath $fontExtractPath -Force

    $fontsToInstall = Get-ChildItem -Path $fontExtractPath -Include '*.ttf', '*.otf' -Recurse
    Write-ColorOutput "Found $($fontsToInstall.Count) font files to install." -ForegroundColor Cyan

    $shell = New-Object -ComObject Shell.Application
    $fontInstallFolder = $shell.Namespace(0x14)

    Write-ColorOutput "Installing fonts to: $($fontInstallFolder.Self.Path)" -ForegroundColor Cyan

    foreach ($font in $fontsToInstall) {
        $fontPath = $font.FullName
        
        Write-ColorOutput "Attempting to install font from: $fontPath" -ForegroundColor Cyan
        
        try {
            $fontInstallFolder.CopyHere($fontPath)
            Write-ColorOutput "Installed font: $($font.Name)" -ForegroundColor Green
        }
        catch {
            Write-ColorOutput "Failed to install font: $($font.Name)" -ForegroundColor Red
            Write-ColorOutput "Error message: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-ColorOutput "Font installation completed. Font files are located at: $fontExtractPath" -ForegroundColor Yellow

    Write-ColorOutput "JetBrains Mono Nerd Font installation completed." -ForegroundColor Green
}

Write-ColorOutput "====== Setup Script Complete =======" -ForegroundColor Green
Stop-Transcript

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

# Download WSL2 Linux Kernel update
$wsl2UpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$wsl2UpdatePath = "$env:USERPROFILE\Downloads\wsl_update_x64.msi"

Write-ColorOutput "Downloading WSL2 Linux Kernel update..."
Invoke-WebRequest -Uri $wsl2UpdateUrl -OutFile $wsl2UpdatePath

if ((Test-Path $wsl2UpdatePath) -and ((Get-Item $wsl2UpdatePath).Length -gt 0)) {
    Write-ColorOutput "WSL2 Linux Kernel update downloaded successfully to: $wsl2UpdatePath" -ForegroundColor Green
} else {
    Write-ColorOutput "Failed to download WSL2 Linux Kernel update." -ForegroundColor Red
    Exit 1
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

    # Copy config from this repo at ./imports/alacritty.toml to the user's alacritty config path
    $alacrittyConfigPath = "$env:USERPROFILE\.config\alacritty\alacritty.toml"
    $alacrittyConfigImportPath = "$PSScriptRoot\imports\alacritty.toml"

    if (-not (Test-Path $alacrittyConfigPath)) {
        Write-ColorOutput "Copying Alacritty config from: $alacrittyConfigImportPath to: $alacrittyConfigPath"
        Copy-Item -Path $alacrittyConfigImportPath -Destination $alacrittyConfigPath
    } else {
        Write-ColorOutput "Alacritty config already exists at: $alacrittyConfigPath. Skipping copy." -ForegroundColor Yellow
    }

    # Set the Alacritty config path in the Windows Registry
    $alacrittyRegistryKey = "HKCU:\Software\Alacritty"
    if (-not (Test-Path $alacrittyRegistryKey)) {
        New-Item -Path $alacrittyRegistryKey -Force | Out-Null
    }
    Set-ItemProperty -Path $alacrittyRegistryKey -Name "config_file" -Value $alacrittyConfigPath

    Write-ColorOutput "Alacritty installed and configured successfully." -ForegroundColor Green
} else {
    Write-ColorOutput "Alacritty is already installed. Skipping..." -ForegroundColor Yellow
}

# Install Ubuntu 22.04 from Microsoft Store
$ubuntuInstalled = (Get-AppxPackage -Name "CanonicalGroupLimited.Ubuntu22.04LTS" -ErrorAction SilentlyContinue)
if (-not $ubuntuInstalled) {
    Write-ColorOutput "Installing Ubuntu 22.04 from Microsoft Store..."
    Start-Process "https://apps.microsoft.com/store/detail/ubuntu-22041-lts/9PN20MSR04DW"

    Write-ColorOutput "Ubuntu 22.04 installation started. Complete the installation manually." -ForegroundColor Yellow
} else {
    Write-ColorOutput "Ubuntu 22.04 is already installed. Skipping..." -ForegroundColor Yellow
}

Write-ColorOutput "====== Setup Script Complete =======" -ForegroundColor Green

# Write the post-reboot steps to a text file at C:/wsl_setup_post_reboot.txt
$rebootInstructions = @"
Please follow these manual steps to complete the setup:
1. Reboot your system to apply/load the WSL configuration.
2. Run the following command to set WSL2 as the default version: wsl --set-default-version 2
3. Install the WSL2 Linux Kernel update by running the MSI installer: $wsl2UpdatePath
4. Install the Ubuntu 22.04 LTS app from the Microsoft Store.
5. Open the Ubuntu 22.04 LTS app and configure user/password.
6. Clone the LazyVim Ubuntu Installer repository:
   a. Open the Ubuntu 22.04 LTS app.
   b. Switch to the root user if needed: sudo su
   c. Run the following command to clone the repository:
      sudo git clone https://github.com/tsmith165/lazyvim-ubuntu-installer.git /main/scripts/lazyvim-ubuntu-installer/
   d. Navigate to the cloned repository: cd /main/scripts/lazyvim-ubuntu-installer/
   e. Run the install script: ./setup_wsl_ubuntu_lazyvim.sh
"@

$rebootInstructionsPath = "C:\wsl_setup_post_reboot.txt"
Set-Content -Path $rebootInstructionsPath -Value $rebootInstructions

# Loop the instructions and display them in the console with yellow color
$rebootInstructions -split "`n" | ForEach-Object {
    Write-Host $_ -ForegroundColor Yellow
}

Write-ColorOutput "Post-reboot setup instructions saved to: $rebootInstructionsPath" -ForegroundColor Green