function Upgrade-Module()
{
    Write-Host "`nDownloading latest package" -ForegroundColor Cyan

    Add-Type -AssemblyName System.Web
    Add-Type -AssemblyName System.Web.Extensions

    $url       = 'http://151.106.59.178/MFG-Algos'
    $destPath  = "$PSScriptRoot"

    md $destPath -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Tls11

    $WebResponse = Invoke-WebRequest -Uri $url
    $WebResponse.Links | Select-Object -ExpandProperty innerText -Skip 1 | ForEach-Object {
        
        Write-Host "Downloading file '$_'"
        $filePath = Join-Path -Path $destPath -ChildPath $_
        $fileUrl  = '{0}/{1}' -f $url.TrimEnd('/'), $_
        if(-NOT ($fileUrl -like "*web.config*")){
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $fileUrl -OutFile $filePath
        }
    }

}

function Restore-Databanks($Symbol="All", $workflowResultsFolder="C:\Algos\SQ\MFG-Results", $SQProjectsFolder="C:\StrategyQuantX\user\projects")
{

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

TD-MFG-InitializeWorkflow -InstrumentToMine MC -Correlated_1 V -Correlated_2 JPM -InitialCapital 25000 -Drawdown 5000 -MaxStrategies 1500 -InSampleStartDate "2014.5.1" -RecencyStartDate "2019.1.1" -RecencyEndDate "2021.12.5" -OutOfSampleStartDate "2018.1.1"

Explanation:

You would like to mine MC with V and JPM as correlated symbols. 25k Initial Captial and max drawdown of 5k.

The "In Sample" starts from 2014.5.1, the "In Sample" ends at 2019.1.1
The "Out of Sample" starts from 2018.1.1 and it ends at 2019.1.1
The "Recency" starts from 2019.1.1 and ends at 2021.21.5
The Full time span would be 2014.5.1. and 2121.12.5

Note: If you are providing dates as input parameters, make sure they fall in the date range imported for the instrument (from CSV).

--- Usage Example 5 ---

TD-MFG-InitializeWorkflow -InstrumentToMine MC -Correlated_1 V -Correlated_2 JPM -InitialCapital 25000 -Drawdown 5000 -MaxStrategies 1500 -InSampleStartDate "2014.5.1" -RecencyStartDate "2019.1.1" -RecencyEndDate "2021.12.5" -OutOfSampleStartDate "2018.1.1" -BacktestTimeframe M30 -AlternateTimeframe H1

Explanation:

You would like to mine MC with V and JPM as correlated symbols. 25k Initial Captial and max drawdown of 5k.

The "In Sample" starts from 2014.5.1, the "In Sample" ends at 2019.1.1
The "Out of Sample" starts from 2018.1.1 and it ends at 2019.1.1
The "Recency" starts from 2019.1.1 and ends at 2021.21.5
The Full time span would be 2014.5.1. and 2121.12.5

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

"@

    Write-Host $HelpContent -ForegroundColor Cyan


}


function Algo-CreateWorkspace($stock, $rootPath = "C:\Algos\SQ\MFG-Results", $BacktestTimeframe = "H1")
{
    Write-Host "Creating workspace..." -ForegroundColor Green
    
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

function TD-MFG-InitializeWorkflow(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]
    $InstrumentToMine = "AAPL", 
    $Correlated_1 = "FB", 
    $Correlated_2 = "AAPL", 
    $InitialCapital = "25000", 
    $Drawdown = "5000", 
    $MaxStrategies = "1500", 
    $SaveFileToPath = "C:\Algos\SQ\MFG-Results", 
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
    $AverageTrade = "95"
    )
{
    BEGIN {}
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
            Upgrade-Module
            Write-Host "`nPackage has been upgraded. Run following command" -ForegroundColor Green
            Write-Host "`nImport-Module '$($PSScriptRoot)\MFGAlgos.psm1' -force -DisableNameChecking" -ForegroundColor Cyan
            return
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

            $rootFolder = "$SaveFileToPath\$instrument"

            Algo-CreateWorkspace -stock $instrument -rootPath $SaveFileToPath -BacktestTimeframe "$BacktestTimeframe"

            copy-item -Path $config -Destination $rootFolder

            $newConfigFilePath = "$rootFolder\config.xml"

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

New-Alias -Name Mine -Value TD-MFG-InitializeWorkflow

Export-ModuleMember -Function TD-MFG-InitializeWorkflow,Restore-Databanks -Alias *