
myLength_meter = 640;

inch_2_cm     = 2.54;
foot_2_inches = 12.0;
yard_2_feet   = 3.0;
mile_2_yards  = 1760;

myLength_inches = myLength_meter * 100.0 / inch_2_cm;
myLength_feet   = myLength_inches / foot_2_inches;
myLength_yards  = myLength_feet / yard_2_feet;
myLength_miles  = myLength_yards / mile_2_yards;

outputString = "\n%.2f meters equals %.2f inches.\n" % (myLength_meter, myLength_inches);
print(outputString);

outputString = "\n%.2f meters equals %.2f feet.\n" % (myLength_meter, myLength_feet);
print(outputString);

outputString = "\n%.2f meters equals %.2f yards.\n" % (myLength_meter, myLength_yards);
print(outputString);

outputString = "\n%.2f meters equals %.4f miles.\n" % (myLength_meter, myLength_miles);
print(outputString);

