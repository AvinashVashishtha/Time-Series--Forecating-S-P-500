* real data;
DATA CASE1;
DO YEAR=1955 TO 1969;
   DO QUARTER=1 TO 4;
      INPUT INVEN @@;
      DATE=YYQ(YEAR,QUARTER);
     one=1;
     OUTPUT;
   END;
END;
keep inven date one;
FORMAT DATE YYQ4.;
Title 'QUARTERLY CHANGE IN BUSNIESS INVENTORIES';
CARDS;
4.4 5.8 6.7 7.1 5.7 4.1 4.6 4.3 2.0 2.2 3.6 -2.2 -5.1 -4.9 .1 4.1 3.8
9.9 0 6.5 10.8 4.1 2.7 -2.9 -2.9 1.5 5.7 5 7.9 6.8 7.1 4.1 5.5 5.1 8
5.6 4.5 6.1 6.7 6.1 10.6 8.6 11.6 7.6 10.9 14.6 14.5 17.4 11.7 5.8
11.5 11.7 5 10 8.9 7.1 8.3 10.2 13.3 6.2
;
Proc means noprint ;
 var inven; 
 output out=AA mean=mean;
data Mean; set AA;
 one=1;keep mean one;

data case;merge case1 mean;by one;
drop one;
proc print;run;
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
   plot inven*date mean*date /
        overlay legend=legend1;                  
run;
* ods html body='trend.htm';
PROC ARIMA; 
IDENTIFY VAR=INVEN minic scan esacf;       
*ESTIMATE P=1 METHOD=ML;
*ESTIMATE P=1 METHOD=CLS;
ESTIMATE P=1 METHOD=ULS;
*ESTIMATE Q=1 METHOD=ULS;
FORECAST lead=50 INTERVAL=QUARTER ID=DATA OUT=RESULTS;
RUN;
* ods html close;
PROC PRINT DATA=RESULTS;
RUN;








DATA CASE3;
DO YEAR=1952 TO 1959;
   DO MONTH=1 TO 12;
     DATE=MDY(MONTH,1,YEAR);
     INPUT COAL @@; OUTPUT;
   END;
END;
title 'MONTHLY BITUMINOUS COAL PRODUCTION';
KEEP DATE COAL; FORMAT DATE MONYY5.;
CARDS;
47730 46704 41535 41319 36962 32558 31995 32993 44834 29883 39611
40099 38051 36927 37272 39457 38097 40226 43589 39088 39409 37226
34421 34975 32710 31885 32106 30029 29501 31620 34205 32153 32764
33230 35636 35550 34529 37498 37229 36021 38281 36676 44541 40850
38404 37575 41476 42267 43062 45036 43769 42298 44412 40498 37830
42294 38330 43554 42579 36911 42541 42430 43465 44468 43597 40774
42573 41635 39030 41572 37027 34732 36817 34295 33218 32034 31417
35719 30001 33096 35196 36550 33463 37195 34748 36461 35754 36943
35854 37912 30095 28931 31020 31746 34613 37901
;
PROC PRINT;
proc gplot data=CASE3;
symbol v=dot i=join c=red;
plot coal*date;
title 'coal Vs date';
run;
PROC ARIMA;
IDENTIFY VAR=COAL minic scan esacf;
estimate p=2 plot;
run;
PROC ARIMA; 
IDENTIFY VAR=COAL minic scan esacf;
estimate p=2 q=(3)plot;     /* ARMA(2,3)*/
run;
PROC ARIMA; 
IDENTIFY VAR=COAL minic scan esacf;
estimate p=2 q=3 plot;     /* ARMA(2,3)*/
run;
  
PROC ARIMA; 
IDENTIFY VAR=COAL minic scan esacf;
estimate p=2 q=(3) method=ml plot;     /* ARMA(2,3)*/
forecast lead=10; *1000;
run;

PROC ARIMA; 
IDENTIFY VAR=COAL minic scan esacf;
estimate p=1 method=ml plot;     /* ARMA(2,3)*/
run;

* simulate a MA(3);
* MA1;
* simulate data;

* ods html;
data simu_ma1;
z=0;
theta3=-0.5;
do i=1 to 1040;
	noise=rannor(12345);
	z=noise-theta3*lag3(noise);
	t=i-40;
	if t>0 then output;
end;
proc print;
run;
proc gplot data=simu_ma1;
	symbol1 color=blue interpol=join value=dot height=1;
	plot z*t/href=0;
run;
proc arima;
	identify var=z;
run;





DATA CASE4;
TIME=0;
DO YEAR=1947 TO 1967;
	DO QUARTER=1 TO 4;
		INPUT PERMITS @@;
		DATE=YYQ(YEAR,QUARTER);
		TIME=TIME+1;
     OUTPUT;
   END;
END;
keep PERMITS DATE one TIME;
FORMAT DATE YYQ4.;
Title 'Housing permits issued';
CARDS;
83.3 83.2 105.3 117.7 104.6 108.8 93.9 86.1 83 102.4 119.6 141.4 158.6 161.3 158.2 136.1 121.9 97.7 103.3 92.7 106.8 102.1 110.3 114.1 109.1 
105.4  97.6 100.7 102.7 110.9 120.2 131.3 138.9 130.9 123.1 110.8 108.8 103.8 97 93.2 89.7 89.9 90.2 89.6 85.8 96.9 112.7 122.7 119.8 117.4 
111.9 104.7 98.3 94.9 93.3 90.9 91.9 97.2 104.7 107.7 108.2 110.7 113.1 114.6 112.2 120.2 122.1 126.6 122.3 115.9 116.9 110.1 110.4 108.9 
112.1 117.6 112.2 96 78 66.9 83.5 95.8 107.7 113.7
;
proc print;
run;
proc gplot;
	symbol1 color=blue interpol=join value=dot height=1;
	plot PERMITS*DATE;
run;
proc arima;
	identify var=PERMITS;
run;





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
identify var=sales nlag=12 stationarity=(adf=(1) dlag=4);
*identify var=sales(1) nlag=12 stationarity=(adf=(1) );
*estimate q=1 method=cls plot noconstant;
run;
