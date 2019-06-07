DATA CASE9;
     DO YEAR=69 TO 78;
     DO MONTH=1 TO 12;
     DATE=MDY(MONTH,1,YEAR); ONE=1;
     INPUT VOLUME @@;  OUTPUT; END; END;
KEEP DATE VOLUME ONE; FORMAT DATE MONYY5.;
LABEL VOLUME=VOLUME ;
CARDS;
1299 1148 1345 1363 1374 1533 1592 1687 1384 1388 1295 1489 1403
1243 1466 1434 1520 1689 1763 1834 1494 1439 1327 1554 1405 1252
1424 1517 1483 1605 1775 1840 1573 1617 1485 1710 1563 1439 1669
1651 1654 1847 1931 2034 1705 1725 1687 1842 1696 1534 1814 1796
1822 2008 2088 2230 1843 1848 1736 1826 1766 1636 1921 1882 1910
2034 2047 2195 1765 1818 1634 1818 1698 1520 1820 1689 1775 1968
2110 2241 1803 1899 1762 1901 1839 1727 1954 1991 1988 2146 2301
2338 1947 1990 1832 2066 1952 1747 2098 2057 2060 2240 2425 2515
2128 2255 2116 2315 2143 1948 1460 2344 2363 2630 2811 2972 2515
2536 2414 2545
Proc means data=case9 noprint;  var VOLUME; 
 output out=VOL mean=mean;
data mean; set VOL;
 ONE=1;keep mean one;
data case;merge case9 mean;by one;
drop one;

symbol1 color=blue
interpol=join
value=dot
height=1;
symbol2 font=marker value=c
interpol=box
color=red
height=0.2;
legend1 label=none
position=(top center inside)
mode=share;

proc gplot data=case;
plot volume*date mean*date /
overlay legend=legend1;
title "Air-Carrier Freight";
run;  

* log transformation;
Data log; set case9; n+1;
lx=log(volume);one=1;
dlx=dif(lx); keep lx one dlx date;run;
proc means data=log noprint; var lx;
output out=vol2 mean=lmean;
data lmean; set vol2;one=1; keep one lmean;
data trans; merge log lmean; by one; drop one;
data trans2; set trans; m+1; if m>110 then delete; run;
proc gplot data=trans;
plot lx*date lmean*date/overlay legend=legend1; 
Title "Log Transformed Data for Air-Carrier Freight(1969-1978)";
run;

*PROC ARIMA data=case; 
*IDENTIFY VAR=volume minic scan esacf nlag=30 stationarity=(adf); 
*RUN;
*PROC ARIMA data=case; IDENTIFY VAR=volume(1) nlag=30; Estimate q=1 Plot;
*Title 'MA(1)Model for Air-Carrier Freight(1969-1978) with differential data';
*RUN;
PROC ARIMA data=Trans;
IDENTIFY VAR=Lx minic scan esacf nlag=30 stationarity=(adf);
RUN;
PROC ARIMA data=Trans;
IDENTIFY VAR=Lx(1) nlag=30 stationarity=(adf=(1,2,3) dlag=12);
RUN;
PROC ARIMA data=Trans;
IDENTIFY VAR=Lx(1,12) nlag=30; 
RUN;
PROC ARIMA data=Trans;
IDENTIFY VAR=Lx(1,12) nlag=30; 
Estimate q=(1);
RUN;
PROC ARIMA data=Trans;
IDENTIFY VAR=Lx(1,12) nlag=30; 
Estimate q=(1)(12);
RUN;
PROC ARIMA data=Trans;
IDENTIFY VAR=Lx(1,12) nlag=30; 
Estimate q=(1)(12) noconstant;
RUN;

PROC ARIMA data=Trans;
IDENTIFY VAR=Lx(1,12) nlag=30; 
Estimate q=(1)(12) noconstant;
FORECAST OUT=FORECAST1 LEAD=20;
Title 'MA(1)(12) Model for Air-Carrier Freight(1969-1978) with differential log-transfered data';
RUN;
PROC ARIMA data=Trans;
IDENTIFY VAR=Lx(1,12) nlag=30; 
Estimate q=(1)(12) noconstant;
FORECAST OUT=FORECAST1 BACK=20 LEAD=40;
Title 'MA(1)(12) Model for Air-Carrier Freight(1969-1978) with differential log-transfered data';
RUN;

PROC ARIMA data=Trans2;
IDENTIFY VAR=Lx(1,12) nlag=30; 
Estimate q=(1)(12) noconstant Plot;
FORECAST OUT=FORECAST1 back=20 LEAD=40;
Title 'MA(1)(12) Model without outliers';
RUN;
PROC ARIMA data=Trans2; 
IDENTIFY VAR=Lx(1,12) nlag=30; 
Estimate q=(1,2)(12) noconstant Plot;
FORECAST OUT=FORECAST1 back=20 LEAD=60;
Title 'MA(2)(12) Model without outliers';
RUN;










DATA CASE10;
DO YEAR=53 TO 72;
   DO QTR=1 TO 4;
     DATE=YYQ(YEAR,QTR);
         one=1;
      INPUT PROFIT @@; OUTPUT;
   END;
 END;
KEEP DATE PROFIT one; FORMAT DATE YYQ4.;
CARDS;
4.4 4.3 4.4 4 4.3 4.6 4.5 4.7 5.2 5.4 5.5 5.6 5.4 5.4 5 5.1 5.3 4.9
4.7 4.3 3.6 3.7 4.4 4.8 5 5.3 4.6 4.4 5 4.4 4.3 3.9 3.8 4.2 4.4 4.7
4.6 4.4 4.5 4.7 4.4 4.7 4.7 5 5.1 5.2 5.3 5.3 5.6 5.5 5.6 5.6 5.8 5.7
5.6 5.4 5 5 4.9 5.1 5.1 5 5.1 5.1 5.1 4.9 4.8 4.5 4.1 4.2 4 3.6 4
4.2 4.2 4.1 4.2 4.2 4.3 4.5
;
 proc means noprint;
 var profit;
 output out=AA mean=mean;
 data Mean; set AA;
 one=1; keep mean one;
 data case; merge case10 mean; by one;
 drop one;
 proc print; run;


symbol1 color=blue
        interpol=join
        value=dot
        height=1;
symbol2 font=marker value=c
        interpol=box
        color=red
        height=0.2;
legend1 label=none
        position=(top center inside)
        mode=share;
proc gplot data=case;
   plot profit*DATE mean*DATE /
        overlay legend=legend1;
Title 'Profit Margin';
run;



PROC ARIMA DATA=CASE;
IDENTIFY VAR=profit MINIC SCAN ESACF stationarity=(adf);
RUN;

PROC ARIMA DATA=CASE;
IDENTIFY VAR=profit;
ESTIMATE P=1;
RUN;

PROC ARIMA DATA=CASE;
IDENTIFY VAR=profit(1);
RUN;

PROC ARIMA DATA=CASE;
IDENTIFY VAR=profit(1);
ESTIMATE Q=(4 8);
RUN;

PROC ARIMA DATA=CASE;
IDENTIFY VAR=profit;
ESTIMATE P=1 Q=(4 8);
RUN;

PROC ARIMA DATA=CASE;
IDENTIFY VAR=profit(1);
ESTIMATE Q=(4 8);
FORECAST OUT=FORECAST1 LEAD=20;
RUN;

PROC ARIMA DATA=CASE;
IDENTIFY VAR=profit(1);
ESTIMATE Q=(4 8);
FORECAST OUT=FORECAST1 back=5 LEAD=20;
RUN;












DATA CASE13;
     DO YEAR=69 TO 76;
        DO MONTH=1 TO 12;
           DATE=MDY(MONTH,1,YEAR);
		   one=1;
           	INPUT CIGAR @@; 
			OUTPUT; 
		END; 
END;
KEEP DATE CIGAR one; FORMAT DATE MONYY5.;
TITLE 'Cigar Consumption (1969--1976)';
CARDS;
484 498 537 552 597 576 544 621 604 719 599 414 502 494 527 544 631 557 540 588 593 653 582 495 
510 506 557 559 571 564 497 552 559 597 616 418 452 460 541 460 592 475 442 563 482 562 520 346 
466 403 465 485 507 483 403 506 442 576 480 339 418 380 405 452 403 379 399 464 443 533 416 314 
351 354 372 394 397 417 347 371 389 448 349 286 317 288 364 337 342 377 315 356 354 388 340 264 
;
PROC PRINT;RUN;
proc gplot;
	symbol1 color=blue interpol=join value=dot height=1;
	plot cigar*date;                 
run;
