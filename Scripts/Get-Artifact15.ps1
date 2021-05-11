# Artifact 15: Hash of the Registry (Also clone of registry)

# This script saves a copy of each of the 5 registry hives (HKCC, HKCR, HKCU,
# HKLM, HKU) as separate files. It inserts 5 hashes, one for each of these
# hives, in the CSV.

# According to www.lifewire.com/hkey-local-machine-2625902, "HKEY_LOCAL_MACHINE
# doesn't actually exist anywhere on the computer, but is instead just a
# container for displaying the actual registry data being loaded via the
# subkeys located within the hive, listed above." So I cannot use Get-FileHash
# on the 5 registry hives, which are not actually files. Furthermore, when I
# try to use Get-FileHash on members of HKLM, such as the file
# C:\Windows\System32\config\DEFAULT, there is an error because DEFAULT is
# being used by another process. Instead, I am using REG EXPORT on the 5 hives
# and then Get-FileHash on the resulting files.

# I am using REG EXPORT because it, unlike REG SAVE, produces plain text data.
# In a previous version of this script, I used SAVA for three hives and EXPORT
# only for the two (HKLM and HKU) for which EXPORT is not available because I
# was worried EXPORT would not work remotely because it says "local machine
# only" in the help info, but I am not sure that is actually what it means.


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

$HKCC_Path = $Path + 'HKCC'
REG EXPORT HKCC $HKCC_Path /y | Out-Null # Out-Null prevents console output
$HKCC_Hash = (Get-FileHash $HKCC_Path).Hash

$HKCR_Path = $Path + 'HKCR'
REG EXPORT HKCR $HKCR_Path /y | Out-Null
$HKCR_Hash = (Get-FileHash $HKCR_Path).Hash

$HKCU_Path = $Path + 'HKCU'
REG EXPORT HKCU $HKCU_Path /y | Out-Null
$HKCU_Hash = (Get-FileHash $HKCU_Path).Hash

$HKLM_Path = $Path + 'HKLM'
REG EXPORT HKLM $HKLM_Path /y | Out-Null
$HKLM_Hash = (Get-FileHash $HKLM_Path).Hash

$HKU_Path = $Path + 'HKU'
REG EXPORT HKU $HKU_Path /y | Out-Null
$HKU_Hash = (Get-FileHash $HKU_Path).Hash

$Output = '"' + $HKCC_Hash + '","' + $HKCR_Hash + '","' + $HKCU_Hash + '","' +
          $HKLM_Hash + '","' + $HKU_Hash + '",'

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ', '
($txtOutput + $output + "`n") | Out-File -Encoding UTF8 -FilePath ($Path + 'Artifact15.txt')
Return $Output
