
from math import pi;

h = 5.0;  # height
b = 2.0;  # base
r = 1.5;  # radius

area_parallelogram = b * h;
outputString = "The area of the parallelogram is %.3f." % (area_parallelogram);
print(outputString);

area_square = b**2;
outputString = "The area of the square is %g." % (area_square);
print(outputString);

area_circle = pi * (r**2);
outputString = "The area of the circle is %.3f." % (area_circle);
print(outputString);

volume_cone = pi * (r**2) * h / 3.0;
outputString = "The volume of the cone is %.3f." % (volume_cone);
print(outputString);

