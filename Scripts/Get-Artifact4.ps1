#Artifact 4: Local User accounts (Include last logon time and privilege of account)

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

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ''
$Output = '"' + ((Get-LocalUser) | Select-Object Name, Enabled, Lastlogon | Out-String).Replace('"', "'")  + '",'

($txtOutput + $output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact4.txt')
return $Output 