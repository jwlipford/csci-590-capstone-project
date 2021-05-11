# Artifact 1: HostName, MAC address, Make Model (if possible)

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

$Computer = Get-CimInstance -Class Win32_ComputerSystem
$Mac = (Get-CimInstance -Class Win32_NetworkAdapterConfiguration).MACAddress

$Output = '"' + $Computer.Name.Replace('"', "'")
$Output += '","' + $Computer.Manufacturer.Replace('"', "'")
$Output += '","' + $Computer.Model.Replace('"', "'")
$Output += '","' + ($Mac | Out-String).Replace('"', "'") + '",'

($Output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact1.txt')
return $Output
