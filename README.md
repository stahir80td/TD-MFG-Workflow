# TD-MFG-Workflow
## _Generate and customize your Strategy Quant Workflows_

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

## Features

With TD-MFG-Workflow Modules you can

- Create consistent Strategy Quant Worklows
- Customize Strategy Quant Worklow to mine different timeframes, symbols, correlated markets, sessions, planned capital & drawdown adjustments etc.
- Thin wrapper on Strategy Quant CLI to perform tasks like importing your Trade Station Symbols and data

## Installation

Step 1) Download Setup.MininingForGold.msi
```sh
 https://www.dropbox.com/s/ihgb1rjrtlwq2hn/Setup.MiningForGold.msi?dl=0
```
Step 2) Right click Setup.MininingForGold.msi -> Properties -> Unblock the msi file

Step 3) Install with serial number: 1111111-1171111

Step 4) Open a new Powershell ISE window as Administrator and run this command
```sh
 mine -Upgrade
```
Step 5) Setup your Trade Station Directory
```sh
Set-MFG-Configuration -TradeStationDataPath "[Update this path where you keep Trade Station CSV files]"
```
Step 6) Optionally you might want to run this command if powershell execution is blocked on your machine. Run this is as Admin in Powershell ISE
```sh
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

## Future Upgrades

```sh
mine -Upgrade #To manually update when you want
```
```sh
Daily-Update #This sets up a windows scheduled task on your machine to download latest powershell modules daily
```

## Verify Installation

On a windows machine type Powershell ISE in Search, it will display "Windows Powershell ISE" - right click to "Run as Administrator"

Now, any time you want to create a new MFG/SQ workflow for a stock/instrument, simply open "Windows Powershell ISE" as Administrator and run following command 

```sh
TD-MFG-InitializeWorkflow
```

## Usage Examples
```sh
TD-MFG-InitializeWorkflow -InstrumentToMine AAPL -Correlated_1 FB -Correlated_2 TSLA -InitialCapital 25000 -Drawdown 5000 -MaxStrategies 1500
```
Explanation:

- InstrumentToMine: This parameter represents the stock/instrument you want to mine. [Default value for this parameter is set to AAPL]
- Correlated_1: This stock/instrument symbol is used to cross-check correlation [Default value for this parameter is set to FB]
- Correlated_2: This stock/instrument symbol is used to cross-check correlation [Default value for this parameter is set to GOOG]
- InitialCapital: Planned capital to run this strategy [Default value for this parameter is set to 25000]
- Drawdown: This is max drawdown used to filter strategies [Default value for this parameter is set to 5000]
- MaxStrategies: This is max number of strategies you want to build [Default value for this parameter is set to 1500]


```sh
TD-MFG-InitializeWorkflow -InstrumentToMine GS -Correlated_1 JPM -Correlated_2 MS -InitialCapital 10000 -Drawdown 2000 -MaxStrategies 1000
```
Explanation: You would like to mine GS and run correlation on JPM and MS. The max strategies you want to generate are 1000. You want to set your initial capital to 10,000 with a max drawdown of 2,000

```sh
TD-MFG-InitializeWorkflow -InstrumentToMine NFLX
```
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
