# Artifact 13

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

$SoftwareList = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"

$Output = '"'

foreach($obj in $SoftwareList -ne $null){

    if($obj.getvalue('displayname') -ne $null) {
        $Output += $obj.GetValue('DisplayName').Replace('"', "'") + ', '
    }
    #else {
      #  $Output += 'No name, '
    #}
    
    if($obj.getvalue('displayversion') -ne $null) {
        $Output += $obj.GetValue('DisplayVersion').Replace('"', "'") + '; '
    }
    #else {
       # $Output += 'No version;' 
    #}

    $output += "`n"
}

$Output += '",'

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + "`n"
($txtOutput + $Output +"`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact13.txt')

return $Output

