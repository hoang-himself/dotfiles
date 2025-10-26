Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes' `
| Where-Object {
  Test-Path "$($_.PSPath)\TopViews\{00000000-0000-0000-0000-000000000000}"
} `
| ForEach-Object {
  $guid = $_.PSChildName;
  $props = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue;
  $modifiers = Get-ItemProperty "$($_.PSPath)\Modifiers" -ErrorAction SilentlyContinue;
  [PSCustomObject]@{
    GUID = $guid;
    Class = $props.Class;
    CanonicalName = $props.CanonicalName;
    Parent = $props.Parent;
    SearchResults = $modifiers.SearchResults;
  }
} `
| Format-Table -AutoSize
