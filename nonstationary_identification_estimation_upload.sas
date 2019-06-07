* ADF test;
*REFRIGERATOR SALES DATA, NONSTATIONARY;  
data one;
input week sales @@;
datalines;
1 390 2 323 3 371 4 326 5 358 6 538 7 533 8 458 9 414 10 489 11 306 12 654 13 458
14 507 15 362 16 367 17 306 18 223 19 281 20 317 21 238 22 286 23 306 24 307 25 275 26 284
27 298 28 318 29 340 30 497 31 349 32 380 33 379 34 526 35 272 36 401 37 553 38 527 39 485
40 722 41 474 42 510 43 760 44 515 45 560 46 751 47 842 48 818 49 746 50 672 51 854 52 692
;
data two;set one;
salesdif=dif(sales);
proc gplot data=one;
symbol v=dot i=join c=green;
plot sales*week;
Title 'Sales vs Week - Refrigerator Sales data';
run;
proc gplot data=two;
symbol v=dot i=join c=green;
plot salesdif*week/vref=0;
Title 'Salesdif vs week - First diff. Refrigerator Sales data';
run;
proc arima data=one;
identify var=sales nlag=12 stationarity=(adf);
identify var=sales(1) nlag=12 stationarity=(adf);
run;
proc arima data=one;
identify var=sales;
estimate p=1;
estimate p=2;
run;



* Case 5;
DATA CASE5;
DO YEAR=1965 TO 1978;
   DO QUARTER=1 TO 4;
      DATE=YYQ(YEAR,QUARTER);ONE=1;
      INPUT VOLUME @@; OUTPUT;
   END;
END;
LABEL VOLUME=VOLUME ;
KEEP DATE VOLUME ONE; FORMAT DATE YYQ4.;
CARDS;
166.8 172.8 178.3 180.3 182.6 184.2 188.9 184.4 181.7 178.5
177.6 181.0 186.5 185.7 186.4 186.3 189.3 190.6 191.7 196.1
189.3 192.6 192.1 189.4 189.7 191.9 182   175.7 192   192.8
193.3 200.2 208.8 211.4 214.4 216.3 221.8 217.1 214   202.4
191.7 183.9 185.2 194.5 195.8 198   200.9 199   200.6 209.5
208.4 206.7 193.3 197.3 213.7 225.1
;
PROC PRINT;RUN;
proc gplot data=case5;
symbol v=dot i=join c=green;
plot volume*date;
Title 'Rail freight vs date';
run;
PROC ARIMA data=CASE5;
IDENTIFY VAR=VOLUME stationarity=(adf);
estimate p=1 method=ML;
estimate p=1 q=1 method=ML; * ARMA(1,1);
forecast lead = 100;
RUN;
PROC ARIMA data=CASE5;
IDENTIFY VAR=VOLUME stationarity=(adf) minic esacf scan;
RUN;
PROC ARIMA data=CASE5;
IDENTIFY VAR=VOLUME(1) stationarity=(adf) minic esacf scan;
estimate p=1; * ARIMA (0,1,1) or IMA(1,1);
estimate p=1 noconstant;
forecast lead = 100;
RUN;



* ATT stock price;
DATA CASE6;
DO WEEK=1 TO 52;
   YEAR=1979;
   ONE=1;
   INPUT PRICE @@; OUTPUT;
END;
TITLE 'WEEKLY STOCK PRICE OF AT & T';
CARDS;
61 61.625 61 64 63.75 63.375 63.875 61.875 61.5 61.625 62.125 61.625
61 61.875 61.625 59.625 58.75 58.75 58.25
58.5 57.75 57.125 57.75 58.875 58 57.875 58 57.125 57.25 57.375
57.125 57.5 58.375 58.125 56.625 56.25 56.25 55.125 55 55.125
53 52.375 52.875 53.5 53.375 53.375 53.5 53.75 54 53.125
51.875 52.25
;
proc print;run;
proc gplot data=case6;
symbol v=dot i=join c=green;
plot price*week;
Title 'ATT stock price vs week';
run;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE stationarity=(adf);
ESTIMATE P=1 METHOD=ML;
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE(1) stationarity=(adf);
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE(1) stationarity=(adf);
ESTIMATE Q=2;
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE(1) stationarity=(adf);
ESTIMATE Q=(2);
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE(1) stationarity=(adf);
ESTIMATE Q=(2) noconstant;
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE(1) stationarity=(adf) minic;
ESTIMATE;
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE esacf scan minic;
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE(1) stationarity=(adf) minic;
ESTIMATE;
FORECAST LEAD=10;
RUN;
PROC ARIMA data=CASE6;
IDENTIFY VAR=PRICE(1) stationarity=(adf) minic;
ESTIMATE;
FORECAST LEAD=100;
RUN;







