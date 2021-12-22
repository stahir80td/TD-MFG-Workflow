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
```sh
Step 5) Set-MFG-Configuration -TradeStationDataPath "[Update this path where you keep Trade Station CSV files]"
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
