# Write all artifacts to Artifacts.csv.

# The Path parameter specifies where files are saved.

# Artifacts should start with '"' and end with '",' but not contain quotation 
# marks (unless there are multiple cells in one artifact). Excel treats commas
# outside quotation marks as cell boundaries, but commas inside quotation marks
# are part of the cell.

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


Write-Host '--------------- Working'

$head = 'Hostname,Make,Model,MAC Addresses,'
$info = .\Get-Artifact1 -Path $Path
Write-Host -NoNewline '.'

$head += 'Process List,'
$info += .\Get-Artifact2 -Path $Path
Write-Host -NoNewline '.'

$head += 'Netstat,'
$info += .\Get-Artifact3 -Path $Path
Write-Host -NoNewline '.'

$head += 'Local User Accounts,'
$info += .\Get-Artifact4 -Path $Path
Write-Host -NoNewline '.'

$securityPolicyHead = 'Security Policy,'
$SecurityPolicyinfo = .\Get-SecurityPolicy -Path $Path
$head += $securitypolicyhead
$info += $SecurityPolicyinfo
Write-Host -NoNewline '.'

$head += 'Audit Settings,'
$info += .\Get-Artifact6 -Path $Path
Write-Host -NoNewline '.'

$head += 'Application Event IDs,Application Event ID Frequencies,' +
         'Security Event IDs,Security Event ID Frequencies,' +
         'System EventIDs,System Event ID Frequencies,'
$info += .\Get-Artifact7 -Path $Path
Write-Host -NoNewline '.'

$head += 'Windows Firewall Settings,'
$info += .\Get-Artifact9 -Path $Path
Write-Host -NoNewline '.'

$head += 'Network Interface Information,'
$info += .\Get-Artifact10 -Path $Path
Write-Host -NoNewline '.'

$head += '"Date, Time, Timezone",'
$info += .\Get-Artifact11 -Path $Path
Write-Host -NoNewline '.'

$head += 'User Rights,'
$info += .\Get-UserRights -Path $Path
Write-Host -NoNewline '.'

$head += 'SoftwareList,'
$info += .\Get-Artifact13 -Path $Path
Write-Host -NoNewline '.'

$head += 'Patchlist,'
$info += .\Get-Artifact14 -Path $Path
Write-Host -NoNewline '.'

$head += 'HKCC Hash,HKCR Hash,HKCU Hash,HKLM Hash,HKU Hash,'
$info += .\Get-Artifact15 -Path $Path
Write-Host -NoNewline '.'

$head += 'Are removable devices allowed?,'
$info += .\Get-Artifact16 -Path $Path
Write-Host -NoNewline '.'

$head += "`n"
$info += "`n"


($head + $info) | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifacts.csv')
# ASCII and UTF8 encodings work, but Unicode and some others do not.

Write-Host " Done`n"
