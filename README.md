# CSCI 590 Capstone Project: Monitoring Computer Information and Settings
 Retrieves lots of information about a computer and its settings. Intended for use by a cybersecurity professional who can run the program regularly and compare output over time.

### Background and Description
 I and two partners developed this program for CSCI 590: Math/CS Capstone Seminar. A cybersecurity professional at a local company, our "industry mentor," asked us to develop this program to help his company comply with [NIST Special publication 800-54 Rev4](https://csrc.nist.gov/publications/detail/sp/800-53/rev-4/final). Nothing about the program is specific to his company; it runs on any Windows computer with PowerShell. The program outputs a file, *Artifacts.csv*, containing lots of information about the computer on which the program runs. Versions of this file can be compared and checked for differences that could indicate possible security issues. Additionally, other files, such as copies of Windows event logs, are produced.
 
### Artifacts
 Our industry mentor gave us this list of seventeen "artifacts" to retrieve:
 
 1. HostName, MAC address, Make Model
 2. Process List
 3. Netstat information, ports and listening/status
 4. Local User accounts (Include last logon time and privilege of account)
 5. Security Template settings
 6. Audit settings found via (auditpol /get /category:*)
 7. Windows event log (2 steps) (.evtx file)
     1. Extract the System, application, and security files found in the windows directory
     2. Numerical value of each event log ID. (2500 Account lockouts, 75 user accounts added etc.)
 8. Display Banner (found in Local Policies gpedit). What is the current banner display on the machine?
 9. Settings of the windows adv firewall. List of all settings.
 10. IP addresses and network interface information
 11. What is the time of the machine at the time of the script run? Is it UTC/GMT/ET?
 12. Local Policies on the Machine (Gpedit.exe)
     1. User Rights assignment
     2. Security options
 13. SoftwareList (all installed items on machine)
 14. Patchlist, all applied or installed patches on the machine + Date of installation
 15. Hash of the Registry (Also clone of registry)
 16. Media access, are USBs allowed? Or CDs?
 17. User Access Controls enabled or disabled? What are they?

 Our script `Get-SecurityPolicy.ps1` retrieves information from artifacts 5, 8, 12ii, and 17. `Get-UserRights.ps1` retrieves information from artifact 12i. Otherwise, `Get-Artifact1.ps1` retrieves artifact 1's information, `Get-Artifact2.ps1` retrieve's artifact 2's information, and so on. These scritps can be run individually, or `Out-ArtifactsCsv.ps1` can be run to call all the others.
 
##### My scripts
 I was the primary programmer for artifacts 1, 2, 3, 7, 9, and 15 and for `Get-SecurityPolicy.ps1`, `Get-UserRights.ps1`, and `Out-ArtifactsCsv.ps1`.

### Execution
##### Running (6 scripts complete)
```
PowerShell> .\Out-ArtifactsCsv.ps1
--------------- Working
......
```

##### Finished
```
PowerShell> .\Out-ArtifactsCsv.ps1
--------------- Working
............... Done

PowerShell>
```

### Output
 The mock output file *Artifacts.csv* contains a sample of the kind of information the program produces. If viewed directly on GitHub, newlines are not displayed; if needed, open the file in Excel and select a monospace font. The program produces other files, but *Artifacts.csv* is the most important one.
