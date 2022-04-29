
function x = peakAnalysis(a,b,xlow,xhigh)
A=0;
Aa=0;
step=b(2)-b(1);
for i=round(xlow/step):round(xhigh/step)
    A=A+a(i+1);
    Aa=Aa+a(i+1)*i;
end

x=Aa/A*step;

end