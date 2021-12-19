<#Run this script as Administrator in "Windows Powershell ISE". 

On a windows machine you can type Powershell ISE in Search, it will display "Windows Powershell ISE" - right click to "Run as Administrator"

- This script sets up Execution Policy if it is not set already
- It creates Powershell Profile if it doesn't exist already
- It adds MFGAlgos.psm1 module to Powershell Profile, so you don't need to load module everytime to use the methods

- After this script is open in Powershell ISE (that you are running as Administrator), click the green "Play" button on the tool bar.

#>

dir $($PSScriptRoot) | Unblock-File

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force

$importModule = "Import-Module '$($PSScriptRoot)\MFGAlgos.psm1' -Force -DisableNameChecking"

if(Test-Path "$($PSHOME)\Profile.ps1")
{
    get-content "$($PSHOME)\Profile.ps1" | select-string -pattern 'MFGAlgos' -notmatch | Out-File "$($PSHOME)\Profile.ps1" -Force

    Add-Content "$($PSHOME)\Profile.ps1" "`n$importModule" -Force

}
else
{
    New-Item -path "$($PSHOME)" -name Profile.ps1 -type "file" -value "$importModule" -Force
}

<#
$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
    Write-Error "7z.exe file $($7zipPath) not found. Please install 7-zip at this path: $($env:ProgramFiles) from this website and then retry: https://www.7-zip.org/download.html"
}
else
{
    Write-Host "If you don't see any errors, setup is complete. Try command TD-MFG-InitializeWorkflow" -ForegroundColor Green
}
#>
