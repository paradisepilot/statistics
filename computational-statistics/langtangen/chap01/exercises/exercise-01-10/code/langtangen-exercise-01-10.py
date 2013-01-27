
from math import pi, exp, sqrt;

x = 1.0;
m = 0.0;
s = 2.0;

result = (1/sqrt(2*pi)) * (1/s) * exp(-(1/2.0)*((x-m)/s)**2);

outputString = "f(%.2f) = %.5f." % (x,result);
print(outputString);

