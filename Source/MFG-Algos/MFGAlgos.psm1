<#
    .DESCRIPTION
        This commands prints your MFG configuration settings that include path to Trade Station, path to Strategy Quant, path to Strategy Quant workspace and endpoint used to get package updates

    .SYNOPSIS

    .EXAMPLE
        Get-MFG-Configuration
#>
function Get-MFG-Configuration()
{
    $configPath = "$($PSScriptRoot)\MFGConfig.json"
    
    if(-NOT (Test-Path $configPath))
    {
        Write-Error "MFG config not found at this path: $configPath"
    }
    
    Get-Content "$configPath"
}

<#
    .DESCRIPTION
        This commands sets up a Windows scheduled task to get latest powershell package on daily bases. You can open Task Scheduler on windows machine to locate the task under MFG folder

    .SYNOPSIS

    .EXAMPLE
        Daily-Update
#>
function Daily-Update()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $scheduleObject = New-Object -ComObject schedule.service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder("\")
    try{$rootFolder.CreateFolder("MFG") } catch{}

    ipmo ScheduledTasks

    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-WindowStyle Hidden Mine -Upgrade"

    $time = Get-Random -Minimum 1 -Maximum 11

    $trigger = New-ScheduledTaskTrigger -Daily -At "$($time)pm"
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "UpdateMFGModules" -Description "Updated MSG Powershell Modules" -User "System" -Verbose -TaskPath '\MFG\'
}

<#
    .DESCRIPTION
        This commands sets up a Windows scheduled task to test if Ninja Trader, Trade Station and Think or Swim are running on the box. You will get a text message if platform is not running. See Set-MFG-Configuration command to set your email account, smtp server, cell phone details etc.

    .SYNOPSIS

    .EXAMPLE
        TradingPlatform-Update
#>
function TradingPlatform-Update()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $scheduleObject = New-Object -ComObject schedule.service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder("\")
    try{$rootFolder.CreateFolder("MFG") } catch{}

    ipmo ScheduledTasks

    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-WindowStyle Hidden Check-TradingPlatforms -NoAudio"

    $time = Get-Random -Minimum 1 -Maximum 11

    $trigger = New-ScheduledTaskTrigger `
    -Once `
    -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes 5) `
    -RepetitionDuration (New-TimeSpan -Days (365 * 20))

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "CheckTradingPlatforms" -Description "Check Trading Platforms" -User "System" -Verbose -TaskPath '\MFG\' | Start-ScheduledTask
}


function Load-MFG-Config()
{
    Get-MFG-Configuration | Out-String | ConvertFrom-Json
}

function Get-ProviderExtension([ValidateSet("River Wireless","Alltel","AT&T","ACS Wireless","Blue Sky Frog","Bluegrass Cellular","Boost Mobile","BPL Mobile","Carolina West Wireless","Cellular One","Cellular South","Centennial Wireless","CenturyTel","Cingular","Clearnet","Comcast","Corr Wireless Communications","Dobson","Edge Wireless","Golden Telecom","Helio","Houston Cellular","Illinois Valley Cellular","Inland Cellular Telephone","Idea Cellular","MCI","Metrocall","Metrocall 2-way","Metro PCS","Microcell","Midwest Wireless","Mobilcomm","MTS","Nextel","OnlineBeep","Public Service Cellular","PCS One","Qwest","Rogers AT&T Wireless","Satellink","Southwestern Bell","Sprint","Sumcom","Surewest Communicaitons","Sumcom","Sprint","Surewest Communicaitons","T-Mobile","Tracfone","Triton","Unicel","US Cellular","US West","Virgin Mobile","Virgin Mobile Canada","Verizon","Western Wireless","West Central Wireless")]
    [string]
    $Provider
    )
{

$providers = @"

[
{"provider":"3 River Wireless", "extension":"@sms.3rivers.net"},
{"provider":"Alltel", "extension":"@message.alltel.com"},
{"provider":"AT&T", "extension":"@txt.att.net"},
{"provider":"ACS Wireless", "extension":"@paging.acswireless.com"},
{"provider":"Blue Sky Frog", "extension":"@blueskyfrog.com"},
{"provider":"Bluegrass Cellular", "extension":"@sms.bluecell.com"},
{"provider":"Boost Mobile", "extension":"@myboostmobile.com"},
{"provider":"BPL Mobile", "extension":"@bplmobile.com"},
{"provider":"Carolina West Wireless", "extension":"@cwwsms.com"},
{"provider":"Cellular One", "extension":"@mobile.celloneusa.com"},
{"provider":"Cellular South", "extension":"@csouth1.com"},
{"provider":"Centennial Wireless", "extension":"@cwemail.com"},
{"provider":"CenturyTel", "extension":"@messaging.centurytel.net"},
{"provider":"Cingular", "extension":"@txt.att.net"},
{"provider":"Clearnet", "extension":"@msg.clearnet.com"},
{"provider":"Comcast", "extension":"@comcastpcs.textmsg.com"},
{"provider":"Corr Wireless Communications", "extension":"@corrwireless.net"},
{"provider":"Dobson", "extension":"@mobile.dobson.net"},
{"provider":"Edge Wireless", "extension":"@sms.edgewireless.com"},
{"provider":"Golden Telecom", "extension":"@sms.goldentele.com"},
{"provider":"Helio", "extension":"@messaging.sprintpcs.com"},
{"provider":"Houston Cellular", "extension":"@text.houstoncellular.net"},
{"provider":"Illinois Valley Cellular", "extension":"@ivctext.com"},
{"provider":"Inland Cellular Telephone", "extension":"@inlandlink.com"},
{"provider":"Idea Cellular", "extension":"@ideacellular.net"},
{"provider":"MCI", "extension":"@pagemci.com"},
{"provider":"Metrocall", "extension":"@page.metrocall.com"},
{"provider":"Metrocall 2-way", "extension":"@my2way.com"},
{"provider":"Metro PCS", "extension":"@mymetropcs.com"},
{"provider":"Microcell", "extension":"@fido.ca"},
{"provider":"Midwest Wireless", "extension":"@clearlydigital.com"},
{"provider":"Mobilcomm", "extension":"@mobilecomm.net"},
{"provider":"MTS", "extension":"@text.mtsmobility.com"},
{"provider":"Nextel", "extension":"@messaging.nextel.com"},
{"provider":"OnlineBeep", "extension":"@onlinebeep.net"},
{"provider":"Public Service Cellular", "extension":"@sms.pscel.com"},
{"provider":"PCS One", "extension":"@pcsone.net"},
{"provider":"Qwest", "extension":"@qwestmp.com"},
{"provider":"Rogers AT&T Wireless", "extension":"@pcs.rogers.com"},
{"provider":"Satellink .pageme@satellink.net"},
{"provider":"Southwestern Bell", "extension":"@email.swbw.com"},
{"provider":"Sprint", "extension":"@messaging.sprintpcs.com"},
{"provider":"Sumcom", "extension":"@tms.suncom.com"},
{"provider":"Surewest Communicaitons", "extension":"@mobile.surewest.com"},
{"provider":"Sumcom", "extension":"@tms.suncom.com"},
{"provider":"Sprint", "extension":"@messaging.sprintpcs.com"},
{"provider":"Surewest Communicaitons", "extension":"@mobile.surewest.com"},
{"provider":"T-Mobile", "extension":"@tmomail.net"},
{"provider":"Tracfone", "extension":"@txt.att.net"},
{"provider":"Triton", "extension":"@tms.suncom.com"},
{"provider":"Unicel", "extension":"@utext.com"},
{"provider":"US Cellular", "extension":"@email.uscc.net"},
{"provider":"US West", "extension":"@uswestdatamail.com"},
{"provider":"Virgin Mobile", "extension":"@vmobl.com"},
{"provider":"Virgin Mobile Canada", "extension":"@vmobile.ca"},
{"provider":"Verizon", "extension":"@vtext.com"},
{"provider":"Western Wireless", "extension":"@cellularonewest.com"},
{"provider":"West Central Wireless", "extension":"@sms.wcc.net"}
]
"@
 
 $providersJson = $providers | ConvertFrom-Json
 
 return ($providersJson | where {$_.provider -eq "$Provider"}).extension
    
}

Function Send-EMail {
    Param (
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailTo,
        [Parameter(`
            Mandatory=$true)]
        [String]$Subject,
        [Parameter(`
            Mandatory=$true)]
        [String]$Body,
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailFrom="myself@gmail.com",  #This gives a default value to the $EmailFrom command
        [Parameter(`
            mandatory=$true)]
        [String]$SMTPServer,
        [Parameter(`
            mandatory=$true)]
        [String]$SMTPServerPort,
        [Parameter(`
            mandatory=$true)]
        [String]$Password
    )

        $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
        $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, $SMTPServerPort) 
        $SMTPClient.EnableSsl = $true 
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom.Split("@")[0], $Password); 
        $SMTPClient.Send($SMTPMessage)
    
}

<#
    .DESCRIPTION
        Run this to check if you are getting text messages. See Set-MFG-Configuration command to set your email account, smtp server, cell phone details etc.

    .SYNOPSIS

    .PARAMETER Subject
        Message you want to text

    .EXAMPLE
        Test-SMS
#>
function Test-SMS($Subject)
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $SMTPServer = "$($config.MFGConfig.SMTPServer)"
    $SMTPServerPort = "$($config.MFGConfig.SMTPServerPort)"
    $EmailAccount = "$($config.MFGConfig.EmailAccount)"
    $EmailPassword = "$($config.MFGConfig.EmailPassword)"
    $SMSProvider = "$($config.MFGConfig.SMSProvider)"
    $CellPhoneNumber = "$($config.MFGConfig.CellPhoneNumber)"
    $SMSProviderExtension = Get-ProviderExtension -Provider "$SMSProvider"

    $EmailTo = "$($CellPhoneNumber)$($SMSProviderExtension)"

    $Body = "$Subject"

    if($Subject -eq $null)
    {
        $Subject = "Notification from MFG"
        $Body = "Testing SMS functionality"
    }
            
    Write-Host "Attempting to send SMS to $EmailTo from email account $EmailAccount using SMTP server $SMTPServer with port $SMTPServerPort . If these values do not look accurate, please use Set-MFG-Configuration" -ForegroundColor Cyan
    
    Send-EMail -EmailTo $EmailTo -Subject $Subject -Body $Body -EmailFrom $EmailAccount -SMTPServer $SMTPServer -SMTPServerPort $SMTPServerPort -Password $EmailPassword
   
}

<#
    .DESCRIPTION
        This commands sets user settings. You can set your TradeStationDataPath, WorkflowResultsPath, SMTPServer, SMTPServerPort, EmailAccount, EmailPassword, Cell phone Provider, CellPhoneNumber with this command. 
        You can also specify what all trading platforms you would like to test with following switches 
            CheckNinjaTrader
            CheckTradeStation
            CheckTOS
            CheckInternetConnection


    .SYNOPSIS

    .PARAMETER TradeStationDataPath
        This is the path where you save your Trade Station .csv files

    .PARAMETER SQPath
        This is the path where you have installed Strategy Quant

    .PARAMETER WorkflowResultsPath
        This is the path where .cfx files and databank results will be saved

    .PARAMETER UpgradeURL
        endpoint to download latest scripts

    .PARAMETER SMTPServer
        This SMTP server will be used to send you text messaged. This is generally setup by your email account provider. Default is set to gmail

    .PARAMETER SMTPServerPort
        SMPT server port

    .PARAMETER EmailAccount
        This is your email account that will be used to send you text messages on your cell phone

    .PARAMETER EmailPassword
        This is password for your email account that will be used to communicate to your cell phone

    .PARAMETER Provider
        This is your cell phone provider

    .PARAMETER CheckInternetConnection
        This enables verification for internet connection

    .PARAMETER CheckNinjaTrader
        This enables verification for Ninja Trader
    
    .PARAMETER CheckTradeStation
        This enables verification for Trade Station

    .PARAMETER CheckTOS
        This enables verification for Think or Swim

    .EXAMPLE
        Set-MFG-Configuration -SQPath "C:\StrategyQuantX" -TradeStationDataPath "C:\TradeStation\Data" -WorkflowResultsPath "C:\Algos\SQ\MFG-Results" -SMTPServer "smtp.gmail.com" -SMTPServerPort "587" -EmailAccount yourAccount@gmail.com -EmailPassword yourEmailPassword -CellPhoneNumber "YourCellPhoneNumber[No - No . No + No ()]" -Provider 'AT&T' -CheckNinjaTrader -CheckInternetConnection -CheckTradeStation -CheckTOS
    
#>
function Set-MFG-Configuration($SQPath = "C:\StrategyQuantX",
    $TradeStationDataPath = "C:\Users\17703\Dropbox\MFG-DropBox\TradeStation\Data", 
    $WorkflowResultsPath = "C:\Algos\SQ\MFG-Results", 
    $UpgradeURL = "http://151.106.59.178/MFG-Algos",
    $SMTPServer = "smtp.gmail.com" ,
    $SMTPServerPort = "587",
    $EmailAccount="YourEmailAccount@gmail.com",
    $EmailPassword="123",
    [ValidateSet("River Wireless","Alltel","AT&T","ACS Wireless","Blue Sky Frog","Bluegrass Cellular","Boost Mobile","BPL Mobile","Carolina West Wireless","Cellular One","Cellular South","Centennial Wireless","CenturyTel","Cingular","Clearnet","Comcast","Corr Wireless Communications","Dobson","Edge Wireless","Golden Telecom","Helio","Houston Cellular","Illinois Valley Cellular","Inland Cellular Telephone","Idea Cellular","MCI","Metrocall","Metrocall 2-way","Metro PCS","Microcell","Midwest Wireless","Mobilcomm","MTS","Nextel","OnlineBeep","Public Service Cellular","PCS One","Qwest","Rogers AT&T Wireless","Satellink","Southwestern Bell","Sprint","Sumcom","Surewest Communicaitons","Sumcom","Sprint","Surewest Communicaitons","T-Mobile","Tracfone","Triton","Unicel","US Cellular","US West","Virgin Mobile","Virgin Mobile Canada","Verizon","Western Wireless","West Central Wireless")]
    [string]
    $Provider = "AT&T",
    $CellPhoneNumber = "",
    [Parameter(Mandatory=$false)]
    [Switch]$CheckInternetConnection,
    [Parameter(Mandatory=$false)]
    [Switch]$CheckNinjaTrader,
    [Parameter(Mandatory=$false)]
    [Switch]$CheckTradeStation,
    [Parameter(Mandatory=$false)]
    [Switch]$CheckTOS,
    [Parameter(Mandatory=$false)]
    [Switch]$CheckTWS,
    [Parameter(Mandatory=$false)]
    [Switch]$CheckMultiCharts
    )
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $json = Get-MFG-Configuration | Out-String | ConvertFrom-Json

    $json.MFGConfig.SQPath = "$SQPath"
    $json.MFGConfig.TSDataPath = "$TradeStationDataPath"
    $json.MFGConfig.WorkflowResultsPath = "$WorkflowResultsPath"
    $json.MFGConfig.UpgradeURL = "$UpgradeURL"
    $json.MFGConfig.SMTPServer = "$SMTPServer"
    $json.MFGConfig.SMTPServerPort = "$SMTPServerPort"
    $json.MFGConfig.EmailAccount = "$EmailAccount"
    $json.MFGConfig.EmailPassword = "$EmailPassword"
    $json.MFGConfig.SMSProvider = "$Provider"
    $json.MFGConfig.CellPhoneNumber = "$CellPhoneNumber"
    $json.MFGConfig.CheckInternetConnection = "$CheckInternetConnection"
    $json.MFGConfig.CheckNinjaTrader = "$CheckNinjaTrader"
    $json.MFGConfig.CheckTradeStation = "$CheckTradeStation"
    $json.MFGConfig.CheckTOS = "$CheckTOS"
    $json.MFGConfig.CheckTWS = "$CheckTWS"
    $json.MFGConfig.CheckMulticharts = "$CheckMultiCharts"

    
    $json | ConvertTo-Json -depth 32| set-content "$($PSScriptRoot)\MFGConfig.json"

    Get-MFG-Configuration
}

function Upgrade-Module([Parameter(Mandatory=$false)]
                    [Switch]$UpdateUserSettings
    )
{
    Write-Host "`nDownloading latest package" -ForegroundColor Cyan

    Add-Type -AssemblyName System.Web
    Add-Type -AssemblyName System.Web.Extensions

    $config = Load-MFG-Config
    $url = "$($config.MFGConfig.UpgradeURL)"
    
    $destPath  = "$PSScriptRoot"

    md $destPath -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Tls11

    $WebResponse = Invoke-WebRequest -Uri $url
    $WebResponse.Links | Select-Object -ExpandProperty innerText -Skip 1 | ForEach-Object {
        
        Write-Host "Downloading file '$_'"
        $filePath = Join-Path -Path $destPath -ChildPath $_

        if($_ -eq "MFGConfig.json" -and (Test-Path "$filePath") -and $UpdateUserSettings -eq $false)
        {
            Write-Host "$filePath with user settings will not be upgraded. If you want to force upgrade this file with your user settings, use Mine -Upgrade -UpdateUserSettings" -ForegroundColor Cyan
        }
        else
        {
            $fileUrl  = '{0}/{1}' -f $url.TrimEnd('/'), $_
            if((-NOT ($fileUrl -like "*web.config*")) -and (-NOT ($fileUrl -like "*History.txt*") -and (-NOT ($fileUrl -like "*Earnings.txt*")) )){
                $ProgressPreference = 'SilentlyContinue'
                Invoke-WebRequest -Uri $fileUrl -OutFile $filePath
            }
        }
    }

}

<#
    .DESCRIPTION
        This commands restores your databanks from the WorkflowResultsPath (See Get-MFG-Configuration) folder which is generally set to C:\Algos\SQ\MFG-Results to StarategyQuant user folder C:\StrategyQuantX\user\projects This folder is constructed based on SQPath. See Get-MFG-Configuration for details

    .SYNOPSIS

    .PARAMETER Symbol
        If you don't specify -Symbol parameter, this command will restore databanks for all symbols. If you want to limit restoration to specific symbol, specify that

    .EXAMPLE
        Restore-Databanks

    .EXAMPLE
        Restore-Databanks -Symbol "AAPL"
#>
function Restore-Databanks($Symbol="All")
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $workflowResultsFolder = "$($config.MFGConfig.WorkflowResultsPath)"
    $SQProjectsFolder = "$($config.MFGConfig.SQPath)\user\projects"

    $stockDirs = get-childitem "$workflowResultsFolder" -Directory

    foreach($stockDir in $stockDirs)
    {
        $stock = "$($stockDir.Name)"

        if($stock -eq "$Symbol" -or $Symbol -eq "All") 
        {
            $stockFolder = "$workflowResultsFolder\$stock"
            $dirs = get-childitem "$stockFolder" -Directory

            foreach($dir in $dirs)
            {
                $split = $dir.Name.split("_")
                if($split.Count -gt 1)
                {
                    $destinatonDatabankFolder = "$($split[0])"
                    $destinationProjectFolder = "MFG - Stocks $stock - $($split[1])"
    
                    $destinationPath = "$SQProjectsFolder\$destinationProjectFolder\databanks\$destinatonDatabankFolder"
    
                    if(Test-Path "$destinationPath")
                    {
                        copy-item -Path "$($dir.FullName)\*" -Destination "$destinationPath" -Force -Recurse -Verbose
                    }
                }
                else
                {
                    $destinationProjectFolder = "MFG - Stocks - $stock - 60 min"
                    $destinationPath = "$SQProjectsFolder\$destinationProjectFolder\databanks\$($dir.Name)"
    
                    if(Test-Path "$destinationPath")
                    {
                        copy-item -Path "$($dir.FullName)\*" -Destination "$destinationPath" -Force -Recurse -Verbose
                    }
                    else
                    {
            
                        $destinationProjectFolder = "MFG - Stocks $stock - 60 min"
                        $destinationPath = "$SQProjectsFolder\$destinationProjectFolder\databanks\$($dir.Name)"
    
                        if(Test-Path "$destinationPath")
                        {
                            copy-item -Path "$($dir.FullName)\*" -Destination "$destinationPath" -Force -Recurse -Verbose
                        }

                    }
                }
   
            }
        }
    }

}

function SQ-Import-Projects($FolderWithCFXFiles = "C:\Algos\SQ\MFG-Results\SQProjects")
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $SQPath = "$($config.MFGConfig.SQPath)"
    
    $commandFile = "$PSScriptRoot\ImportProjects.txt"

    if(Test-Path "$commandFile")
    {
        Clear-Content "$commandFile"
    }
    else
    {
        New-Item "$commandFile"
    }

    $files = Get-ChildItem "$FolderWithCFXFiles" -Recurse -Include *.cfx
    foreach($file in $files)
    {
        "-project action=loadconfig name=""$($file.Name.Split(".")[0])"" file=""$($file.FullName)""" | Add-Content "$commandFile"
    }

    Write-Host "`nFollowing commands will be run with SQ CLI `n" -ForegroundColor Cyan

    $(gc "$commandFile") | Write-Host -ForegroundColor Green
    
    Write-Host "`nRunning SQ CLI... `n" -ForegroundColor Cyan

    $Command = "$SQPath\sqcli.exe"
    $Parms = "-run file=""$($commandFile)"
    $Prms = $Parms.Split(" ")
    $response = & "$Command" $Prms
        
    $anotherInstance = $response.Where({$_ -like "*It seems another instance of StrategyQuant X is running*"})
    if(-not ([string]::IsNullOrEmpty($anotherInstance)))
    {
        Write-Error "$($anotherInstance) You might want to close SQ UI and then run this command again."
        return
    }
    else
    {
        $response
    }

    Write-Host "Completed" -ForegroundColor Green
}

<#
    .DESCRIPTION
        This commands will export all StrategyQuant projects (.CFX) files and saves them under WorkflowResultsPath (See Get-MFG-Configuration for details). You might want to close SQ UI when you run this command.

    .SYNOPSIS

    .EXAMPLE
        SQ-Export-Projects
#>
function SQ-Export-Projects()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $SQPath = "$($config.MFGConfig.SQPath)"
    $rootPath = "$($config.MFGConfig.WorkflowResultsPath)"

    $Command = "$SQPath\sqcli.exe"
    $Parms = "-project action=list"

    $Prms = $Parms.Split(" ")
    $response = & "$Command" $Prms
    $anotherInstance = $response.Where({$_ -like "*It seems another instance of StrategyQuant X is running*"})
    if(-not ([string]::IsNullOrEmpty($anotherInstance)))
    {
        Write-Error "$anotherInstance"
        return
    }

    $projects = $response.Where({ $_ -like "*List of available projects*" },'SkipUntil') | select -Skip 2

    $commandFile = "$PSScriptRoot\ExportProjects.txt"

    if(Test-Path "$commandFile")
    {
        Clear-Content "$commandFile"
    }
    else
    {
        New-Item "$commandFile"
    }

    foreach($project in $projects)
    {

        if(-not ($project -like "*Exit app*"))
        {
            "-project action=saveconfig name=""$($project)"" file=""$($rootPath)\SQProjects\$($project).cfx""" | Add-Content "$commandFile"
        }

    }

    Write-Host "`nFollowing commands will be run with SQ CLI `n" -ForegroundColor Cyan

    $(gc "$commandFile") | Write-Host -ForegroundColor Green
    
    Write-Host "`nRunning SQ CLI... `n" -ForegroundColor Cyan

    $Command = "$SQPath\sqcli.exe"
    $Parms = "-run file=""$($commandFile)"
    $Prms = $Parms.Split(" ")
    $response = & "$Command" $Prms
        
    $anotherInstance = $response.Where({$_ -like "*It seems another instance of StrategyQuant X is running*"})
    if(-not ([string]::IsNullOrEmpty($anotherInstance)))
    {
        Write-Error "$($anotherInstance) You might want to close SQ UI and then run this command again."
        return
    }
    else
    {
        $response
    }

    Write-Host "Completed" -ForegroundColor Green
}

<#
    .DESCRIPTION
        This commands imports Symbols and its data to StrategyQuant based on the .csv files you have stored on your local machine under TSDataPath folder (See Get-MFG-Configuratio for details). You might want to close SQ UI to run this

    .SYNOPSIS

    .PARAMETER Symbol
        If you don't specify -Symbol parameter, this command will add all symbols that it finds under TSDataPath (Trade Station Data Path). If you only want to import one Symbol specify that 

    .PARAMETER Instrument
        This is the instrument name for your symbol that will be imported to Strategy Quant
    
    .EXAMPLE
        SQ-Import-Symbols -Symbol "AAPL" -Instrument "Standard stock"

    .EXAMPLE
        SQ-Import-Symbols
#>
function SQ-Import-Symbols($Symbol="All", $Instrument = "Standard stock")
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $SQPath = "$($config.MFGConfig.SQPath)"
    $TSDataPath = "$($config.MFGConfig.TSDataPath)"

    if(-NOT (Test-Path $TSDataPath))
    {
        Write-Error "Your Trade Station Data path $TSDataPath is not valid. Please run this command Set-MFG-Configuration to adjust the path"
    }

    if(-NOT (Test-Path $SQPath))
    {
        Write-Error "Your Strategy Quant path $SQPath is not valid. Please run this command Set-MFG-Configuration to adjust the path"
    }

    $commandFile = "$PSScriptRoot\ImportSymbols.txt"

    if(Test-Path "$commandFile")
    {
        Clear-Content "$commandFile"
    }
    else
    {
        New-Item "$commandFile"
    }
    
    $files = Get-ChildItem "$TSDataPath" -Recurse -Include *.csv

    $commands = @()

    foreach($file in $files)
    {
        $fileSymbol = $($file.Name.Split("_")[0])
        
        if($Symbol -eq "All" -or $fileSymbol -eq $Symbol)
        {
            Write-Host "Importing $($file.FullName) ...."

            $Command = "$SQPath\sqcli.exe"
            $Parms = "-data action=import bartype=endofbar symbol=$($file.Name.Split(".")[0]) instrument=""$($Instrument)"" filepath=""$($file.FullName)"" timezone=""EETUS"""
            $commands += $Parms
        }
    }

    if($commands.Length -gt 0)
    {
        $commands | Add-Content -Path "$commandFile"
    }

    Write-Host "`nFollowing commands will be run with SQ CLI `n" -ForegroundColor Cyan

    $(gc "$commandFile") | Write-Host -ForegroundColor Green
    
    Write-Host "`nRunning SQ CLI... `n" -ForegroundColor Cyan

    $Command = "$SQPath\sqcli.exe"
    $Parms = "-run file=""$($commandFile)"
    $Prms = $Parms.Split(" ")
    $response = & "$Command" $Prms
        
    $anotherInstance = $response.Where({$_ -like "*It seems another instance of StrategyQuant X is running*"})
    if(-not ([string]::IsNullOrEmpty($anotherInstance)))
    {
        Write-Error "$($anotherInstance) You might want to close SQ UI and then run this command again."
        return
    }
    else
    {
        $response
    }

    Write-Host "Completed" -ForegroundColor Green
   
}

<#
    .DESCRIPTION
        Deletes a symbol from SQ. Make sure SQ UI is not running

    .SYNOPSIS

    .PARAMETER Symbol
        Provide name of symbol to delete from SQ

    .EXAMPLE
        SQ-Delete-Symbol -Symbol "AAPL_1H"
            
#>
function SQ-Delete-Symbol($Symbol)
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    if([string]::IsNullOrEmpty($Symbol))
    {
        Write-Error "Please provide -Symbol name"
        return
    }

    $config = Load-MFG-Config
    $SQPath = "$($config.MFGConfig.SQPath)"
    
    if(-NOT (Test-Path $SQPath))
    {
        Write-Error "Your Strategy Quant path $SQPath is not valid. Please run this command Set-MFG-Configuration to adjust the path"
    }

    $commandFile = "$PSScriptRoot\DeleteSymbols.txt"

    if(Test-Path "$commandFile")
    {
        Clear-Content "$commandFile"
    }
    else
    {
        New-Item "$commandFile"
    }
    
    $Command = "$SQPath\sqcli.exe"
    $Parms = "-symbol action=delete symbols=$($Symbol)"
    $Parms | Add-Content -Path "$commandFile"

    Write-Host "`nFollowing commands will be run with SQ CLI `n" -ForegroundColor Cyan

    $(gc "$commandFile") | Write-Host -ForegroundColor Green
    
    Write-Host "`nRunning SQ CLI... `n" -ForegroundColor Cyan

    $Command = "$SQPath\sqcli.exe"
    $Parms = "-run file=""$($commandFile)"
    $Prms = $Parms.Split(" ")
    $response = & "$Command" $Prms
        
    $anotherInstance = $response.Where({$_ -like "*It seems another instance of StrategyQuant X is running*"})
    if(-not ([string]::IsNullOrEmpty($anotherInstance)))
    {
        Write-Error "$($anotherInstance) You might want to close SQ UI and then run this command again."
        return
    }
    else
    {
        $response
    }

    Write-Host "Completed" -ForegroundColor Green
   
}

<#
    .DESCRIPTION
        This commands prints all symbols available in StrategyQuant. You might want to close SQ UI to run this

    .SYNOPSIS

    .EXAMPLE
        SQ-List-Symbols
#>
function SQ-List-Symbols()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $SQPath = "$($config.MFGConfig.SQPath)"

    if(-NOT (Test-Path $SQPath))
    {
        Write-Error "Your Strategy Quant path $SQPath is not valid. Please run this command Set-MFG-Configuration to adjust the path"
    }
    
    $Command = "$SQPath\sqcli.exe"
    $Parms = "-symbol action=list"

    $Prms = $Parms.Split(" ")
    $response = & "$Command" $Prms
    $anotherInstance = $response.Where({$_ -like "*It seems another instance of StrategyQuant X is running*"})
    if(-not ([string]::IsNullOrEmpty($anotherInstance)))
    {
        Write-Error "$anotherInstance"
    }
    $response = $response.Where({ $_ -like "*Symbol,Instrument*" },'SkipUntil')
    $response = $response.Where({-Not($_ -like "*Data Listed*") })
    $response = $response.Where({-Not($_ -like "*----*") })
    $response = $response.Where({-Not($_ -like "*Exit app*") })
    $response = $response.Where({-Not($_ -like "*Symbol,Instrument*") })
    
    return $response
    
}

<#
    .DESCRIPTION
        This commands generates MFG Workflow command based on Symbol available in SQ. If you don't specify any parameter it will generate it for all Symbols. You might want to close SQ UI to run this

    .SYNOPSIS

    .PARAMETER Symbol
        If you don't specify -Symbol parameter, this command will generate workflow command for all symbols. 

    .EXAMPLE
        SQ-Generate-Workflow-Command -Symbol "AAPL"

    .EXAMPLE
        SQ-Generate-Workflow-Command
#>
function SQ-Generate-Workflow-Command($Symbol = "All")
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $found = $false
    $symbols = SQ-List-Symbols

    $commands = @("Command for Symbol")
    foreach($instrument in $symbols)
    {
        $symbolSplit = $instrument.split(",")
        if($Symbol -eq "All" -or $Symbol -eq "$($symbolSplit[0].Split("_")[0])")
        {
            $found = $true
            $command =  "Mine-Common -InstrumentToMine $($symbolSplit[0].Split("_")[0]) -BacktestTimeframe $($symbolSplit[6])"
            $commands += $command
        }
    }
    
    if($found -eq $true)
    {
        return $commands
    }
    else
    {
        return @("Command for Symbol","NotFound")
    }
}

function TS-Get-Symbol-StartingDate($FullDurationStartDate, $Symbol, $BTF)
{
    $config = Load-MFG-Config
    $TSDataPath = "$($config.MFGConfig.TSDataPath)"

    if(-NOT (Test-Path $TSDataPath))
    {
        Write-Error "Your Trade Station Data path $TSDataPath is not valid. Please run this command Set-MFG-Configuration to adjust the path"
    }
    
    $files = Get-ChildItem "$TSDataPath\*.csv" 

    foreach($file in $files)
    {
        if("$($file.Name.Split("_")[0])" -eq "$Symbol" -and $($file.Name) -like "*$($BTF)*")
        {
            $startingDate = "$((gc $file)[1].Split(",")[0])"
            
            $bits = $startingDate.Split("/")
            return "$($bits[2]).$($bits[0].PadLeft(2,'0')).$($bits[1].PadLeft(2,'0'))"
        }
    }
    
    return $FullDurationStartDate
    
}

function Print-HelpContent()
{

$HelpContent = @"

--- Usage Example 1 ---

TD-MFG-InitializeWorkflow -InstrumentToMine AAPL -Correlated_1 FB -Correlated_2 TSLA -InitialCapital 25000 -Drawdown 5000 -MaxStrategies 1500

Explanation:

- InstrumentToMine: This parameter represents the stock/instrument you want to mine. [Default value for this parameter is set to AAPL]
- Correlated_1: This stock/instrument symbol is used to cross-check correlation [Default value for this parameter is set to FB]
- Correlated_2: This stock/instrument symbol is used to cross-check correlation [Default value for this parameter is set to GOOG]
- InitialCapital: Planned capital to run this strategy [Default value for this parameter is set to 25000]
- Drawdown: This is max drawdown used to filter strategies [Default value for this parameter is set to 5000]
- MaxStrategies: This is max number of strategies you want to build [Default value for this parameter is set to 1500]

--- Usage Example 2 ---

TD-MFG-InitializeWorkflow -InstrumentToMine GS -Correlated_1 JPM -Correlated_2 MS -InitialCapital 10000 -Drawdown 2000 -MaxStrategies 1000

Explanation: You would like to mine GS and run correlation on JPM and MS. The max strategies you want to generate are 1000. You want to set your initial capital to 10,000 with a max drawdown of 2,000

--- Usage Example 3 ---

TD-MFG-InitializeWorkflow -InstrumentToMine NFLX

Explanation: You want to mine NFLX with default settings. This will use defaults for Correlated_1 (FB), Correlated_2 (GOOG), InitialCaptial (25000), Drawdown (5000) and Maxstrategies (1500)

--- Usage Example 4 ---

TD-MFG-InitializeWorkflow -InstrumentToMine MC -Correlated_1 V -Correlated_2 JPM -InitialCapital 25000 -Drawdown 5000 -MaxStrategies 1500 -FullDurationStartDate "2014.05.01" -FullDurationEndDate "2021.11.30"

Explanation:

You would like to mine MC with V and JPM as correlated symbols. 25k Initial Captial and max drawdown of 5k.

Date Format is yyyy.MM.dd (4 digits for year, 2 digits for month and 2 digits for day)

40% IS (step 2 in the workflow; Build phase)
30% OOS (step 2 in the workflow; Build phase)
30% OOS (step 3 in the workflow; Recency)

Note: If you are providing dates as input parameters, make sure they fall in the date range imported for the instrument (from CSV).

--- Usage Example 5 ---

TD-MFG-InitializeWorkflow -InstrumentToMine MC -Correlated_1 V -Correlated_2 JPM -InitialCapital 25000 -Drawdown 5000 -MaxStrategies 1500 -BacktestTimeframe M30 -AlternateTimeframe H1

Explanation:

You would like to mine MC with V and JPM as correlated symbols. 25k Initial Captial and max drawdown of 5k.

Backtest Timeframe will be M30
Alternate Timeframe will be H1

--- Usage Example 6 ---

TD-MFG-InitializeWorkflow -InstrumentToMine GS -Correlated_1 JPM -Correlated_2 MS -InitialCapital 10000 -Drawdown 2000 -MaxStrategies 1000 -Session RTH

Explanation: You would like to mine GS and run correlation on JPM and MS. The max strategies you want to generate are 1000. You want to set your initial capital to 10,000 with a max drawdown of 2,000. RTH will be used for Session. Default is 'No Session'

--- Usage Example 7 ---

TD-MFG-InitializeWorkflow -InstrumentToMine GS -Correlated_1 JPM -Correlated_2 MS -InitialCapital 10000 -Drawdown 2000 -MaxStrategies 1000 -SymbolTimeframeConvention SQ

Explanation: You would like to mine GS and run correlation on JPM and MS. The max strategies you want to generate are 1000. You want to set your initial capital to 10,000 with a max drawdown of 2,000. SQ naming convention will be used for instruments (MS_M30 instead of MFG convention MS_30M. Default is MFG convention)

--- Usage Example 8 ---

TD-MFG-InitializeWorkflow -InstrumentToMine GS -Correlated_1 JPM -Correlated_2 MS -InitialCapital 10000 -Drawdown 2000 -MaxStrategies 1000 -SymbolTimeframeConvention SQ -CorrelatedSymbolTimeframe M15 -UnCorrelatedSymbolTimeframe H1

Explanation: You would like to mine GS and run correlation on JPM and MS. The max strategies you want to generate are 1000. You want to set your initial capital to 10,000 with a max drawdown of 2,000. Overrides correlated symbol timeframe to M15 and uncorrelated to H1. Default is M30

--- Usage Example 9 ---

TD-MFG-InitializeWorkflow -InstrumentToMine GS -Correlated_1 JPM -Correlated_2 MS -InitialCapital 10000 -Drawdown 2000 -MaxStrategies 1000 -SymbolTimeframeConvention SQ -CorrelatedSymbolTimeframe M15 -UnCorrelatedSymbolTimeframe H1 -UnCorrelatedSymbol RBLX

Explanation: You would like to mine GS and run correlation on JPM and MS. The max strategies you want to generate are 1000. You want to set your initial capital to 10,000 with a max drawdown of 2,000. Overrides correlated symbol timeframe to M15 and uncorrelated to H1. Default is M30. Overrides Uncorrelated symbol to RBLX, default is GLD

--- Usage Example 10 ---

mine -Help

Prints command usage

--- Usage Example 11 ---

mine -Upgrade

Upgrades powershell module to latest

--- Usage Example 12 ---

Restore-Databanks -Symbol AAPL

Explanation: If for some unknown reasons SQ deletes the databank results, you can restore them to original location if you are using standard workflow template that stores results after each task under C:\Algos\SQ\MFG-Results. If you don't specify any parameter, it will restore results for all symbols under C:\Algos\SQ\MFG-Results.

--- Usage Example 13 ---

"SQ", "RBLX", "NVDA", "SOFI" | mine -Correlated_1 FB -Correlated_2 AAPL -BacktestTimeframe D1 -AlternateTimeframe H4

Explanation: You would like to create a workflow for SQ, RBLX, NVDA and SOFI. All of them will use FB and APPL for correlated symbols. BacktestTimeframe will be D1 and AlternateTimeframe will be H4

--- Usage Example 14 ---

Mine-Common -InstrumentToMine SHOP -FullDurationStartDate 2015.05.21

Explanation: Generates .cfx file for M30, D1 and H1

--- Usage Example 15 ---

Mine-D1 -InstrumentToMine TSLA –FullDurationStartDate 2010.06.29

Explanation: Generates .cfx file w/ D1 as backtest timeframe and H4 alternate timeframe

--- Usage Example 16 ---

Mine-M30 -InstrumentToMine TSLA –FullDurationStartDate 2010.06.29

Explanation: Generates .cfx file w/ M30 as backtest timeframe and H1 alternate timeframe

--- Usage Example 17 ---

Mine -InstrumentToMine TSLA –FullDurationStartDate 2010.06.29 -AverageTradesPerYear 100 AverageTrade 100

Explanation: To override Average Trades Per Year and Average Trades

--- Usage Example 18 ---

SQ-List-Symbols

Lists all the symbols and its metadata from your SQ.

--- Usage Example 19 ---

SQ-Generate-Workflow-Command -Symbol TSLA

Generates workflow command based on backtest timeframe in SQ. If you don't specify -Symbol, it will pull all symbols from SQ

--- Usage Example 20 ---

Mine -InstrumentToMine TSLA -GetBacktestTimeframeFromSQ

Gets the backtest start date from SQ to generate the workflow

--- Usage Example 21 ---

Get-MFG-Configuration

Displays your MFG configuration settings.

--- Usage Example 22 ---

Set-MFG-Configuration

You can set your MFG configuration with this command. It has parameters for -SQPath -TradeStationDataPath -WorkflowResultsPath and -UpgradeURL.

You might want to set your Trade Station Path where you save .csv files, like this Set-MFG-Configuration -TradeStationDataPath "C:\TradeStation\Data"

If you run it without passing any parameters, it will restore all settings to default.

--- Usage Example 23 ---

Mine-Common -InstrumentToMine TSLA -GetBacktestTimeframeFromTradeStationFile

Gets the starting date of backtest from the .csv file for TSLA. You need to set your folder path where you save .csv files to make this work. See this command Set-MFG-Configuration above

--- Usage Example 24 ---

Clear-Databanks (to speed up SQ)

Removes everything except Recency and Final results stored by SQ under C:\StrategyQuantX\user\projects. Note, if you plan to use this command, make sure to backup your data before running this command. The template I am using, that comes with the powershell commands saves everything (results) under C:\Algos\SQ\MFG-Results Therefore, it is perfectly fine for me to delete SQ folders. I only keep Final and Recency so UI can give me a clue if project has been mined already or not. To get the command use mine -upgrade Backup data before using this command

--- Usage Example 25 ---

TD-MFG-Test-Workflow -Symbol_1 AAPL -Symbol_2 TSLA -Symbol_3 SHOP -Symbol_4 ARKK -Symbol_5 IHI -TestDurationInMinutes 5 -BacktestTimeframe H1

Generates workflow w/ AAPL, TSLA, SHOP, ARKK and IHI. Test will run for TestDurationInMinutes

--- Usage Example 26 ---

Daily-Update

Run this as Administrator in Powershell ISE to setup a windows scheduled task that will download latest powershell modules daily

--- Usage Example 27 ---

SQ-Import-Symbols

Imports symbols and data from Trade Station directory. If no parameter is specified will load all symbols and its data to SQ.

If you want to limit it to specific symbol run it as SQ-Import-Symbols -Symbol AAPL -Instrument "Standard stock"

To set Trade Station directory use Set-MFG-Configuration -TradeStationDataPath "You TS Data folder where you keep .csv"

--- Usage Example 28 ---

SQ-Export-Projects

Exports SQ projects and saves them to .cfx files

"@

    Write-Host $HelpContent -ForegroundColor Cyan


}

<#
    .DESCRIPTION
        This commands validates EasyLanguage script provided to this function as a string parameter

    .SYNOPSIS

    .PARAMETER EasyLanguageScript
        Create a string variable and pass it in to this function. This string represents text of your EasyLanguage copied from SQ

    .PARAMETER InitialCapitalExpected
        You can specify Initial Capital to look for in the script

    .EXAMPLE
        SQ-Generate-Workflow-Command -EasyLanguageScript $myEasyLanguageSciptInString 

    .EXAMPLE
        SQ-Generate-Workflow-Command -EasyLanguageScript $myEasyLanguageSciptInString -InitialCapitalExpected 10000
#>
function Validate-Strategy([string]$EasyLanguageScript, $InitialCapitalExpected="25000")
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $lines = $EasyLanguageScript.Split("`n")
    $UseMoneyManagement = $lines | where {$_ -like "*bool UseMoneyManagement(*"}
    $mmUseAccountBalance = $lines | where {$_ -like "*mmUseAccountBalance(*"}
    $mmMaxSize = $lines | where {$_ -like "*double mmMaxSize(*"}
    $mmLotsIfNoMM = $lines | where {$_ -like "*double mmLotsIfNoMM*"}
    $InitialCapital = $lines | where {$_ -like "*InitialCapital(*"}

    if($UseMoneyManagement -ne $null -and $UseMoneyManagement.Trim() -ne "bool UseMoneyManagement(true),")
    {
        Write-Error "NOT FOUND bool UseMoneyManagement(true) -- Incorrect value is set $UseMoneyManagement"
    }
    elseif($UseMoneyManagement -eq $null)
    {
        Write-Error "NOT FOUND bool UseMoneyManagement(true)"
    }

    if($mmUseAccountBalance -ne $null -and $mmUseAccountBalance.Trim() -ne "bool mmUseAccountBalance(false),")
    {
        Write-Error "NOT FOUND bool mmUseAccountBalance(false), -- Incorrect value is set $mmUseAccountBalance"
    }
    elseif($mmUseAccountBalance -eq $null)
    {
        Write-Error "NOT FOUND bool mmUseAccountBalance(false)"
    }

    if($mmMaxSize -ne $null -and $mmMaxSize.Trim() -ne "double mmMaxSize(99999.0),")
    {
        Write-Error "NOT FOUND double mmMaxSize(99999.0), -- Incorrect value is set $mmMaxSize"
    }
    elseif($mmMaxSize -eq $null)
    {
        Write-Error "NOT FOUND double mmMaxSize(99999.0)"
    }

    if($mmLotsIfNoMM -ne $null -and $mmLotsIfNoMM.Trim() -ne "double mmLotsIfNoMM(1),")
    {
        Write-Error "NOT FOUND double mmLotsIfNoMM(1), -- Incorrect value is set $mmLotsIfNoMM"
    }
    elseif($mmLotsIfNoMM -eq $null)
    {
        Write-Error "NOT FOUND bool mmLotsIfNoMM(1)"
    }

    $expectedInitialCapital = "InitialCapital($InitialCapitalExpected);"

    if($InitialCapital -ne $null -and $InitialCapital.Trim() -ne "$expectedInitialCapital")
    {
        Write-Error "NOT FOUND $expectedInitialCapital -- Incorrect value is set $InitialCapital"
    }
    elseif($InitialCapital -eq $null)
    {
        Write-Error "NOT FOUND bool $expectedInitialCapital"
    }
    
}


<#
    .DESCRIPTION
        Removes everything except Recency Final and Incubate results stored by SQ under C:\StrategyQuantX\user\projects. 
        Note, if you plan to use this command, make sure to backup your data before running this command. 
        The template I am using, that comes with the powershell commands saves everything (results) under C:\Algos\SQ\MFG-Results 
        Therefore, it is perfectly fine for me to delete SQ folders. 
        I only keep Final and Recency so UI can give me a clue if project has been mined already or not. 
        Backup data before running this command

    .EXAMPLE
        Clear-Databanks
#>
function Clear-Databanks()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $confirmation = Read-Host "Are you Sure You Want To Proceed? This will remove most of the SQ results. You should backup your results before using this command. Press Y to delete databanks"
    if ($confirmation -eq 'y') {

        $config = Load-MFG-Config
        $SQProjectsFolder = "$($config.MFGConfig.SQPath)\user\projects"

        Get-ChildItem -Path "$SQProjectsFolder" -Recurse -exclude Results -Include *.sqx |
        Select -ExpandProperty FullName |
        Where {$_ -notlike '*Final*' -and $_ -notlike '*Recency*' -and $_ -notlike '*Incubate*'} |
        Remove-Item -force

    }

}

function Algo-CreateWorkspace($stock, $BacktestTimeframe = "H1")
{
    Write-Host "Creating workspace..." -ForegroundColor Green

    $config = Load-MFG-Config
    $rootPath = "$($config.MFGConfig.WorkflowResultsPath)"
    
    $rootPath = Join-Path $rootPath $stock

    md $rootPath -Force -ea SilentlyContinue

    md "$rootPath\Alternate timeframe_$BacktestTimeframe" -Force -ea SilentlyContinue
    md "$rootPath\Correlated_$BacktestTimeframe" -Force -ea SilentlyContinue
    md "$rootPath\Final_$BacktestTimeframe" -Force -ea SilentlyContinue
    md "$rootPath\Full time span_$BacktestTimeframe" -Force -ea SilentlyContinue
    md "$rootPath\MC_$BacktestTimeframe" -Force -ea SilentlyContinue
    md "$rootPath\Recency_$BacktestTimeframe" -Force -ea SilentlyContinue
    md "$rootPath\SPP_$BacktestTimeframe" -Force -ea SilentlyContinue
    md "$rootPath\Results_$BacktestTimeframe" -Force -ea SilentlyContinue
    

}

function Algo-Create-IncubationWorkspace($Folder)
{
    Write-Host "Creating workspace..." -ForegroundColor Green

    $config = Load-MFG-Config
    $rootPath = "$($config.MFGConfig.WorkflowResultsPath)"
    
    $rootPath = Join-Path $rootPath $Folder

    md $rootPath -Force -ea SilentlyContinue

    md "$rootPath\Results" -Force -ea SilentlyContinue
    md "$rootPath\Incubation" -Force -ea SilentlyContinue
    md "$rootPath\ManualReview" -Force -ea SilentlyContinue
}


function Get-SymbolTimeframe($timeframe, 
    [ValidateSet("SQ", "MFG")]
    [string]
    $SymbolTimeframeConvention = "MFG")
{
    
    if($SymbolTimeframeConvention -eq "SQ")
    {
        return $timeframe
    }

    $digits = ""
    $timespan = ""

    try{
        if ($timeframe -match "(?<number>\d)")
        {
            $digits = $timeframe.Substring($timeframe.indexof($Matches.number));
            $timespan = $timeframe.Substring(0,$timeframe.indexof($Matches.number));
        }
    }
    catch{}

    $computedTimeFrame = "$digits$timespan"

    if([string]::IsNullOrEmpty($computedTimeFrame))
    {
        return $timeframe
    }

    return $computedTimeFrame
}

<#
    .DESCRIPTION
        Creates three workflows. H1/M30, D1/H4 and M30/H1 for TSLA
        Gets the back test start date from Trade Station .csv file (less typing is better)
        Uses AAPL and FB as Correlated symbols. You can override them if you want with Correlated_1 and Correlated_2
        Uses defaults for Drardown, InitialCapital, Average Trades, Average Trades Per Year etc. but if you like to override them use addtional switches
        Mine-Common is the alias for this command

    .SYNOPSIS

    .PARAMETER InstrumentToMine
        This is the symbol name you want to mine    

    .PARAMETER Correlated_1
        This is the symbol for correlated market

    .PARAMETER Correlated_2
        This is the symbol for correlated market

    .PARAMETER InitialCapital
        Initial Capital allocated to run this strategy

    .PARAMETER Drawdown
        Maximum drawdown to filter trades

    .PARAMETER MaxStrategies
        Total strategies you want to Build before checking Recency step

    .PARAMETER FullDurationStartDate
        This is starting date of your backtest

    .PARAMETER FullDurationEndDate
        This is when your full span test ends

    .PARAMETER CorrelatedSymbolTimeframe
        This is correlated symbol's timeframe

    .PARAMETER UnCorrelatedSymbolTimeframe
        This is un-correlated symbol's timeframe

    .PARAMETER Session
        This is the Session name used by workflow

    .PARAMETER SymbolTimeframeConvention
        SQ naming convention to use for instruments. SQ sets it as MS_M30 instead of MFG's convention of MS_30M. 

    .PARAMETER UnCorrelatedSymbol
        This is un-correlated symbol

    .PARAMETER AverageTradesPerYear
        Average Trades Per Year

    .PARAMETER AverageTrade
        Average Trades

    .PARAMETER GetBacktestTimeframeFromSQ
        Gets backtest start date from Strategy Quant. You might want to have SQ UI closed to run this

    .PARAMETER GetBacktestTimeframeFromTradeStationFile
        Gets backtest start date from Trade Station Data folder (See Get-MFG-Configuration for details)

    .EXAMPLE
        TD-MFG-InitializeWorkflow-CommonTimeframes -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow-CommonTimeframes -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.26" -Correlated_1 "TSLA"

    .EXAMPLE
        TD-MFG-InitializeWorkflow-CommonTimeframes -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.06" -Session "RTH"

    .EXAMPLE
        TD-MFG-InitializeWorkflow-CommonTimeframes -InstrumentToMine "AAPL" -SymbolTimeframeConvention SQ

    .EXAMPLE
        Mine-Common -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile
#>
function TD-MFG-InitializeWorkflow-CommonTimeframes
(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]
    $InstrumentToMine = "AAPL", 
    $Correlated_1 = "FB", 
    $Correlated_2 = "AAPL", 
    $InitialCapital = "25000", 
    $Drawdown = "5000", 
    $MaxStrategies = "1500", 
    $FullDurationStartDate="2000.01.01", 
    $FullDurationEndDate= $(Get-Date),
    [ValidateSet("Tradestation","MultiCharts")]
    [string]
    $Engine = "Tradestation",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $CorrelatedSymbolTimeframe = "M30",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $UnCorrelatedSymbolTimeframe = "M30",
    $Session = "No Session",
    [ValidateSet("SQ", "MFG")]
    [string]
    $SymbolTimeframeConvention = "MFG",
    [Parameter(Mandatory=$false)]
    [Switch]$Help,
    $UnCorrelatedSymbol = "GLD",
    [Parameter(Mandatory=$false)]
    [Switch]$Upgrade,
    $AverageTradesPerYear = "15",
    $AverageTrade = "95",
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromSQ,
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromTradeStationFile,
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $TradeStationFileTimeFrame = "H1",
    $BuildAlgoFiltersXMLFilePath,
    [Parameter(Mandatory=$false)]
    [Switch]$AppendUniqueIdentifierToWorkflowName
    )

{

    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    TD-MFG-InitializeWorkflow -InstrumentToMine $InstrumentToMine -Correlated_1 $Correlated_1 -Correlated_2 $Correlated_2 -InitialCapital $InitialCapital `
                               -Drawdown $Drawdown -MaxStrategies $MaxStrategies -FullDurationStartDate $FullDurationStartDate `
                               -FullDurationEndDate $FullDurationEndDate -BacktestTimeframe M30 -AlternateTimeframe H1 -CorrelatedSymbolTimeframe $CorrelatedSymbolTimeframe `
                               -UnCorrelatedSymbolTimeframe $UnCorrelatedSymbolTimeframe -Session $Session -SymbolTimeframeConvention $SymbolTimeframeConvention `
                               -AverageTrade $AverageTrade -AverageTradesPerYear $AverageTradesPerYear -GetBacktestTimeframeFromSQ:$GetBacktestTimeframeFromSQ `
                               -GetBacktestTimeframeFromTradeStationFile:$GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame $TradeStationFileTimeFrame -Engine $Engine -BuildAlgoFiltersXMLFilePath "$BuildAlgoFiltersXMLFilePath" -AppendUniqueIdentifierToWorkflowName:$AppendUniqueIdentifierToWorkflowName

    TD-MFG-InitializeWorkflow -InstrumentToMine $InstrumentToMine -Correlated_1 $Correlated_1 -Correlated_2 $Correlated_2 -InitialCapital $InitialCapital `
                               -Drawdown $Drawdown -MaxStrategies $MaxStrategies -FullDurationStartDate $FullDurationStartDate `
                               -FullDurationEndDate $FullDurationEndDate -BacktestTimeframe D1 -AlternateTimeframe H4 -CorrelatedSymbolTimeframe $CorrelatedSymbolTimeframe `
                               -UnCorrelatedSymbolTimeframe $UnCorrelatedSymbolTimeframe -Session $Session -SymbolTimeframeConvention $SymbolTimeframeConvention `
                               -AverageTrade $AverageTrade -AverageTradesPerYear $AverageTradesPerYear -GetBacktestTimeframeFromSQ:$GetBacktestTimeframeFromSQ `
                               -GetBacktestTimeframeFromTradeStationFile:$GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame $TradeStationFileTimeFrame -Engine $Engine -BuildAlgoFiltersXMLFilePath "$BuildAlgoFiltersXMLFilePath" -AppendUniqueIdentifierToWorkflowName:$AppendUniqueIdentifierToWorkflowName

    TD-MFG-InitializeWorkflow -InstrumentToMine $InstrumentToMine -Correlated_1 $Correlated_1 -Correlated_2 $Correlated_2 -InitialCapital $InitialCapital `
                               -Drawdown $Drawdown -MaxStrategies $MaxStrategies -FullDurationStartDate $FullDurationStartDate `
                               -FullDurationEndDate $FullDurationEndDate -BacktestTimeframe H1 -AlternateTimeframe M30 -CorrelatedSymbolTimeframe $CorrelatedSymbolTimeframe `
                               -UnCorrelatedSymbolTimeframe $UnCorrelatedSymbolTimeframe -Session $Session -SymbolTimeframeConvention $SymbolTimeframeConvention `
                               -AverageTrade $AverageTrade -AverageTradesPerYear $AverageTradesPerYear -GetBacktestTimeframeFromSQ:$GetBacktestTimeframeFromSQ `
                               -GetBacktestTimeframeFromTradeStationFile:$GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame $TradeStationFileTimeFrame -Engine $Engine -BuildAlgoFiltersXMLFilePath "$BuildAlgoFiltersXMLFilePath" -AppendUniqueIdentifierToWorkflowName:$AppendUniqueIdentifierToWorkflowName

    TD-MFG-InitializeWorkflow -InstrumentToMine $InstrumentToMine -Correlated_1 $Correlated_1 -Correlated_2 $Correlated_2 -InitialCapital $InitialCapital `
                               -Drawdown $Drawdown -MaxStrategies $MaxStrategies -FullDurationStartDate $FullDurationStartDate `
                               -FullDurationEndDate $FullDurationEndDate -BacktestTimeframe H4 -AlternateTimeframe H1 -CorrelatedSymbolTimeframe $CorrelatedSymbolTimeframe `
                               -UnCorrelatedSymbolTimeframe $UnCorrelatedSymbolTimeframe -Session $Session -SymbolTimeframeConvention $SymbolTimeframeConvention `
                               -AverageTrade $AverageTrade -AverageTradesPerYear $AverageTradesPerYear -GetBacktestTimeframeFromSQ:$GetBacktestTimeframeFromSQ `
                               -GetBacktestTimeframeFromTradeStationFile:$GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame $TradeStationFileTimeFrame -Engine $Engine -BuildAlgoFiltersXMLFilePath "$BuildAlgoFiltersXMLFilePath" -AppendUniqueIdentifierToWorkflowName:$AppendUniqueIdentifierToWorkflowName

    TD-MFG-InitializeWorkflow -InstrumentToMine $InstrumentToMine -Correlated_1 $Correlated_1 -Correlated_2 $Correlated_2 -InitialCapital $InitialCapital `
                               -Drawdown $Drawdown -MaxStrategies $MaxStrategies -FullDurationStartDate $FullDurationStartDate `
                               -FullDurationEndDate $FullDurationEndDate -BacktestTimeframe H2 -AlternateTimeframe H4 -CorrelatedSymbolTimeframe $CorrelatedSymbolTimeframe `
                               -UnCorrelatedSymbolTimeframe $UnCorrelatedSymbolTimeframe -Session $Session -SymbolTimeframeConvention $SymbolTimeframeConvention `
                               -AverageTrade $AverageTrade -AverageTradesPerYear $AverageTradesPerYear -GetBacktestTimeframeFromSQ:$GetBacktestTimeframeFromSQ `
                               -GetBacktestTimeframeFromTradeStationFile:$GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame $TradeStationFileTimeFrame -Engine $Engine -BuildAlgoFiltersXMLFilePath "$BuildAlgoFiltersXMLFilePath" -AppendUniqueIdentifierToWorkflowName:$AppendUniqueIdentifierToWorkflowName

}

<#
    .DESCRIPTION
        Creates M30/H1 Workflow. Mine-M30 is the alias for this command
        
    .SYNOPSIS

    .PARAMETER InstrumentToMine
        This is the symbol name you want to mine    

    .PARAMETER Correlated_1
        This is the symbol for correlated market

    .PARAMETER Correlated_2
        This is the symbol for correlated market

    .PARAMETER InitialCapital
        Initial Capital allocated to run this strategy

    .PARAMETER Drawdown
        Maximum drawdown to filter trades

    .PARAMETER MaxStrategies
        Total strategies you want to Build before checking Recency step

    .PARAMETER FullDurationStartDate
        This is starting date of your backtest

    .PARAMETER FullDurationEndDate
        This is when your full span test ends

    .PARAMETER CorrelatedSymbolTimeframe
        This is correlated symbol's timeframe

    .PARAMETER UnCorrelatedSymbolTimeframe
        This is un-correlated symbol's timeframe

    .PARAMETER Session
        This is the Session name used by workflow

    .PARAMETER SymbolTimeframeConvention
        SQ naming convention to use for instruments. SQ sets it as MS_M30 instead of MFG's convention of MS_30M. 

    .PARAMETER UnCorrelatedSymbol
        This is un-correlated symbol

    .PARAMETER AverageTradesPerYear
        Average Trades Per Year

    .PARAMETER AverageTrade
        Average Trades

    .PARAMETER GetBacktestTimeframeFromSQ
        Gets backtest start date from Strategy Quant. You might want to have SQ UI closed to run this

    .PARAMETER GetBacktestTimeframeFromTradeStationFile
        Gets backtest start date from Trade Station Data folder (See Get-MFG-Configuration for details)

    .PARAMETER TradeStationFileTimeFrame
        Use this parameter to specify the Trade Station file naming convention when you like to pull backtest timeframe from .csv file. See GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow-M30 -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow-M30 -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.26" -Correlated_1 "TSLA"

    .EXAMPLE
        TD-MFG-InitializeWorkflow-M30 -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.06" -Session "RTH"

    .EXAMPLE
        TD-MFG-InitializeWorkflow-M30 -InstrumentToMine "AAPL" -SymbolTimeframeConvention SQ

    .EXAMPLE
        Mine-M30 -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.06" -Session "RTH"
#>
function TD-MFG-InitializeWorkflow-M30
(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]
    $InstrumentToMine = "AAPL", 
    $Correlated_1 = "FB", 
    $Correlated_2 = "AAPL", 
    $InitialCapital = "25000", 
    $Drawdown = "5000", 
    $MaxStrategies = "1500", 
    $FullDurationStartDate="2000.01.01",
    [ValidateSet("Tradestation","MultiCharts")]
    [string]
    $Engine = "Tradestation",
    $FullDurationEndDate= $(Get-Date),
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $CorrelatedSymbolTimeframe = "M30",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $UnCorrelatedSymbolTimeframe = "M30",
    $Session = "No Session",
    [ValidateSet("SQ", "MFG")]
    [string]
    $SymbolTimeframeConvention = "MFG",
    [Parameter(Mandatory=$false)]
    [Switch]$Help,
    $UnCorrelatedSymbol = "GLD",
    [Parameter(Mandatory=$false)]
    [Switch]$Upgrade,
    $AverageTradesPerYear = "15",
    $AverageTrade = "95",
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromSQ,
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromTradeStationFile,
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $TradeStationFileTimeFrame = "H1",
    $BuildAlgoFiltersXMLFilePath,
    [Parameter(Mandatory=$false)]
    [Switch]$AppendUniqueIdentifierToWorkflowName
    )

{

    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    TD-MFG-InitializeWorkflow -InstrumentToMine $InstrumentToMine -Correlated_1 $Correlated_1 -Correlated_2 $Correlated_2 -InitialCapital $InitialCapital `
                               -Drawdown $Drawdown -MaxStrategies $MaxStrategies -FullDurationStartDate $FullDurationStartDate `
                               -FullDurationEndDate $FullDurationEndDate -BacktestTimeframe M30 -AlternateTimeframe H1 -CorrelatedSymbolTimeframe $CorrelatedSymbolTimeframe `
                               -UnCorrelatedSymbolTimeframe $UnCorrelatedSymbolTimeframe -Session $Session -SymbolTimeframeConvention $SymbolTimeframeConvention `
                               -AverageTrade $AverageTrade -AverageTradesPerYear $AverageTradesPerYear -GetBacktestTimeframeFromSQ:$GetBacktestTimeframeFromSQ `
                               -GetBacktestTimeframeFromTradeStationFile:$GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame $TradeStationFileTimeFrame -Engine $Engine -BuildAlgoFiltersXMLFilePath "$BuildAlgoFiltersXMLFilePath" -AppendUniqueIdentifierToWorkflowName:$AppendUniqueIdentifierToWorkflowName

    

}

<#
    .DESCRIPTION
        Creates D1 and H4 Workflow
        Mine-D1 is the alias for this command
        
    .PARAMETER InstrumentToMine
        This is the symbol name you want to mine    

    .PARAMETER Correlated_1
        This is the symbol for correlated market

    .PARAMETER Correlated_2
        This is the symbol for correlated market

    .PARAMETER InitialCapital
        Initial Capital allocated to run this strategy

    .PARAMETER Drawdown
        Maximum drawdown to filter trades

    .PARAMETER MaxStrategies
        Total strategies you want to Build before checking Recency step

    .PARAMETER FullDurationStartDate
        This is starting date of your backtest

    .PARAMETER FullDurationEndDate
        This is when your full span test ends

    .PARAMETER CorrelatedSymbolTimeframe
        This is correlated symbol's timeframe

    .PARAMETER UnCorrelatedSymbolTimeframe
        This is un-correlated symbol's timeframe

    .PARAMETER Session
        This is the Session name used by workflow

    .PARAMETER SymbolTimeframeConvention
        SQ naming convention to use for instruments. SQ sets it as MS_M30 instead of MFG's convention of MS_30M. 

    .PARAMETER UnCorrelatedSymbol
        This is un-correlated symbol

    .PARAMETER AverageTradesPerYear
        Average Trades Per Year

    .PARAMETER AverageTrade
        Average Trades

    .PARAMETER GetBacktestTimeframeFromSQ
        Gets backtest start date from Strategy Quant. You might want to have SQ UI closed to run this

    .PARAMETER GetBacktestTimeframeFromTradeStationFile
        Gets backtest start date from Trade Station Data folder (See Get-MFG-Configuration for details)

    .PARAMETER TradeStationFileTimeFrame
        Use this parameter to specify the Trade Station file naming convention when you like to pull backtest timeframe from .csv file. See GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow-D1 -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow-D1 -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.26" -Correlated_1 "TSLA"

    .EXAMPLE
        TD-MFG-InitializeWorkflow-D1 -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.06" -Session "RTH"

    .EXAMPLE
        TD-MFG-InitializeWorkflow-D1 -InstrumentToMine "AAPL" -SymbolTimeframeConvention SQ

    .EXAMPLE
        Mine-D1 -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.26" -Correlated_1 "TSLA"
#>
function TD-MFG-InitializeWorkflow-D1
(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]
    $InstrumentToMine = "AAPL", 
    $Correlated_1 = "FB", 
    $Correlated_2 = "AAPL", 
    $InitialCapital = "25000", 
    $Drawdown = "5000", 
    $MaxStrategies = "1500", 
    $FullDurationStartDate="2000.01.01", 
    [ValidateSet("Tradestation","MultiCharts")]
    [string]
    $Engine = "Tradestation",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $CorrelatedSymbolTimeframe = "M30",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $UnCorrelatedSymbolTimeframe = "M30",
    $Session = "No Session",
    [ValidateSet("SQ", "MFG")]
    [string]
    $SymbolTimeframeConvention = "MFG",
    [Parameter(Mandatory=$false)]
    [Switch]$Help,
    $UnCorrelatedSymbol = "GLD",
    [Parameter(Mandatory=$false)]
    [Switch]$Upgrade,
    $AverageTradesPerYear = "15",
    $AverageTrade = "95",
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromSQ,
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromTradeStationFile,
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $TradeStationFileTimeFrame = "H1",
    $BuildAlgoFiltersXMLFilePath,
    [Parameter(Mandatory=$false)]
    [Switch]$AppendUniqueIdentifierToWorkflowName
    )

{

    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    TD-MFG-InitializeWorkflow -InstrumentToMine $InstrumentToMine -Correlated_1 $Correlated_1 -Correlated_2 $Correlated_2 -InitialCapital $InitialCapital `
                               -Drawdown $Drawdown -MaxStrategies $MaxStrategies -FullDurationStartDate $FullDurationStartDate `
                               -FullDurationEndDate $FullDurationEndDate -BacktestTimeframe D1 -AlternateTimeframe H4 -CorrelatedSymbolTimeframe $CorrelatedSymbolTimeframe `
                               -UnCorrelatedSymbolTimeframe $UnCorrelatedSymbolTimeframe -Session $Session -SymbolTimeframeConvention $SymbolTimeframeConvention `
                               -AverageTrade $AverageTrade -AverageTradesPerYear $AverageTradesPerYear -GetBacktestTimeframeFromSQ:$GetBacktestTimeframeFromSQ `
                               -GetBacktestTimeframeFromTradeStationFile:$GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame $TradeStationFileTimeFrame -Engine $Engine -BuildAlgoFiltersXMLFilePath "$BuildAlgoFiltersXMLFilePath" -AppendUniqueIdentifierToWorkflowName:$AppendUniqueIdentifierToWorkflowName

}

function Get-BackTestTimeframeFromSQ($Symbol, $FullDurationStartDate)
{
    $commands = SQ-Generate-Workflow-Command -Symbol $Symbol

    if($commands[1] -eq "NotFound")
    {
        
        Write-Host "$Symbol not found in Strategy Quant, will use default for FullDurationStartDate $FullDurationStartDate" -ForegroundColor Red
        return $FullDurationStartDate
    }
    else
    {
        return $commands[1].Split(" ")[4]
    }
}

<#
    .DESCRIPTION
        Creates Workflow based on BackTestTimeframe and AlternateTimeframe specified. Mine is the alias for this command
        
    .SYNOPSIS

    .PARAMETER InstrumentToMine
        This is the symbol name you want to mine    

    .PARAMETER Correlated_1
        This is the symbol for correlated market

    .PARAMETER Correlated_2
        This is the symbol for correlated market

    .PARAMETER BacktestTimeframe
        Backtest timeframe

    .PARAMETER InitialCapital
        Initial Capital allocated to run this strategy

    .PARAMETER Drawdown
        Maximum drawdown to filter trades

    .PARAMETER MaxStrategies
        Total strategies you want to Build before checking Recency step

    .PARAMETER FullDurationStartDate
        This is starting date of your backtest

    .PARAMETER FullDurationEndDate
        This is when your full span test ends

    .PARAMETER CorrelatedSymbolTimeframe
        This is correlated symbol's timeframe

    .PARAMETER UnCorrelatedSymbolTimeframe
        This is un-correlated symbol's timeframe

    .PARAMETER Session
        This is the Session name used by workflow

    .PARAMETER SymbolTimeframeConvention
        SQ naming convention to use for instruments. SQ sets it as MS_M30 instead of MFG's convention of MS_30M. 

    .PARAMETER UnCorrelatedSymbol
        This is un-correlated symbol

    .PARAMETER Upgrade
        Upgrades your pwoershell modules

    .PARAMETER AverageTradesPerYear
        Average Trades Per Year

    .PARAMETER AverageTrade
        Average Trades

    .PARAMETER GetBacktestTimeframeFromSQ
        Gets backtest start date from Strategy Quant. You might want to have SQ UI closed to run this

    .PARAMETER GetBacktestTimeframeFromTradeStationFile
        Gets backtest start date from Trade Station Data folder (See Get-MFG-Configuration for details)

    .PARAMETER UpdateUserSettings
        This switch updates user settings in file MFGConfig.json to default

    .PARAMETER TradeStationFileTimeFrame
        Use this parameter to specify the Trade Station file naming convention when you like to pull backtest timeframe from .csv file. See GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.26" -Correlated_1 "TSLA"

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.06" -Session "RTH"

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -SymbolTimeframeConvention SQ

    .EXAMPLE
        Mine -Upgrade

    .EXAMPLE
        Mine -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame H1 -SymbolTimeframeConvention SQ

    .EXAMPLE
        Mine -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile -TradeStationFileTimeFrame H1
#>
function TD-MFG-InitializeWorkflow(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]
    $InstrumentToMine = "AAPL", 
    $Correlated_1 = "FB", 
    $Correlated_2 = "AAPL", 
    $InitialCapital = "25000", 
    $Drawdown = "5000", 
    $MaxStrategies = "1500", 
    $FullDurationStartDate="2000.01.01", 
    $FullDurationEndDate= $(Get-Date),
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $BacktestTimeframe = "H1",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $AlternateTimeframe = "M30",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $CorrelatedSymbolTimeframe = "M30",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $UnCorrelatedSymbolTimeframe = "M30",
    $Session = "No Session",
    [ValidateSet("SQ", "MFG")]
    [string]
    $SymbolTimeframeConvention = "MFG",
    [Parameter(Mandatory=$false)]
    [Switch]$Help,
    $UnCorrelatedSymbol = "GLD",
    [Parameter(Mandatory=$false)]
    [Switch]$Upgrade,
    $AverageTradesPerYear = "15",
    $AverageTrade = "95",
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromSQ,
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromTradeStationFile,
    [Parameter(Mandatory=$false)]
    [Switch]$UpdateUserSettings,
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $TradeStationFileTimeFrame = "H1",
    [ValidateSet("Tradestation","MultiCharts")]
    [string]
    $Engine = "Tradestation",
    $BuildAlgoFiltersXMLFilePath,
    [Parameter(Mandatory=$false)]
    [Switch]$AppendUniqueIdentifierToWorkflowName
    )
{
    BEGIN {
        #region LogParameters
        $command = $MyInvocation.InvocationName
        
        $PSBoundParameters.GetEnumerator().ForEach({
                $command += " -$($_.Key)" + " $($_.Value)"
            })
  
        

        try{
            "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
        }
        catch
        {
        
        }
        #endregion LogParameters
    }
	PROCESS
	{
        $InSampleStartDate = ""
        $RecencyStartDate  = ""
        $RecencyEndDate = ""
        $OutOfSampleStartDate = ""

        if($Help -eq $true)
        {
            return Print-HelpContent
        }

        if($Upgrade -eq $true)
        {
            Upgrade-Module -UpdateUserSettings:$UpdateUserSettings
            Write-Host "`nPackage has been upgraded. Run following command" -ForegroundColor Green
            Write-Host "`nImport-Module '$($PSScriptRoot)\MFGAlgos.psm1' -force -DisableNameChecking" -ForegroundColor Cyan
            return
        }

        if($GetBacktestTimeframeFromSQ -eq $true)
        {
            Write-Host "Attmpting to get Backtest Start Date from SQ...." -ForegroundColor Green
            $FullDurationStartDate =  Get-BackTestTimeframeFromSQ -Symbol $InstrumentToMine -FullDurationStartDate $FullDurationStartDate
        }

        if($GetBacktestTimeframeFromTradeStationFile -eq $true)
        {
            $BTF = Get-SymbolTimeframe -timeframe $TradeStationFileTimeFrame -SymbolTimeframeConvention $SymbolTimeframeConvention

            Write-Host "Attmpting to get Backtest Start Date from Trade Station File....for BTF: $BTF" -ForegroundColor Green
            $FullDurationStartDate =  TS-Get-Symbol-StartingDate -Symbol $InstrumentToMine -FullDurationStartDate $FullDurationStartDate -BTF $BTF
        }
        
        try{
            if($FullDurationEndDate.GetType().Name -eq "String")
            {
                $FullDurationEndDate = [datetime]::parseexact($FullDurationEndDate, "yyyy.MM.dd", $null)
            }
        
            $ts = New-TimeSpan -Start $FullDurationStartDate -End $FullDurationEndDate
            $backtestDuration = [math]::Round(.7 * $ts.Days)
            $InSampleDuration = [math]::Round(.4 * $ts.Days) 
            
            $startingDateFormat = [datetime]::parseexact($FullDurationStartDate, "yyyy.MM.dd", $null)
            $backTestEnds = $startingDateFormat.AddDays($backtestDuration)
            $OutOfSampleStartDate = $startingDateFormat.AddDays($InSampleDuration)

            "Backtest start date: $($startingDateFormat.ToString("yyyy.MM.dd"))"
            "Backtest end date: $($backTestEnds.ToString("yyyy.MM.dd"))"
            "Out Of Sample start date: $($OutOfSampleStartDate.ToString("yyyy.MM.dd"))"
            "Recency start date: $($backTestEnds.ToString("yyyy.MM.dd"))"
            "Recency end date: $($FullDurationEndDate.ToString("yyyy.MM.dd"))"
            "Full duration start date: $($startingDateFormat.ToString("yyyy.MM.dd"))"
            "Full duration end date: $($FullDurationEndDate.ToString("yyyy.MM.dd"))"

            $InSampleStartDate = "$($startingDateFormat.ToString("yyyy.MM.dd"))"
            $RecencyStartDate  = "$($backTestEnds.ToString("yyyy.MM.dd"))"
            $RecencyEndDate = "$($FullDurationEndDate.ToString("yyyy.MM.dd"))"
            $OutOfSampleStartDate = "$($OutOfSampleStartDate.ToString("yyyy.MM.dd"))"

        }
        catch
        {
            Write-Host "Please enter date in correct format yyyy.MM.dd Example: 2021.04.21" -ForegroundColor Red
            Write-Host "$_" -ForegroundColor DarkYellow
            return
        }

        foreach($instrument in $InstrumentToMine)
        {

            $BTF = Get-SymbolTimeframe -timeframe $BacktestTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
            $ATF = Get-SymbolTimeframe -timeframe $AlternateTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
            $CTF = Get-SymbolTimeframe -timeframe $CorrelatedSymbolTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
            $UTF = Get-SymbolTimeframe -timeframe $UnCorrelatedSymbolTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
    
            $Guid = ""

            if($AppendUniqueIdentifierToWorkflowName -eq $true)
            {
                $Guid = "-" + $(New-Guid)
            }

            $config = "$PSScriptRoot\config.xml"

            $MFGconfig = Load-MFG-Config
            $SaveFileToPath = "$($MFGconfig.MFGConfig.WorkflowResultsPath)"
            
            $rootFolder = "$SaveFileToPath\$instrument"

            Algo-CreateWorkspace -stock $instrument -BacktestTimeframe "$BacktestTimeframe"

            copy-item -Path $config -Destination $rootFolder

            $newConfigFilePath = "$rootFolder\config.xml"

            if(-NOT ([string]::IsNullOrEmpty($BuildAlgoFiltersXMLFilePath)))
            {
                Replace-BuildAlgoFilters -configFilePath "$newConfigFilePath" -buildAlgoFilterFilePath "$BuildAlgoFiltersXMLFilePath"
            }

            Write-Host "Replacing placeholders..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[UL_Stock]', "$instrument").replace('[UC_Stock]', "$UnCorrelatedSymbol").replace('[Correlated_1]', "$Correlated_1").replace('[Correlated_2]', "$Correlated_2").replace('[Drawdown]', "$Drawdown").replace('[InitialCapital]', "$InitialCapital").replace('[MaxStrategies]', "$MaxStrategies").replace('[Guid]', "$Guid") | Set-Content $newConfigFilePath -Force
    
            Write-Host "Updating folder paths for 'Save file' tasks..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[ResultsFolder]', "$rootFolder\Results_$BacktestTimeframe").replace('[SPPFolder]', "$rootFolder\SPP_$BacktestTimeframe").replace('[RecencyFolder]', "$rootFolder\Recency_$BacktestTimeframe").replace('[MCFolder]', "$rootFolder\MC_$BacktestTimeframe").replace('[FulltimespanFolder]', "$rootFolder\Full time span_$BacktestTimeframe").replace('[FinalFolder]', "$rootFolder\Final_$BacktestTimeframe").replace('[CorrelatedFolder]', "$rootFolder\Correlated_$BacktestTimeframe").replace('[AlternatetimeframeFolder]', "$rootFolder\Alternate timeframe_$BacktestTimeframe")  | Set-Content $newConfigFilePath -Force
    
            Write-Host "Updating IS, OS and Recency dates..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[IS_StartDate]', "$InSampleStartDate").replace('[Recency_Start_Date]',"$RecencyStartDate").replace('[Recency_End_Date]',"$RecencyEndDate").replace('[OS_Start_Date]',"$OutOfSampleStartDate") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing timeframes..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[ATF]', "$ATF").replace('[UTF]', "$UTF").replace('[CTF]', "$CTF").replace('[TF]',"$BTF").replace('[BacktestTimeframe]',"$BacktestTimeframe").replace('[AlternateTimeframe]',"$AlternateTimeframe") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing session..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[NoSession]', "$Session") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing average trades..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[AvgTradesPerYear]', "$AverageTradesPerYear").replace('[AvgTrade]', "$AverageTrade") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing Engine..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[Engine]', "$Engine") | Set-Content $newConfigFilePath -Force

            Write-Host "Packaging workflow..." -ForegroundColor Green

            $7zipPath = "$PSScriptRoot\7z.exe"

            if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
                throw "7 zip file $($7zipPath) not found. Please install 7-zip at this path: $PSScriptRoot from this website and then retry: https://www.7-zip.org/download.html"
            }

            $Target = "$rootFolder\MFG-$Instrument-$BacktestTimeframe$Guid.cfx"

            Set-Alias 7zip "$7zipPath"

            7zip a -tzip "$($Target)" "$newConfigFilePath"

            Write-Host "Wooho! workflow file has been created. Check the workflow file at path: $Target" -ForegroundColor Green
        }
    }

    END {}
}

function Replace-BuildAlgoFilters($configFilePath, $buildAlgoFilterFilePath)
{
    if(-NOT (Test-Path "$configFilePath"))
    {
        Write-Host "File not found $configFilePath. Default filters will be used for Build Algo task" -ForegroundColor Cyan
        return
    }
    
    if(-NOT (Test-Path "$buildAlgoFilterFilePath"))
    {
        Write-Host "File not found $buildAlgoFilterFilePath. Default filters will be used for Build Algo task" -ForegroundColor Cyan
        return
    }

    $doc = New-Object System.Xml.XmlDocument
    $doc.Load($configFilePath)
    $buildAlgoTask = $doc.Project.Tasks.Task | where {$_.name -eq "Build strategies"}
    Write-Host "Attempting to replace Build Algo task filters from file $buildAlgoFilterFilePath" -ForegroundColor Green
    $buildAlgoTask.Settings.Rankings.Conditions.InnerXml = (gc "$buildAlgoFilterFilePath").Replace("<Conditions>","").Replace("</Conditions>","")

    $doc.Save($configFilePath)

    Write-Host "Build Algo task filters have been replaced" -ForegroundColor Green
}

function TD-MFG-Incubation-Workflow(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]
    $InstrumentToMine = "AAPL", 
    $Correlated_1 = "FB", 
    $Correlated_2 = "AAPL", 
    $InitialCapital = "25000", 
    $Drawdown = "5000", 
    $MaxStrategies = "1500", 
    $FullDurationStartDate="2000.01.01", 
    $FullDurationEndDate= $(Get-Date),
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $BacktestTimeframe = "H1",
    [ValidateSet("Tradestation","MultiCharts")]
    [string]
    $Engine = "Tradestation",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $AlternateTimeframe = "M30",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $CorrelatedSymbolTimeframe = "M30",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $UnCorrelatedSymbolTimeframe = "M30",
    $Session = "No Session",
    [ValidateSet("SQ", "MFG")]
    [string]
    $SymbolTimeframeConvention = "MFG",
    [Parameter(Mandatory=$false)]
    [Switch]$Help,
    $UnCorrelatedSymbol = "GLD",
    [Parameter(Mandatory=$false)]
    [Switch]$Upgrade,
    $AverageTradesPerYear = "15",
    $AverageTrade = "95",
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromSQ,
    [Parameter(Mandatory=$false)]
    [Switch]$GetBacktestTimeframeFromTradeStationFile,
    [Parameter(Mandatory=$false)]
    [Switch]$UpdateUserSettings,
    $BuildAlgoFiltersXMLFilePath
    )
{
    BEGIN {
        
        #region LogParameters
        $command = $MyInvocation.InvocationName
        
        $PSBoundParameters.GetEnumerator().ForEach({
                $command += " -$($_.Key)" + " $($_.Value)"
            })
  
        

        try{
            "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
        }
        catch
        {
        
        }
        #endregion LogParameters
    
    }
	PROCESS
	{
        $InSampleStartDate = ""
        $RecencyStartDate  = ""
        $RecencyEndDate = ""
        $OutOfSampleStartDate = ""

        if($Help -eq $true)
        {
            return Print-HelpContent
        }

        if($Upgrade -eq $true)
        {
            Upgrade-Module -UpdateUserSettings:$UpdateUserSettings
            Write-Host "`nPackage has been upgraded. Run following command" -ForegroundColor Green
            Write-Host "`nImport-Module '$($PSScriptRoot)\MFGAlgos.psm1' -force -DisableNameChecking" -ForegroundColor Cyan
            return
        }

        if($GetBacktestTimeframeFromSQ -eq $true)
        {
            Write-Host "Attmpting to get Backtest Start Date from SQ...." -ForegroundColor Green
            $FullDurationStartDate =  Get-BackTestTimeframeFromSQ -Symbol $InstrumentToMine -FullDurationStartDate $FullDurationStartDate
        }

        if($GetBacktestTimeframeFromTradeStationFile -eq $true)
        {
            Write-Host "Attmpting to get Backtest Start Date from Trade Station File...." -ForegroundColor Green
            $FullDurationStartDate =  TS-Get-Symbol-StartingDate -Symbol $InstrumentToMine -FullDurationStartDate $FullDurationStartDate
        }
        
        try{
            if($FullDurationEndDate.GetType().Name -eq "String")
            {
                $FullDurationEndDate = [datetime]::parseexact($FullDurationEndDate, "yyyy.MM.dd", $null)
            }
        
            $ts = New-TimeSpan -Start $FullDurationStartDate -End $FullDurationEndDate
            $backtestDuration = [math]::Round(.7 * $ts.Days)
            $InSampleDuration = [math]::Round(.4 * $ts.Days) 
            
            $startingDateFormat = [datetime]::parseexact($FullDurationStartDate, "yyyy.MM.dd", $null)
            $backTestEnds = $startingDateFormat.AddDays($backtestDuration)
            $OutOfSampleStartDate = $startingDateFormat.AddDays($InSampleDuration)

            "Backtest start date: $($startingDateFormat.ToString("yyyy.MM.dd"))"
            "Backtest end date: $($backTestEnds.ToString("yyyy.MM.dd"))"
            "Out Of Sample start date: $($OutOfSampleStartDate.ToString("yyyy.MM.dd"))"
            "Recency start date: $($backTestEnds.ToString("yyyy.MM.dd"))"
            "Recency end date: $($FullDurationEndDate.ToString("yyyy.MM.dd"))"
            "Full duration start date: $($startingDateFormat.ToString("yyyy.MM.dd"))"
            "Full duration end date: $($FullDurationEndDate.ToString("yyyy.MM.dd"))"

            $InSampleStartDate = "$($startingDateFormat.ToString("yyyy.MM.dd"))"
            $RecencyStartDate  = "$($backTestEnds.ToString("yyyy.MM.dd"))"
            $RecencyEndDate = "$($FullDurationEndDate.ToString("yyyy.MM.dd"))"
            $OutOfSampleStartDate = "$($OutOfSampleStartDate.ToString("yyyy.MM.dd"))"

        }
        catch
        {
            Write-Host "Please enter date in correct format yyyy.MM.dd Example: 2021.04.21" -ForegroundColor Red
            Write-Host "$_" -ForegroundColor DarkYellow
            return
        }

        foreach($instrument in $InstrumentToMine)
        {

            $BTF = Get-SymbolTimeframe -timeframe $BacktestTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
            $ATF = Get-SymbolTimeframe -timeframe $AlternateTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
            $CTF = Get-SymbolTimeframe -timeframe $CorrelatedSymbolTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
            $UTF = Get-SymbolTimeframe -timeframe $UnCorrelatedSymbolTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
    
            $config = "$PSScriptRoot\config.xml"

            $MFGconfig = Load-MFG-Config
            $SaveFileToPath = "$($MFGconfig.MFGConfig.WorkflowResultsPath)"
            
            $rootFolder = "$SaveFileToPath\$instrument"

            Algo-CreateWorkspace -stock $instrument -BacktestTimeframe "$BacktestTimeframe"

            copy-item -Path $config -Destination "$rootFolder\config.xml"

            $newConfigFilePath = "$rootFolder\config.xml"

            if(-NOT ([string]::IsNullOrEmpty($BuildAlgoFiltersXMLFilePath)))
            {
                Replace-BuildAlgoFilters -configFilePath "$newConfigFilePath" -buildAlgoFilterFilePath "$BuildAlgoFiltersXMLFilePath"
            }
            
            Write-Host "Replacing placeholders..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[UL_Stock]', "$instrument").replace('[UC_Stock]', "$UnCorrelatedSymbol").replace('[Correlated_1]', "$Correlated_1").replace('[Correlated_2]', "$Correlated_2").replace('[Drawdown]', "$Drawdown").replace('[InitialCapital]', "$InitialCapital").replace('[MaxStrategies]', "$MaxStrategies") | Set-Content $newConfigFilePath -Force
    
            Write-Host "Updating folder paths for 'Save file' tasks..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[ResultsFolder]', "$rootFolder\Results_$BacktestTimeframe").replace('[SPPFolder]', "$rootFolder\SPP_$BacktestTimeframe").replace('[RecencyFolder]', "$rootFolder\Recency_$BacktestTimeframe").replace('[MCFolder]', "$rootFolder\MC_$BacktestTimeframe").replace('[FulltimespanFolder]', "$rootFolder\Full time span_$BacktestTimeframe").replace('[FinalFolder]', "$rootFolder\Final_$BacktestTimeframe").replace('[CorrelatedFolder]', "$rootFolder\Correlated_$BacktestTimeframe").replace('[AlternatetimeframeFolder]', "$rootFolder\Alternate timeframe_$BacktestTimeframe")  | Set-Content $newConfigFilePath -Force
    
            Write-Host "Updating IS, OS and Recency dates..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[IS_StartDate]', "$InSampleStartDate").replace('[Recency_Start_Date]',"$RecencyStartDate").replace('[Recency_End_Date]',"$RecencyEndDate").replace('[OS_Start_Date]',"$OutOfSampleStartDate") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing timeframes..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[ATF]', "$ATF").replace('[UTF]', "$UTF").replace('[CTF]', "$CTF").replace('[TF]',"$BTF").replace('[BacktestTimeframe]',"$BacktestTimeframe").replace('[AlternateTimeframe]',"$AlternateTimeframe") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing session..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[NoSession]', "$Session") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing average trades..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[AvgTradesPerYear]', "$AverageTradesPerYear").replace('[AvgTrade]', "$AverageTrade") | Set-Content $newConfigFilePath -Force

            Write-Host "Replacing Engine..." -ForegroundColor Green

            (gc $newConfigFilePath).replace('[Engine]', "$Engine") | Set-Content $newConfigFilePath -Force

            Write-Host "Packaging workflow..." -ForegroundColor Green

            $7zipPath = "$PSScriptRoot\7z.exe"

            if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
                throw "7 zip file $($7zipPath) not found. Please install 7-zip at this path: $PSScriptRoot from this website and then retry: https://www.7-zip.org/download.html"
            }

            $Target = "$rootFolder\MFG-$Instrument-$BacktestTimeframe.cfx"

            Set-Alias 7zip "$7zipPath"

            7zip a -tzip "$($Target)" "$newConfigFilePath"

            Write-Host "Wooho! workflow file has been created. Check the workflow file at path: $Target" -ForegroundColor Green
        }
    }

    END {}
}

<#
    .DESCRIPTION
        Generates workflow w/ five symbols to quickly validate if we see some strategies
        
    .SYNOPSIS

    .PARAMETER Symbol_1
        This is first symbol    

    .PARAMETER Symbol_2
        This is second symbol

    .PARAMETER Symbol_3
        This is third symbol

    .PARAMETER Symbol_4
        This is forth symbol

    .PARAMETER Symbol_5
        This is fifth symbol

    .PARAMETER TestDurationInMinutes
        Test will run for these many minutes on each symbol

    .PARAMETER InitialCapital
        Initial Capital allocated to run this strategy

    .PARAMETER Drawdown
        Maximum drawdown to filter trades

    .PARAMETER MaxStrategies
        Total strategies you want to Build before checking Recency step

    .PARAMETER FullDurationStartDate
        This is starting date of your backtest

    .PARAMETER FullDurationEndDate
        This is when your full span test ends

    .PARAMETER UnCorrelatedSymbolTimeframe
        This is un-correlated symbol's timeframe

    .PARAMETER Session
        This is the Session name used by workflow

    .PARAMETER SymbolTimeframeConvention
        SQ naming convention to use for instruments. SQ sets it as MS_M30 instead of MFG's convention of MS_30M. 

    .PARAMETER BacktestTimeframe
        Backtest timeframe

    .PARAMETER AverageTradesPerYear
        Average Trades Per Year

    .PARAMETER AverageTrade
        Average Trades

    .PARAMETER GetBacktestTimeframeFromSQ
        Gets backtest start date from Strategy Quant. You might want to have SQ UI closed to run this

    .PARAMETER GetBacktestTimeframeFromTradeStationFile
        Gets backtest start date from Trade Station Data folder (See Get-MFG-Configuration for details)

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.26" -Correlated_1 "TSLA"

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -FullDurationStartDate "2005.01.06" -Session "RTH"

    .EXAMPLE
        TD-MFG-InitializeWorkflow -InstrumentToMine "AAPL" -SymbolTimeframeConvention SQ

    .EXAMPLE
        Mine -Upgrade

    .EXAMPLE
        Mine -InstrumentToMine "AAPL" -GetBacktestTimeframeFromTradeStationFile
#>
function TD-MFG-Test-Workflow(
    $Symbol_1 = "AAPL", 
    $Symbol_2 = "SHOP", 
    $Symbol_3 = "AMZN", 
    $Symbol_4 = "ARKK", 
    $Symbol_5 = "TSLA", 
    $TestDurationInMinutes = "5", 
    $InitialCapital = "25000", 
    $Drawdown = "5000", 
    $MaxStrategies = "1500", 
    $FullDurationStartDate="2000.01.01", 
    $FullDurationEndDate= $(Get-Date),
    [ValidateSet("Tradestation","MultiCharts")]
    [string]
    $Engine = "Tradestation",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    [string]
    $BacktestTimeframe = "H1",
    [ValidateSet("M1","M5","M15","M30", "H1", "H2", "H4", "D1")]
    $Session = "No Session",
    [ValidateSet("SQ", "MFG")]
    [string]
    $SymbolTimeframeConvention = "MFG",
    $AverageTradesPerYear = "15",
    $AverageTrade = "95"
    )
{
    BEGIN {
        
        #region LogParameters
        $command = $MyInvocation.InvocationName
        
        $PSBoundParameters.GetEnumerator().ForEach({
                $command += " -$($_.Key)" + " $($_.Value)"
            })
  
        

        try{
            "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
        }
        catch
        {
        
        }
        #endregion LogParameters

    }
	PROCESS
	{
        $InSampleStartDate = ""
        $RecencyStartDate  = ""
        $RecencyEndDate = ""
        $OutOfSampleStartDate = ""

        try{
            if($FullDurationEndDate.GetType().Name -eq "String")
            {
                $FullDurationEndDate = [datetime]::parseexact($FullDurationEndDate, "yyyy.MM.dd", $null)
            }
        
            $ts = New-TimeSpan -Start $FullDurationStartDate -End $FullDurationEndDate
            $backtestDuration = [math]::Round(.7 * $ts.Days)
            $InSampleDuration = [math]::Round(.4 * $ts.Days) 
            
            $startingDateFormat = [datetime]::parseexact($FullDurationStartDate, "yyyy.MM.dd", $null)
            $backTestEnds = $startingDateFormat.AddDays($backtestDuration)
            $OutOfSampleStartDate = $startingDateFormat.AddDays($InSampleDuration)

            "Backtest start date: $($startingDateFormat.ToString("yyyy.MM.dd"))"
            "Backtest end date: $($backTestEnds.ToString("yyyy.MM.dd"))"
            "Out Of Sample start date: $($OutOfSampleStartDate.ToString("yyyy.MM.dd"))"
            "Recency start date: $($backTestEnds.ToString("yyyy.MM.dd"))"
            "Recency end date: $($FullDurationEndDate.ToString("yyyy.MM.dd"))"
            "Full duration start date: $($startingDateFormat.ToString("yyyy.MM.dd"))"
            "Full duration end date: $($FullDurationEndDate.ToString("yyyy.MM.dd"))"

            $InSampleStartDate = "$($startingDateFormat.ToString("yyyy.MM.dd"))"
            $RecencyStartDate  = "$($backTestEnds.ToString("yyyy.MM.dd"))"
            $RecencyEndDate = "$($FullDurationEndDate.ToString("yyyy.MM.dd"))"
            $OutOfSampleStartDate = "$($OutOfSampleStartDate.ToString("yyyy.MM.dd"))"

        }
        catch
        {
            Write-Host "Please enter date in correct format yyyy.MM.dd Example: 2021.04.21" -ForegroundColor Red
            Write-Host "$_" -ForegroundColor DarkYellow
            return
        }

        $BTF = Get-SymbolTimeframe -timeframe $BacktestTimeframe -SymbolTimeframeConvention $SymbolTimeframeConvention
    
        $config = "$PSScriptRoot\quickTest.xml"

        $MFGconfig = Load-MFG-Config
        $SaveFileToPath = "$($MFGconfig.MFGConfig.WorkflowResultsPath)"
            
        $rootFolder = "$SaveFileToPath\QuickTest"

        Algo-CreateWorkspace -stock "QuickTest" -BacktestTimeframe "$BacktestTimeframe"

        copy-item -Path $config -Destination "$rootFolder\config.xml"

        $newConfigFilePath = "$rootFolder\config.xml"

        Write-Host "Replacing placeholders..." -ForegroundColor Green

        (gc $newConfigFilePath).replace('[UL_Stock_1]', "$Symbol_1").replace('[UL_Stock_2]', "$Symbol_2").replace('[UL_Stock_3]', "$Symbol_3").replace('[UL_Stock_4]', "$Symbol_4").replace('[UL_Stock_5]', "$Symbol_5").replace('[Drawdown]', "$Drawdown").replace('[InitialCapital]', "$InitialCapital").replace('[MaxStrategies]', "$MaxStrategies") | Set-Content $newConfigFilePath -Force
               
        Write-Host "Updating IS, OS and Recency dates..." -ForegroundColor Green

        (gc $newConfigFilePath).replace('[IS_StartDate]', "$InSampleStartDate").replace('[Recency_Start_Date]',"$RecencyStartDate").replace('[Recency_End_Date]',"$RecencyEndDate").replace('[OS_Start_Date]',"$OutOfSampleStartDate") | Set-Content $newConfigFilePath -Force

        Write-Host "Replacing timeframes..." -ForegroundColor Green

        (gc $newConfigFilePath).replace('[ATF]', "$ATF").replace('[UTF]', "$UTF").replace('[CTF]', "$CTF").replace('[TF]',"$BTF").replace('[BacktestTimeframe]',"$BacktestTimeframe").replace('[AlternateTimeframe]',"$AlternateTimeframe") | Set-Content $newConfigFilePath -Force

        Write-Host "Replacing session..." -ForegroundColor Green

        (gc $newConfigFilePath).replace('[NoSession]', "$Session") | Set-Content $newConfigFilePath -Force

        Write-Host "Replacing average trades..." -ForegroundColor Green

        (gc $newConfigFilePath).replace('[AvgTradesPerYear]', "$AverageTradesPerYear").replace('[AvgTrade]', "$AverageTrade") | Set-Content $newConfigFilePath -Force

        Write-Host "Replacing test duration..." -ForegroundColor Green

        (gc $newConfigFilePath).replace('[Test_Duration]', "$TestDurationInMinutes") | Set-Content $newConfigFilePath -Force

        Write-Host "Replacing Engine..." -ForegroundColor Green

        (gc $newConfigFilePath).replace('[Engine]', "$Engine") | Set-Content $newConfigFilePath -Force

        Write-Host "Packaging workflow..." -ForegroundColor Green

        $7zipPath = "$PSScriptRoot\7z.exe"

        if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
            throw "7 zip file $($7zipPath) not found. Please install 7-zip at this path: $PSScriptRoot from this website and then retry: https://www.7-zip.org/download.html"
        }

        $Target = "$rootFolder\MFG-QuickTest-$BacktestTimeframe.cfx"

        Set-Alias 7zip "$7zipPath"

        7zip a -tzip "$($Target)" "$newConfigFilePath"

        Write-Host "Wooho! workflow file has been created. Check the workflow file at path: $Target" -ForegroundColor Green
        
    }

    END {}
}

function Create-IncubationWorkSpace()
{
    $config = "$PSScriptRoot\IncubationReview.xml"

    $MFGconfig = Load-MFG-Config
    $SaveFileToPath = "$($MFGconfig.MFGConfig.WorkflowResultsPath)"
            
    $rootFolder = "$workflowResultsFolder\IncubationReview"

    Algo-Create-IncubationWorkspace -Folder "IncubationReview"

    copy-item -Path $config -Destination "$rootFolder\config.xml"

    $newConfigFilePath = "$rootFolder\config.xml"
   
    Write-Host "Updating folder paths for 'Save file' tasks..." -ForegroundColor Green

    (gc $newConfigFilePath).replace('[SaveResults]', "$rootFolder\Results").replace('[SaveReview]', "$rootFolder\ManualReview") | Set-Content $newConfigFilePath -Force
    
    $7zipPath = "$PSScriptRoot\7z.exe"

    if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
        throw "7 zip file $($7zipPath) not found. Please install 7-zip at this path: $PSScriptRoot from this website and then retry: https://www.7-zip.org/download.html"
    }

    $Target = "$rootFolder\IncubationReview.cfx"

    Set-Alias 7zip "$7zipPath"

    7zip a -tzip "$($Target)" "$newConfigFilePath"

    Write-Host "Wooho! workflow file has been created. Check the workflow file at path: $Target" -ForegroundColor Green
}

<#
    .DESCRIPTION
        Creates IncubationReview Workflow
        Imports a new Project named IncubationReview to SQ
        Creates two databanks - Results and Manual Review
        Collects strategies from Final* folder that exist under WorkflowResultsPath (See Get-MFG-Configuration for details). This folder is generally pointing to C:\Algos\SQ\MFG-Results
        Final Strategies are added to Results databank. Strategy Name is modified to add Symbol and Timeframe to it so it is easy to identify where we copied the strategy from
        Make sure SQ UI is closed when you run this

        
    .EXAMPLE
        Collect-Strategies-For-Incubation-Review
#>
function Collect-Strategies-For-Incubation-Review()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $workflowResultsFolder = "$($config.MFGConfig.WorkflowResultsPath)"
    $SQPath = "$($config.MFGConfig.SQPath)"
    $SQDatabankFolder = "$($config.MFGConfig.SQPath)\user\projects\IncubationReview\databanks\Results"

    $rootFolder = "$workflowResultsFolder\IncubationReview"
   
    Create-IncubationWorkSpace

    $dirs = Get-ChildItem -Directory -Recurse  "$workflowResultsFolder" | where {$_.Name -like "*Final*"}

    foreach($dir in $dirs)
    {
        $files = Get-ChildItem  "$($dir.FullName)" -Include *.sqx -Recurse

        foreach($file in $files)
        {
            $Directory = "$($file.Directory.Name)"
            $Parent = "$($file.Directory.Parent.Name)"
            Copy-Item -Path "$($file.FullName)" -Destination "$rootFolder\$($Parent)_$($Directory)_$($file.Name)" -Verbose
        }
    }

    Write-Host "Getting list of projects from SQ..." -ForegroundColor Green

    $Command = "$SQPath\sqcli.exe"
    $Parms = "-project action=list"

    $Prms = $Parms.Split(" ")
    $response = & "$Command" $Prms
    $anotherInstance = $response.Where({$_ -like "*It seems another instance of StrategyQuant X is running*"})
    if(-not ([string]::IsNullOrEmpty($anotherInstance)))
    {
        Write-Error "$anotherInstance"
        return
    }

    $projects = $response.Where({ $_ -like "*List of available projects*" },'SkipUntil') | select -Skip 2

    if($($projects | where {$_-eq "IncubationReview"}) -ne $null)
    {
        Write-Error "There is already a project named IncubationReview in SQ. Please remove that project and try again. Make sure to save any strategies in Manual Review before you remove the project."
        return
    }

    SQ-Import-Projects -FolderWithCFXFiles "$rootFolder"

    md "$SQDatabankFolder" -Force -ea SilentlyContinue

    Copy-Item -Path "$rootFolder\*" -Destination "$SQDatabankFolder" -Force -verbose


}

function Copy-Mined-Results-From-Incubation()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $config = Load-MFG-Config
    $workflowResultsFolder = "$($config.MFGConfig.WorkflowResultsPath)"
    $SQPath = "$($config.MFGConfig.SQPath)"

    $rootFolder = "$workflowResultsFolder\IncubationReview\Incubation"
   
    Create-IncubationWorkSpace

    $dirs = Get-ChildItem -Directory -Recurse  "$SQPath" | where {$_.Name -like "*Incubate*"}

    foreach($dir in $dirs)
    {
        $files = Get-ChildItem  "$($dir.FullName)" -Include *.sqx -Recurse

        foreach($file in $files)
        {
            $Directory = "$($file.Directory.Name)"
            $Parent = "$($file.Directory.Parent.Name)"
            Copy-Item -Path "$($file.FullName)" -Destination "$rootFolder\$($Parent)_$($Directory)_$($file.Name)".Replace("databanks_Incubate_","") -Verbose
        }
    }

}

<#
    .DESCRIPTION
        Changes date format from dd.MM.yyyy HH:mm:ss to MM/dd/yyyy HH:mm for a CSV trade log exported from Quant Analyzer

    .PARAMETER filePath
        CSV file path
    
    .EXAMPLE
        QA-Fix-Date-Format -filePath c:\QA\tradelogs.csv
#>
function QA-Fix-Date-Format($filePath)
{

    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $p = import-csv "$filePath"

    $p | foreach{

        $closeTime = $_.'Close time'
        $openTime = $_.'Open Time'

        $closeTimeGlobal = $_.'Close time (Global)'
        $openTimeGlobal = $_.'Open time (Global)'

        if($closeTime)
        {
            $original = [datetime]::parseexact($closeTime, "dd.MM.yyyy HH:mm:ss", $null)
            $_.'Close time' = $original.ToString("MM/dd/yyyy HH:mm K")
        }
        
        if($openTime)
        {
            $original = [datetime]::parseexact($openTime, "dd.MM.yyyy HH:mm:ss", $null)
            $_.'Open Time' = $original.ToString("MM/dd/yyyy HH:mm K")
        }

        if($closeTimeGlobal)
        {
            $original = [datetime]::parseexact($closeTimeGlobal, "dd.MM.yyyy HH:mm:ss", $null)
            $_.'Close time (Global)' = $original.ToString("MM/dd/yyyy HH:mm K")
        }
        
        if($openTimeGlobal)
        {
            $original = [datetime]::parseexact($openTimeGlobal, "dd.MM.yyyy HH:mm:ss", $null)
            $_.'Open time (Global)' = $original.ToString("MM/dd/yyyy HH:mm K")
        }
    }

    $p | Export-Csv "$filePath"

}

<#
    .DESCRIPTION
        Checks following
        Internet connection is working
        Ninja Trader is running
        Trade Station is running
        Think or Swim is running
        See Set-MFG-Configuration command to set what all tools you would like to validate. You can turn on/off checks for Ninja Trader, Trade Station and TOS

    .PARAMETER NoAudio
        Average If you don't want status in audio
    
    .EXAMPLE
        Check-TradingPlatforms
#>
function Check-TradingPlatforms([Parameter(Mandatory=$false)]
                    [Switch]$NoAudio)
{
    
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters
    
    Add-Type -AssemblyName presentationCore
    $mediaPlayer = New-Object system.windows.media.mediaplayer

    $json = Load-MFG-Config

    $issue = $null

    $netCheck = Get-NetRoute | ? DestinationPrefix -eq '0.0.0.0/0' | Get-NetIPInterface | Where ConnectionState -eq 'Connected'

    if(($($json.MFGConfig.CheckInternetConnection) -eq $true) -and $netCheck -eq $null)
    {
        if($NoAudio -eq $false)
        {
            $mediaPlayer.open("$($PSScriptRoot)\65334180.mp3")
            $mediaPlayer.Play()
        }

        $issue = "Internet connection is down"
    }
    elseif(($($json.MFGConfig.CheckNinjaTrader) -eq $true) -and $(Get-Process -Name NinjaTrader -ea SilentlyContinue) -eq $null)
    {
        if($NoAudio -eq $false)
        {
            $mediaPlayer.open("$($PSScriptRoot)\65334185.mp3")
            $mediaPlayer.Play()
        }

        $issue = "Ninja Trader is not working"
    }
    elseif(($($json.MFGConfig.CheckTradeStation) -eq $true) -and $(Get-Process -Name TradeStationAgentForms -ea SilentlyContinue) -eq $null)
    {
        if($NoAudio -eq $false)
        {
            $mediaPlayer.open("$($PSScriptRoot)\65334198.mp3")
            $mediaPlayer.Play()
        }

        $issue = "Trade Station is not working"
    }
    elseif(($($json.MFGConfig.CheckTOS) -eq $true) -and $(Get-Process -Name thinkorswim -ea SilentlyContinue) -eq $null)
    {
        if($NoAudio -eq $false)
        {
            $mediaPlayer.open("$($PSScriptRoot)\65334189.mp3")
            $mediaPlayer.Play()
        }
        $issue = "Think or Swim is not working"
    }
    elseif(($($json.MFGConfig.CheckTWS) -eq $true) -and $(Get-Process -Name tws -ea SilentlyContinue) -eq $null)
    {
        if($NoAudio -eq $false)
        {
            $mediaPlayer.open("$($PSScriptRoot)\65343124.mp3")
            $mediaPlayer.Play()
        }
        $issue = "TWS is not working"
    }
    elseif(($($json.MFGConfig.CheckMulticharts) -eq $true) -and $(Get-Process -Name Multicharts* -ea SilentlyContinue) -eq $null)
    {
        if($NoAudio -eq $false)
        {
            $mediaPlayer.open("$($PSScriptRoot)\65343126.mp3")
            $mediaPlayer.Play()
        }
        $issue = "MultiCharts is not working"
    }
    else
    {
        if($NoAudio -eq $false)
        {
            $mediaPlayer.open("$($PSScriptRoot)\65334211.mp3")
            $mediaPlayer.Play()
        }

        Write-Host "Trading platform looks good. Happy trading" -ForegroundColor Green

    }

    if($issue -ne $null)
    {
        Write-Warning "$issue"
        Test-SMS -Subject "$issue"
    }
}

<#
    .DESCRIPTION
        Uploads your strategies to Git. If you upload more than 10 strategies, it will download strategies uploaded by rest of the community
        
    .PARAMETER FolderPathForSQXFiles
        Folder path where you keep your .sqx files for either incubation or live strategies

    .PARAMETER Stage
        Either Incubation or Live

    .PARAMETER FirstName
        Your First Name. Please specify a valid name. Your strategies are organized on Git by your name

    .PARAMETER LastName
        Your Last Name. Please specify a valid name. Your strategies are organized on Git by your name
    
    .EXAMPLE
        Share-Strategies-With-Community -FolderPathForSQXFiles 'C:\Algos\SQ\MFG-Results\IncubationReview\In_Incubation' -Stage Incubation -FirstName Sohail -LastName Tahir
#>
function Share-Strategies-With-Community($FolderPathForSQXFiles, 
[ValidateSet("Incubation","Live")]
[string]
$Stage = "Incubation", 
$FirstName, $LastName)
{

    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    

    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    if([string]::IsNullOrEmpty($FolderPathForSQXFiles))
    {
        Write-Error "Please specify -FolderPathForSQXFiles parameter"
        return
    }

    if([string]::IsNullOrEmpty($FirstName))
    {
        Write-Error "Please specify -FirstName parameter. Your strategies will be organized by your name"
        return
    }

    if([string]::IsNullOrEmpty($LastName))
    {
        Write-Error "Please specify -LastName parameter. Your strategies will be organized by your name"
        return
    }

    if(-Not (Test-Path "$FolderPathForSQXFiles"))
    {
        Write-Error "This is not a valid path $FolderPathForSQXFiles . Please try again with a correct Folder Path"
        return
    }


    $accessToken = "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"

    $files = Get-ChildItem -Path "$FolderPathForSQXFiles" -Recurse -Include *.sqx

    [int]$strategyCount = 0

    if($files -ne $null)
    {
        Write-Host "Total strategies found $($files.Count)" -ForegroundColor Green
        
        $strategyCount = [int] "$($files.Count)"

        if($strategyCount -gt 100)
        {
            Write-Error "Sorry, you cannot upload more than 100 strategies. Please filter the strategies and then try again"
            return
        }

        foreach($file in $files)
        {
            $Content1 = get-content "$($file.FullName)"
            $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Content1)
            $Encoded = [System.Convert]::ToBase64String($Bytes)
            
            $commitMessage = "MFG Commit"

            $JSON = @{
                "message" = "$($commitMessage)"
                "content" = "$($Encoded)"
    
            } | ConvertTo-Json


            try{
                $response = Invoke-RestMethod -Uri "https://api.github.com/repos/stahir80td/TD-MFG-Strategies/contents/$($Stage)/$($FirstName)$($LastName)/$($file.Name)" -Method Put -Headers @{"Authorization" = "Bearer $accessToken"} -Body $json -Verbose
            }
            catch
            {
                if($_.ErrorDetails.Message -like "*sha*")
                {
                    Write-Host "$($file.FullName) has already been uploaded" -ForegroundColor Cyan
                }
                else
                {
                    Write-Error $_
                }
            }    
        }
    }

    if($strategyCount -ge 10)
    {
        $fileName = "strategies-" + (Get-Date -UFormat "%Y-%m-%d_%I-%M-%S_%p").tostring() + ".zip"

        Write-Host "Downloading strategies shared by community..." -ForegroundColor Green

        $filePath = "$FolderPathForSQXFiles\" + $fileName
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/stahir80td/TD-MFG-Strategies/zipball/" -Method Get -Headers @{"Authorization" = "Bearer $accessToken"} -Verbose -OutFile "$filePath"

        Write-Host "Strategies have been downloaded to this path: $filePath. As more strategies are uploaded by community, you should see more content in this zip file" -ForegroundColor Green
    }
    else
    {
        Write-Host "If you upload 10 or more strategies, you will get access to strategies uploaded by rest of the community" -ForegroundColor Green
    }
}

function Get-EarningsDate($Symbol)
{
    $ProgressPreference = 'SilentlyContinue'
    $response = Invoke-WebRequest -Uri "https://finance.yahoo.com/calendar/earnings?symbol=$($Symbol)"
    $split = "aria-label=""Earnings Date""><span>"
    
    $dateStart = ($response.Content -split $split)[1]
    $earningDate = ($dateStart -split "</span")[0]
    #$earningDate
    [datetime] $dt = $earningDate

    $dateStartPrevious = ($response.Content -split $split)[2]
    $earningDatePrevious = ($dateStartPrevious -split "</span")[0]
    [datetime] $dtPrevious = $earningDatePrevious

    $ts = New-TimeSpan -Start $(Get-Date) -End $dtPrevious
    [int]$days = $ts.Days

    if($days -gt 0)
    {
        return $dtPrevious
    }

    return $dt
}


function Set-WindowsTaskForEarnings()
{
    #region LogParameters
    $command = $MyInvocation.InvocationName
        
    $PSBoundParameters.GetEnumerator().ForEach({
            $command += " -$($_.Key)" + " $($_.Value)"
        })
  
    try{
        "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
    }
    catch
    {
        
    }
    #endregion LogParameters

    $scheduleObject = New-Object -ComObject schedule.service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder("\")
    try{$rootFolder.CreateFolder("MFG") } catch{}

    ipmo ScheduledTasks

    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-WindowStyle Hidden Check-Earnings"

    $time = Get-Random -Minimum 1 -Maximum 11

    $trigger = New-ScheduledTaskTrigger -Daily -At "9am"

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "CheckEarnings" -Description "Check Earnings" -User "System" -Verbose -TaskPath '\MFG\' | Start-ScheduledTask
}

function Set-EarningsAlert(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]
    $Symbol
)
{

    BEGIN {
        #region LogParameters
        $command = $MyInvocation.InvocationName
        
        $PSBoundParameters.GetEnumerator().ForEach({
                $command += " -$($_.Key)" + " $($_.Value)"
            })
  
        try{
            "$(Get-Date -Format "MM/dd/yyyy HH:mm") $command" | Add-Content "$PSScriptRoot\History.txt"
        }
        catch
        {
                    
        }
        #endregion LogParameters
    }
	PROCESS
	{
            $commandFile = "$PSScriptRoot\Earnings.txt"
            $fileContent = ""

            if(Test-Path "$commandFile")
            {
                $fileContent = gc "$commandFile"
            }
            else
            {
                New-Item "$commandFile"
            }

            if($fileContent -eq "")
            {
                $fileContent = $Symbol
            }
            else
            {
                $fileContent += ",$($Symbol)"
            }
    }
    END {
        Set-Content -Path "$PSScriptRoot\Earnings.txt" -Value "$fileContent"
        Set-WindowsTaskForEarnings
    }
    
}

function Check-Earnings()
{
    $commandFile = "$PSScriptRoot\Earnings.txt"
    $fileContent = ""

    if(Test-Path "$commandFile")
    {
        $fileContent = gc "$commandFile"
    }
    else
    {
        return
    }

    $symbols = $fileContent -split ","

    foreach($symbol in $symbols)
    {
        try{
            $dt = Get-EarningsDate -Symbol $symbol
            
            if($dt -ne $null)
            {
                $ts = New-TimeSpan -Start $(Get-Date) -End $dt
                [int]$days = $ts.Days

                if($days -gt 0 -and $days -le 7)
                {
                    $message = "$symbol earning is in $days days. Expected ER: $dt"
                    Write-Warning $message
                    Test-SMS -Subject "$message"
                }
                else
                {
                    Write-Host "$symbol earning is in $days days. Expected ER: $dt"
                }
            }

        }
        catch
        {
        
        }
    }

}

New-Alias -Name Mine -Value TD-MFG-InitializeWorkflow
New-Alias -Name Mine-M30 -Value TD-MFG-InitializeWorkflow-M30
New-Alias -Name Mine-D1 -Value TD-MFG-InitializeWorkflow-D1

New-Alias -Name Mine-Common TD-MFG-InitializeWorkflow-CommonTimeframes

Export-ModuleMember -Function Set-EarningsAlert,Check-Earnings,Get-EarningsDate,SQ-Delete-Symbol,Share-Strategies-With-Community,Test-SMS,Get-ProviderExtension,TradingPlatform-Update,Check-TradingPlatforms,QA-Fix-Date-Format,Copy-Mined-Results-From-Incubation,Collect-Strategies-For-Incubation-Review,TD-MFG-Incubation-Workflow,Validate-Strategy,SQ-Export-Projects,SQ-Import-Symbols,Daily-Update,TD-MFG-Test-Workflow,Clear-Databanks,Get-MFG-Configuration,Set-MFG-Configuration,TD-MFG-InitializeWorkflow,Restore-Databanks,TD-MFG-InitializeWorkflow-M30,TD-MFG-InitializeWorkflow-D1,TD-MFG-InitializeWorkflow-CommonTimeframes,SQ-List-Symbols,SQ-Generate-Workflow-Command -Alias *