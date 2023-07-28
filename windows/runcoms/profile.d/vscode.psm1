if ("$env:VSCODE" -and -not (Get-Command -Name "$env:VSCODE" -ErrorAction SilentlyContinue)) {
  Write-Output -InputObject "'$env:VSCODE' flavour of VS Code not detected."
  Remove-Item -Path 'Env:\VSCODE'
}

if (-not "$env:VSCODE") {
  $ErrorActionPreference = 'SilentlyContinue'
  @(
    'code',
    'code-insiders',
    'codium'
  ) | ForEach-Object -Process {
    if (Get-Command -Name "$_") {
      $env:VSCODE = "$_"
      return
    }
  }
}

if (-not "$env:VSCODE") {
  return
}

${function:vsc} = { &"$env:VSCODE" $args }
${function:vsca} = { &"$env:VSCODE" --add $args }
${function:vscd} = { &"$env:VSCODE" --diff $args }
${function:vscg} = { &"$env:VSCODE" --goto $args }
${function:vscn} = { &"$env:VSCODE" --new-window $args }
${function:vscr} = { &"$env:VSCODE" --reuse-window $args }
${function:vscw} = { &"$env:VSCODE" --wait $args }
${function:vscu} = { &"$env:VSCODE" --user-data-dir $args }

${function:vsced} = { &"$env:VSCODE" --extensions-dir $args }
${function:vscie} = { &"$env:VSCODE" --install-extension $args }
${function:vscue} = { &"$env:VSCODE" --uninstall-extension $args }

${function:vscv} = { &"$env:VSCODE" --verbose $args }
${function:vscl} = { &"$env:VSCODE" --log $args }
${function:vscde} = { &"$env:VSCODE" --disable-extensions $args }
