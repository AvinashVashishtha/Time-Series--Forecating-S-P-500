
/*******************************************Project*****************************************************/
proc import datafile="/folders/myfolders/GASUE34_data/table.csv"
     out=sp500csv
     dbms=csv
     replace;
     getnames=yes;
run;
proc print data=sp500csv;run;
proc sgplot data=sp500csv;
    series x=Date y=Adj_Close;
	/*symbol1 color=blue interpol=join value=dot height=1;
	plot Adj_Close*Date/href=0;*/
run;

Proc print Data=sp500csv(obs=100);
run;

Proc contents Data=sp500csv;
run;


Data sp500csv_filter;
set sp500csv;
WHERE Date between '01Jan2001'd and '30Jun2001'd;
run;

Proc print Data=sp500csv_filter;
run;

proc sgplot data=sp500csv_filter;
   series x=DATE y=	Adj_Close;
run;

PROC ARIMA data=sp500csv_filter;
IDENTIFY VAR=Adj_Close(1) stationarity=(adf);
RUN;


PROC ARIMA data=sp500csv_filter;
IDENTIFY VAR=Adj_Close(1) minic scan esacf;
RUN;


PROC ARIMA data=sp500csv_filter;
IDENTIFY VAR=Adj_Close(1);
estimate q=(13);
RUN;


PROC ARIMA data=sp500csv_filter; 
IDENTIFY VAR=Adj_Close(1) minic scan esacf;       
ESTIMATE q=(13) plot;
FORECAST lead=30;
RUN;
* ods html close;
