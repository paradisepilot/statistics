
figure.02.08 <- function(data.directory) {
    
    require(haven);
    require(survey);
    
    cat("\n\n#######################################");
    cat("\n### figure.02.08() starts ...\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.CHIS.adults <- getData.CHIS.adult(data.directory);

    cat("\n### str(DF.CHIS.adults)\n");
    print(     str(DF.CHIS.adults)   );
    
    cat("\n### colnames(DF.CHIS.adults)\n");
    print(     colnames(DF.CHIS.adults)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.rep.design <- svrepdesign(
        variables        = DF.CHIS.adults[,1:412],
        weights          = DF.CHIS.adults[,413],
        repweights       = DF.CHIS.adults[,414:493],
        combined.weights = TRUE,
        type             = "other",
        scale            = 1,
        rscales          = 1
        );
    
    cat("\n### str(my.rep.design)\n");
    print(     str(my.rep.design)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.temp <- svyquantile(
        x         = ~BMI_P,
        design    = my.rep.design,
        quantiles = c(0.25,0.50,0.75)
        );
    
    cat("\n### svyquantile(x=~BMI_P,design=my.rep.design,quantiles=c(0.25,0.50,0.75))\n");
    print( results.temp );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### figure.02.08() quits ...");
    cat("\n#######################################\n");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }