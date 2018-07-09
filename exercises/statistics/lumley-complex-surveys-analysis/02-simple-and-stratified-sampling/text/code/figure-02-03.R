
figure.02.03 <- function() {
    
    require(survey);
    
    cat("\n\n#######################################");
    cat("\nfigure.02.03() starts ...\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    data(api);
    
    cat("\nstr(apisrs)\n");
    print( str(apisrs) );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    design_SRS_noFPC <- svydesign(id = ~1, weights = ~pw, data = apisrs);

    cat("\ndesign_SRS_noFPC\n");
    print( design_SRS_noFPC );
    cat("\nstr(design_SRS_noFPC)\n");
    print( str(design_SRS_noFPC) );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.svytotal <- svytotal(x = ~enroll, design = design_SRS_noFPC);
    cat("\nresults.svytotal\n");
    print( results.svytotal );
    
    results.svymean <- svymean(x = ~enroll, design = design_SRS_noFPC);
    cat("\nresults.svymean\n");
    print( results.svymean );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### figure.02.03() quits ...");
    cat("\n#######################################\n");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }