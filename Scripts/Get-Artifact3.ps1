# Artifact 3: Netstat information, ports, and listening/status

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

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ','
$Output = '"' + (netstat.exe -naob | Out-String).Replace('"', "'") + '",'

($txtOutput + $Output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact3.txt')

return $Output
