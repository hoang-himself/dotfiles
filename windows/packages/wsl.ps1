function Install-WSL() {
  # Get-WindowsOptionalFeature -Online
  Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
}
