
n_years       = 3.0;
interest_rate = 0.05;
amount        = 1000.0;

accrued_value = amount * (1 + interest_rate)**(n_years);

outputString = "\nStarting with an initial deposit of %.2f Euros, with an annual interest rate of %.2f%%, one obtains %.2f Euros after %.2f years.\n" % (amount,100*interest_rate,accrued_value,n_years)
print(outputString);

