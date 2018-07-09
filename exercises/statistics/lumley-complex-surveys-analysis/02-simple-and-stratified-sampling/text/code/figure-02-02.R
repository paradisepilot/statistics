
figure.02.02 <- function() {
    
    require(survey);
    
    cat("\n\n#######################################");
    cat("\nfigure.02.02() starts ...\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    data(api);
    
    cat("\nstr(apisrs)\n");
    print( str(apisrs) );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    designSRS <- svydesign(id = ~1, fpc = ~fpc, data = apisrs);

    cat("\ndesignSRS\n");
    print( designSRS );

    cat("\nstr(designSRS)\n");
    print( str(designSRS) );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.svytotal <- svytotal(x = ~enroll, design = designSRS);
    cat("\nresults.svytotal\n");
    print( results.svytotal );
    
    results.svymean <- svymean(x = ~enroll, design = designSRS);
    cat("\nresults.svymean\n");
    print( results.svymean );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### figure.02.02() quits ...");
    cat("\n#######################################");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }