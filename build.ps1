<#
    Validating commit - triggers the build
#>

$msifile = "$PSScriptRoot\MSI\MSI.vdproj"

$upgradeCodeLine = (gc $msifile) | where {$_ -like "*UpgradeCode*"}
$newUpgradeCode = "$($upgradeCodeLine.Split("{")[0]){$(New-Guid)}"""

(Get-Content $msifile).replace($upgradeCodeLine, $($newUpgradeCode.ToUpper())) | Set-Content $msifile

$upgradeCodeLine = (gc $msifile) | where {$_ -like "*ProductCode*{*"}
$newUpgradeCode = "$($upgradeCodeLine.Split("{")[0]){$(New-Guid)}"""

(Get-Content $msifile).replace($upgradeCodeLine, $($newUpgradeCode.ToUpper())) | Set-Content $msifile

$dirs = get-childitem 'C:\Program Files (x86)' -Directory | where { $_.Name -like '*Microsoft Visual*'}

$foundit = $null

foreach($dir in $dirs)
{
    Get-ChildItem "$($dir.FullName)" -Recurse | where {$_.Name -eq "devenv.com"} | select -First 1
}

& "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.com" "Mining For Gold - Workflow.sln" /build Debug
