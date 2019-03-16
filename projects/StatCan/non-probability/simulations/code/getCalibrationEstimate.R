
getCalibrationEstimate <- function(
    DF.input          = NULL,
    population.totals = NULL
    ) {

    require(survey);

    #cat("\nstr(DF.input)\n");
    #print( str(DF.input)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- DF.input;
    DF.temp[,"population.size"] <- as.numeric(population.totals["(Intercept)"]);

    my.design.SRS <- svydesign(
        data = DF.temp,
        ids  = ~1,
        fpc  = ~population.size
        );

    #cat("\nstr(my.design.SRS)\n");
    #print( str(my.design.SRS)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    calibrated.SRS <- calibrate(
        design     = my.design.SRS,
        formula    = ~ x1 + x2,
        population = population.totals
        );

    #cat("\nstr(calibrated.SRS)\n");
    #print( str(calibrated.SRS)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    calibration.estimate <- svytotal(
        x      = ~ y + x1 + x2,
        design = calibrated.SRS
        );

    #cat("\nstr(calibration.estimate)\n");
    #print( str(calibration.estimate)   );

    #cat("\ncalibration.estimate\n");
    #print( calibration.estimate   );

    #cat("\ncalibration.estimate['y']\n");
    #print( calibration.estimate['y']   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( as.numeric(calibration.estimate['y']) );

    }

