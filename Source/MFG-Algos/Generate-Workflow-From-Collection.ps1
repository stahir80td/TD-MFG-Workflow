<# 

Generates multiple .cfx files based on the $Instruments collection below

Add your stock metadata to this collection. 
Collection values are in this order. Stock, Correlated_1, Correlated_2, FullDurationStartDate, BacktestTimeframe, AlternateTimeframe

#>

$Instruments = @(("AAPL","FB","TSLA","2000.11.23","H1", "M30"),
                ("V","GS","MS","2001.01.04","M30","H1"),
                ("TSLA","FB","AAPL","2002.01.01","D1","H4")
                );

<# Don't change anything after this line #>

Import-Module "$PSScriptRoot\MFGAlgos.psm1" -force -DisableNameChecking

foreach($Instrument in $Instruments)
{
    mine -InstrumentToMine $Instrument[0] -Correlated_1 $Instrument[1] -Correlated_2 $Instrument[2] `
         -FullDurationStartDate $Instrument[3] -BacktestTimeframe $Instrument[4] -AlternateTimeframe $Instrument[5]
}