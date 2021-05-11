# Artifact 2: Process List

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

$txtOutput = (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + '   ' 
$Output = '"' + ((Get-Process).name | Out-String).Replace('"', "'") + '",'

($txtOutput + $output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact2.txt')
return $Output
