function Get-Asset {
  $scriptBlockList = @();

  Push-Location -Path 'Assets';

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://sourceforge.net/projects/sevenzip/files/latest/download' `
      -Headers @{ 'User-Agent' = 'Wget x64' } `
      -OutFile '7zip-installer.exe';
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://update.code.visualstudio.com/latest/win32-x64-user/stable' `
      -OutFile 'vscode-installer.exe';
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://download.wireguard.com/windows-client/wireguard-installer.exe' `
      -OutFile 'wireguard-installer.exe';
  }

  $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ };

  Get-Job | Wait-Job;

  Pop-Location;
}

Get-Asset;
