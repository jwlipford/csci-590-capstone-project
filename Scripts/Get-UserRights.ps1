# Artifact 12a: User Rights

# Similar to Get-SecurityPolicy, which takes care of artifacts 5, 8, 12b, 17.
# Both outputs info to a file and returns edited info for inclusion in the CSV

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

$FilePath = $Path + 'UserRights.txt'

# Output file
'' | Out-File $FilePath # Next line will append to file, not overwrite it.
secedit.exe /export /areas USER_RIGHTS /cfg $FilePath | Out-Null

# Read that file. Ignore unnecessary lines about Unicode.
$Output =
    '"' + `
    ((Get-Content $FilePath `
    | Where-Object {$_ -notmatch '^\[?Unicode'} `
    | Out-String) `
    -replace '"', "'") `
    + '",'

# Translate IDs such as '*S-1-23-45' to meaningful text. I have referred to
# www.powershellbros.com/get-user-rights-assignment-security-policy-settings/.
$i = $Output.indexof('*')
While($i -gt -1) # While $Output contains '*'
{
    $j = $i + 1
    While($j -lt $Output.length -and $Output[$j] -notmatch ",|`r") { ++$j }
    $Substr = $Output.SubString($i + 1, $j - $i - 1)
    # $Substr now contains the characters between the first '*' and the first
    # comma or newline (or end of string) after that '*'. $Substr might be
    # something like "S-1-23-45". $Output.SubString($i, $j - $i) might be
    # something like "*S-1-23-45," or "*S-1-23-45`r".
    
    Try
    {
        $SID = New-Object System.Security.Principal.SecurityIdentifier($Substr)
        $Trans = $SID.Translate([Security.Principal.NTAccount])
        $Output = $Output.Replace('*' + $Substr, $Trans)
    }
    Catch
    {
        $Output = $Output.Replace('*' + $Substr, 'UNKNOWN->' + $Substr)
    }
    
    $new_i = $Output.indexof('*')
    If($new_i -le $i){ Break } # Just make sure no weird infinite loop occurs
    $i = $new_i
}

$txtOutput = '' + (Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object { $_.Name }) + ','
($txtOutput + $output) | Out-File -Encoding UTF8 -FilePath $FilePath

# Output for CSV
Return $Output


# See https://www.powershellbros.com/get-user-rights-assignment-security-policy-settings/.
# It contains the following function.
#     # Function to translates SID to account name
#     function Get-AccountName {
#       param(
#         [String] $principal
#       )
#       If ( $principal[0] -eq "*" ) 
#       {
#         $SIDName = $principal.Substring(1)
#         $sid = New-Object System.Security.Principal.SecurityIdentifier($SIDName)
#         $sid.Translate([Security.Principal.NTAccount])
#       }
#       Else
#       {
#         Return $principal
#       }
#     }
