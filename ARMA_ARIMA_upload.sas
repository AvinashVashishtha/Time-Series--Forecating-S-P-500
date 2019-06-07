****************************
* ARMA ;
****************************


* ARMA(1,1) ;
* simulate data;
options LS=64;

data simu;
theta1=-0.5;
phi1=0.75;
z=0;
z1=0;
noise=0;
lnoise=0;
do i=1 to 140;
	z=phi1*z1+noise-theta1*lnoise;
	lnoise=noise;
	noise=rannor(12345);
	z1=z;
	t=i-40;
	if t>0 then output;
end;

proc print;
run;
proc gplot data=simu;
	symbol1 color=blue interpol=join value=dot height=1;
	plot z*t/href=0;
run;
proc arima;
	identify var=z;
run;
proc arima;
	identify var=z;
	estimate p=1 noconstant;
	estimate q=1 noconstant;
	estimate p=1 q=1 noconstant;
run;




* real data case 1 for AR(1);
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
ESTIMATE P=1 plot;
FORECAST lead=5;
RUN;
* ods html close;





****************************
* ARIMA ;
****************************;

* Random Walk Zt=Z_(t-1) + noise;
* test for unit root;
data simu;
z=27;
z1=29;
do i=1 to 400;
noise=1.9*rannor(54609);
z=z1+noise;
z1=z;
t=i-140;
if t > 140 then output;
end;
data new; set simu; keep t z;
proc arima;
	*identify var=z stationarity=(adf=(1) );
	*estimate p=1 plot;
	identify var=z(1) nlag=24 stationarity=(adf=(1) );
	estimate plot;
	forecast out=fore;
run;
%dftest(simu,z,ar=0,dif=(1),dlag=1,out=new1);
proc print data=new1;
title 'ADF test for random walk';
run;
proc print data=fore;run;






* simulate data for ARIMA(0,1,1) or IMA(1,1) ;
data simu;
theta1=-0.5;
phi1=1;
z=0;
z1=0;
noise=0;
lnoise=0;
do i=1 to 140;
	z=phi1*z1+noise-theta1*lnoise;
	lnoise=noise;
	noise=rannor(12345);
	z1=z;
	t=i-40;
	if t>0 then output;
end;
proc print;
run;
proc gplot data=simu;
	symbol1 color=blue interpol=join value=dot height=1;
	plot z*t/href=0;
run;
proc arima;
	identify var=z;
run;
proc arima;
	identify var=z;
	estimate p=1 noconstant;
	estimate q=1 noconstant;
	estimate p=1 q=1 noconstant;
run;



