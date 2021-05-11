# Artifacts 5, 8, 12b, 17: Security Policy

# Both outputs info to a file and returns edited info for inclusion in the CSV.

Param([String] $Path) # Path where file will be saved
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

$FilePath = $Path + 'SecurityPolicy.txt'

# Output file
'' | Out-File $FilePath # Next line will append to file, not overwrite it.
secedit.exe /export /areas SECURITYPOLICY /cfg $FilePath | Out-Null

$Output =
    '"' + `
    ((Get-Content $FilePath `
    | Where-Object {$_ -notmatch '^\[?Unicode'} `
    | Out-String) `
    -replace '"', "'") `
    + '",'

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ','
($txtOutput + $output) | Out-File -Encoding UTF8 -FilePath $FilePath

Return $Output
