# Artifact 7: Windows event log (2 steps) (.evtx file)
#   a. Save copies of the Application.evtx, System.evtx, and Security.evtx
#      files found in the windows directory.
#   b. Get numerical value of each event log ID. (2500 Account lockouts, 75
#      user accounts added, etc.)


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


# Copy files
Copy-Item 'C:\Windows\System32\winevt\Logs\Application.evtx' $Path 
Copy-Item 'C:\Windows\System32\winevt\Logs\Security.evtx' $Path
Copy-Item 'C:\Windows\System32\winevt\Logs\System.evtx' $Path


# For each event log, get an Int32[] array of each event's EventID.
$ApplicationEventIDs = (Get-EventLog Application).EventID
$SecurityEventIDs = (Get-EventLog Security).EventID
$SystemEventIDs = (Get-EventLog System).EventID

# For each array, create a corresponding (EventID, Frequency) hashtable.
$ApplicationHT = @{}
$SecurityHT = @{}
$SystemHT = @{}

# Fill $ApplicationHT
ForEach($id in $ApplicationEventIDs)
{
    If($ApplicationHT[$id] -eq $null) {
        $ApplicationHT[$id] = 1
    }
    Else {
        $ApplicationHT[$id] += 1
    }
}

# Fill $SecurityHT
ForEach($id in $SecurityEventIDs)
{
    If($SecurityHT[$id] -eq $null) {
        $SecurityHT[$id] = 1
    }
    Else {
        $SecurityHT[$id] += 1
    }
}

# Fill $SystemHT
ForEach($id in $SystemEventIDs)
{
    If($SystemHT[$id] -eq $null) {
        $SystemHT[$id] = 1
    }
    Else {
        $SystemHT[$id] += 1
    }
}

# Output the following 6 cells:
#   Application Event Log Hash Table - Event IDs
#   Application Event Log Hash Table - Event ID Frequencies
#   Security Event Log Hash Table - Event IDs
#   Security Event Log Hash Table - Event ID Frequencies
#   System Event Log Hash Table - Event IDs
#   System Event Log Hash Table - Event ID Frequencies
$ApplicationKeys = ($ApplicationHT.Keys | Out-String).Replace('"', "'")
$ApplicationFreq = ($ApplicationHT.Values | Out-String).Replace('"', "'")
$SecurityKeys = ($SecurityHT.Keys | Out-String).Replace('"', "'")
$SecurityFreq = ($SecurityHT.Values | Out-String).Replace('"', "'")
$SystemKeys = ($SystemHT.Keys | Out-String).Replace('"', "'")
$SystemFreq = ($SystemHT.Values | Out-String).Replace('"', "'")
$Output = '"' + $ApplicationKeys + '","' + $ApplicationFreq + '","' +
                $SecurityKeys + '","' + $SecurityFreq + '","' +
                $SystemKeys + '","' + $SystemFreq + '",'

$Computer = Get-CimInstance -Class Win32_ComputerSystem
$head = "Host Name, Application Event IDs, Application Event ID Frequencies`n" 
$seqOutput = '"' + $Computer.Name + '","' + $SecurityKeys + '","' + $SecurityFreq + '",' + "`n"
($head + $seqOutput) | Out-File -Encoding UTF8 -FilePath ($Path + 'SecurityEventLog.csv')

$head = "Host Name, Security Event IDs,Security Event ID Frequencies`n" 
$appOutput = '"' +$Computer.Name + '","' + $ApplicationKeys + '","' + $ApplicationFreq + '",' + "`n" 
($head + $appOutput) | Out-File -Encoding UTF8 -FilePath ($Path + 'ApplicationEventLog.csv')

$head = "Host Name, Security Event IDs,Security Event ID Frequencies`n" 
$sysOutput = '"' +$Computer.Name + '","' + $SystemKeys + '","' + $SystemFreq + '",' + "`n" 
($head + $sysOutput) | Out-File -Encoding UTF8 -FilePath ($Path + 'SystemEventLog.csv')

Return $Output
