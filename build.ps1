$dirs = get-childitem 'C:\Program Files (x86)' -Directory | where { $_.Name -like '*Microsoft Visual*'}

$foundit = $null

foreach($dir in $dirs)
{
    $foundit = Get-ChildItem "$($dir.FullName)" -Recurse | where {$_.Name -eq "devenv.com"}
}

Write-host "$foundit"

try{
    & "$($foundit.FullName)" "Mining For Gold - Workflow.sln" /build Debug
}
catch{

    Write-Host "Dynamic didn't work, now trying hard-coded path"
    
    & "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.com" "Mining For Gold - Workflow.sln" /build Debug

}