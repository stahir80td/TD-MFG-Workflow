sqcli.exe -symbol action=add symbols=EURUSD,GBPUSD datasource=dukascopy datatype=TICK
sqcli.exe -instrument action=edit instrument=EURUSD datatype=forex
sqcli.exe -instrument action=add instrument=EURUSD
sqcli.exe -data action=import symbol=EURUSD instrument=EURUSD filepath=C:/data/EURUSD.csv

 sqcli.exe -run file=C:/data/commands.txt
  sqcli.exe -exit

  http://localhost:5051/call?cmd=-h
  sqcli.exe -project action=start name=Builder


  #---------------------------

  -symbol action=add symbols=LABU_1H datasource=File instrument="Standard stock"
  -symbol action=add symbols=LABU_30M datasource=File instrument="Standard stock"
  -symbol action=add symbols=UPRO_1H datasource=File instrument="Standard stock"
  -symbol action=add symbols=UPRO_30M datasource=File instrument="Standard stock"
  -symbol action=add symbols=AVGO_1H datasource=File instrument="Standard stock"
  -symbol action=add symbols=AVGO_30M datasource=File instrument="Standard stock"
  -symbol action=add symbols=UAL_1H datasource=File instrument="Standard stock"
  -symbol action=add symbols=UALsc_30M datasource=File instrument="Standard stock"

