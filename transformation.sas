* AR(1) structure with nonstationary variance;
* simulate data;
data simu;
phi1=0.75;
z=1;
z1=0;
noise=0;
do i=1 to 340;
	mu=0.1*i;
	noise=mu*rannor(123456);
	z=mu+(phi1*z1+noise);
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
	estimate p=1 plot method=ml;
	forecast lead=7 interval=day ID=t out=results;
run;
proc print data=results;
run;
proc gplot data=results;
	symbol1 color=blue interpol=join value=dot height=1;
	plot residual*t;
run;



