function y = activity2rate(x,a)
% equation(1) in paper.

y0=0.1; ymax=1.5;
a = 1;
y=zeros(size(x));
id= x<=0;
y(id)= y0+y0* tanh(a*x(id)/y0);
y(~id)= y0+(ymax-y0)*tanh(a*x(~id)/(ymax-y0));