# Artifact 9: Settings of the windows adv firewall. List of all settings (Check
# the SEC505 script folder)

# There are several scripts in SEC505-Scripts/Day4/Firewall, but I am not sure
# which is relevant.

# NetFirewallSetting is the same regardless of whether the firewall is on.
# NetFirewallProfile says, among other things, whether the firewall is enabled
# for each of the three profiles.

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

$Output = '"' + (Get-NetFirewallProfile | Out-String).Replace('"', "'")
$Output +=      (Get-NetFirewallSetting | Out-String).Replace('"', "'") + '",'

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ','
($txtOutput + $output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact9.txt')

return $Output
