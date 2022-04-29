%%
function y = FTPeakInt(a,f,x)
A=0;
step=f(2)-f(1);

xlow=x-0.05;
xhigh=x+0.05;

for i=round(xlow/step):round(xhigh/step)
    A=A+a(i+1);
end

y=A;

end
