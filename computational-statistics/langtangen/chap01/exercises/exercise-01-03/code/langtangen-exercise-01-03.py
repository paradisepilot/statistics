
timeSecs   = 1e+9;
nSecInYear = 365.25 * 24 * 60 * 60;
timeYears  = timeSecs / nSecInYear;

outputString = "\nOne billion seconds equls %.2f years.\n" % (timeYears)
print(outputString);

