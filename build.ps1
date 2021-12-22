$dirs = get-childitem 'C:\Program Files (x86)' -Directory | where { $_.Name -like '*Microsoft Visual*'}

foreach($dir in $dirs)
{
    $foundit = Get-ChildItem "$($dir.FullName)" -Recurse | where {$_.Name -eq "devenv.com"}  | select -First 1
}

& "$($foundit.FullName)" "Mining For Gold - Workflow.sln" /build Debug

#& "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.com" Source\MySolution.sln /build Release /project Source\My\Setup\Project.vdproj"