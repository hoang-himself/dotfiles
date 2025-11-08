function Get-Asset {
  $scriptBlockList = @();

  Push-Location -Path 'Assets';

  $scriptBlockList += {
    [array](Invoke-RestMethod -Method 'GET' -uri 'https://api.github.com/repos/M2Team/NanaZip/releases') `
    | Where-Object -FilterScript { -not $_.prerelease } `
    | Select-Object -First 1 -ExpandProperty assets `
    | Where-Object -FilterScript { $_.name -like "*.msixbundle" } `
    | Select-Object -ExpandProperty browser_download_url `
    | ForEach-Object { Invoke-WebRequest -Uri "$_ "-OutFile '40174MouriNaruto.NanaZip_gnj4mf6z9tkrc.msixbundle'; }
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://update.code.visualstudio.com/latest/win32-x64-user/stable' `
      -OutFile 'VSCodeUserSetup-x64.exe';
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://download.wireguard.com/windows-client/wireguard-installer.exe' `
      -OutFile 'wireguard-installer.exe';
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://github.com/2dust/v2rayN/releases/latest/download/v2rayN-windows-64-desktop.zip' `
      -OutFile 'v2rayN-windows-64-desktop.zip';
    Expand-Archive -Path 'v2rayN-windows-64-desktop.zip'
  }

  $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ };

  Get-Job | Wait-Job;

  Pop-Location;
}

Get-Asset;
