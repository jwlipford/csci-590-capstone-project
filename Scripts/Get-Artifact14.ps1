#Artifact 14: Patchlist, all applied or installed patches on the machine + Date of installation

Param([String] $Path) # Path where files will be saved
    # Such as 'C:\Users\The User\Documents\'

If($Path -eq $Null -or $Path -eq '') {
    $Path = '.\' # Current directory
}
If(-not (Test-Path $Path)) {
    Throw('Invalid path argument')
}
If(-not $Path.EndsWith('\')) {
    $Path += '\'
}

$Output = '"' + ((Get-Hotfix) | Select-Object Description, InstalledOn | Out-String).Replace('"', "'")  + '",'

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ','
($txtOutput + $output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact14.txt')
return $Output