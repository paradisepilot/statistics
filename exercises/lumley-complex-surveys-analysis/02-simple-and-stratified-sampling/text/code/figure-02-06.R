
figure.02.06 <- function(data.directory) {
    
    require(haven);
    require(survey);
    
    cat("\n\n#######################################");
    cat("\n### figure.02.06() starts ...\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.CHIS.adults <- getData.CHIS.adult(data.directory);

    cat("\n### str(DF.CHIS.adults)\n");
    print( str(DF.CHIS.adults) );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- unique(apistrat[,c("stype","fpc","pw")]);
    DF.temp[,"fpc_by_pw"] <- DF.temp[,"fpc"] / DF.temp[,"pw"];
    
    cat("\n### unique(apistrat[,c('stype','fpc','pw')])\n");
    print( DF.temp );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    designStrat <- svydesign(
        data   = apistrat,
        strata = ~stype,
        fpc    = ~fpc,
        id     = ~1
        );

    cat("\n### designStrat\n");
    print( designStrat );
    
    cat("\n### str(designStrat)\n");
    print( str(designStrat) );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.temp <- svytotal(design = designStrat, x = ~enroll);
    
    cat("\n### svytotal(design = designStrat, x = ~enroll)\n");
    print( results.temp );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.temp <- svymean(design = designStrat, x = ~enroll);
    
    cat("\n### svymean(design = designStrat, x = ~enroll)\n");
    print( results.temp );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.temp <- svytotal(design = designStrat, x = ~stype);
    
    cat("\n### svytotal(design = designStrat, x = ~stype)\n");
    print( results.temp );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### figure.02.06() quits ...");
    cat("\n#######################################\n");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }