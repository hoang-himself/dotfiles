# Run this script in the latest PowerShell

# -----------------------------------------------------------------------------
# Self elevate administrative permissions in this script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# -----------------------------------------------------------------------------
# Set a new computer name
# $computerName = Read-Host 'Enter New Computer Name'
# Rename-Computer -NewName $computerName

function Uninstall-Bloat() {
  # -----------------------------------------------------------------------------
  # Remove a few pre-installed UWP applications
  # To list all appx packages:
  # Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
  $uwpRubbishApps = @(
    "king.com.CandyCrushFriends",
    "Microsoft.3DBuilder",
    "Microsoft.Print3D",
    "Microsoft.BingNews",
    "Microsoft.OneConnect",
    "Microsoft.Microsoft3DViewer",
    "HolographicFirstRun",
    "Microsoft.MixedReality.Portal"
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.Getstarted",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.XboxApp",
    "Fitbit.FitbitCoach",
    "4DF9E0F8.Netflix"
  )

  foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
  }
}

function Install-BasePackages() {
  # -----------------------------------------------------------------------------
  # Install modules and change Set-ExecutionPolicy to "RemoteSigned"

  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Install-Module -AllowClobber Get-ChildItemColor
  Install-Module PowerShellGet -Force
  Install-Module PSReadLine -Force
  Install-Module posh-git -Scope CurrentUser -Force
}

function Install-Configs() {
  New-Item -ItemType SymbolicLink -Path "~\.ssh\config" -Target $(Resolve-Path -LiteralPath ".\configs\ssh_config") -Force
  New-Item -ItemType SymbolicLink -Path "~\.wslconfig" -Target $(Resolve-Path -LiteralPath ".\configs\wslconfig") -Force

  $rcPath = Split-Path -Parent $Profile
  @("PowerShell", "VSCode") |
  ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "${rcPath}\Microsoft.${_}_profile.ps1" `
      -Target $(Resolve-Path -LiteralPath ".\runcoms\profile.ps1") -Force
  }

  Get-ChildItem ".\configs\git\" |
  ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "~\.$($_.Name)" -Target $_.FullName -Force
  }

  Get-ChildItem ".\configs\gnupg\" |
  ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "~\.gnupg\$($_.Name)" -Target $_.FullName -Force
  }
}

function Write-Usage() {
  Write-Output "Read install.ps1 lol"
}

function main() {
  Uninstall-Bloat
  Install-BasePackages
  Install-Configs
}

main
