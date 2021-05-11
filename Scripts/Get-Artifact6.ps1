# Artifact 6: Audit settings  > C:\Temp\AuditOutput.CSV

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

$Audit = auditpol /get /Category:* 

ForEach ($m in $Audit){
	If ($m -ne $null){
        	$Output += $m + "`n"
    }
}

$Output = '"' + $Output.Replace('"', "'") + '",'

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ','
($txtOutput + $output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact6.txt')

Return $Output