* AR1 ;
* simulate data;
data simu;
z=0;
z1=0;
phi1=0.5;
do i=1 to 140;
	noise=rannor(12345);
	z=phi1*z1+noise;
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
run;
* simulate data with nonzero level;
data simu;
z=10;
z1=10;
u=10;
phi1=0.5;
do i=1 to 140;
	noise=rannor(12345);
	z=u+phi1*(z1-u)+noise;
	z1=z;
	t=i-40;
	if t>0 then output;
end;
proc arima;
	identify var=z;
	estimate p=1;
run;







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
ESTIMATE P=1 plot;
FORECAST lead=5;
RUN;
* ods html close;



* AR2;
data simu;
z=0;
z_tm1=0;
z_tm2=0;
phi1=1.0;
phi2=-0.25;
do i=1 to 140;
	noise=rannor(12345);
	z=phi1*z_tm1+phi2*z_tm2+noise;
	z_tm2=z_tm1;
	z_tm1=z;
	t=i-40;
	if t>0 then output;
end;
proc print;
run;
proc gplot;
	symbol1 color=blue interpol=join value=dot height=1;
	plot z*t/href=0;
run;
proc arima;
	identify var=z;
run;





* MA1;
* simulate data;

* ods html;
data simu_ma1;
z=0;
theta1=-0.5;
do i=1 to 140;
	noise=rannor(12345);
	z=noise-theta1*lag(noise);
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


* real data;
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




* MA2;
data simu_ma2;
z=0;
theta1=-1.1;
theta2=0.24;
do i=1 to 140; * try 1000 instead of 140 to make the ACF PACF more obvious;
	noise=rannor(12345);
	z=noise-theta1*lag(noise)-theta2*lag2(noise);
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
