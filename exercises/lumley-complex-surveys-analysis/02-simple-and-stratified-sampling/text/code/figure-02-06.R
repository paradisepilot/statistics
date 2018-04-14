
figure.02.06 <- function() {
    
    require(survey);
    
    cat("\n\n#######################################");
    cat("\n### figure.02.06() starts ...\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    data(api);
    
    cat("\n### str(apistrat)\n");
    print(     str(apistrat)   );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- unique(apistrat[,c("stype","fpc","pw")]);
    DF.temp[,"fpc_by_pw"] <- DF.temp[,"fpc"] / DF.temp[,"pw"];
    
    cat("\n### unique(apistrat[,c('stype','fpc','pw')])\n");
    print( DF.temp );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    design.Strat <- svydesign(
        data   = apistrat,
        strata = ~stype,
        fpc    = ~fpc,
        id     = ~1
        );

    cat("\n### design.Strat\n");
    print( design.Strat );
    
    cat("\n### str(design.Strat)\n");
    print(     str(design.Strat)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    design.Bootstrap <- as.svrepdesign(
        design     = design.Strat,
        type       = "bootstrap",
        replicates = 100
        );
    
    cat("### design.Bootstrap\n");
    print(   design.Bootstrap   );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    design.Jackknife <- as.svrepdesign(design = design.Strat);
    
    cat("### design.Jackknife\n");
    print(   design.Jackknife   );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.temp <- svymean(design = design.Bootstrap, x = ~enroll);
    
    cat("\n### svymean(design = design.Bootstrap, x = ~enroll)\n");
    print( results.temp );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.temp <- svymean(design = design.Jackknife, x = ~enroll);
    
    cat("\n### svymean(design = design.Jackknife, x = ~enroll)\n");
    print( results.temp );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### figure.02.06() quits ...");
    cat("\n#######################################\n");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }