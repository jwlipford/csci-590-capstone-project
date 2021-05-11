#Artifact 10: IP addresses and network interface information 

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

$Output = '"' + ((Get-NetIPAddress) | Select-Object IPAddress, AddressFamily, InterfaceAlias | Out-String).Replace('"', "'")  + '",'  

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ','
($txtOutput + $output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact10.txt')

return $Output 
