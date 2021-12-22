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

```sh
Download Setup.MininingForGold.msi https://www.dropbox.com/s/ihgb1rjrtlwq2hn/Setup.MiningForGold.msi?dl=0
```
```sh
Right click Setup.MininingForGold.msi -> Properties -> Unblock the msi file
```
```sh
Install with serial number: 1111111-1171111
```
```sh
Open a new Powershell ISE window as Administrator and run this command mine -Upgrade
```
```sh
Set-MFG-Configuration -TradeStationDataPath "[Update this path where you keep Trade Station CSV files]"
```
```sh
Optionally you might want to run this command if powershell execution is blocked on your machine. Set-ExecutionPolicy -ExecutionPolicy Unrestricted # Run this as Admin in Powershell ISE
```

## Future Upgrades

```sh
mine -Upgrade #To manually update when you want
```
```sh
TD-MFG-InitializeWorkflow -InstrumentToMine AAPL -Correlated_1 FB -Correlated_2 TSLA -InitialCapital 25000 -Drawdown 5000 -MaxStrategies 1500
```

## Verify Installation

On a windows machine type Powershell ISE in Search, it will display "Windows Powershell ISE" - right click to "Run as Administrator"

Now, any time you want to create a new MFG/SQ workflow for a stock/instrument, simply open "Windows Powershell ISE" as Administrator and run following command 

```sh
TD-MFG-InitializeWorkflow
```
