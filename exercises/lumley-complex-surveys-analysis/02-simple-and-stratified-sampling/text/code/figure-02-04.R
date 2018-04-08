
figure.02.04 <- function() {
    
    require(survey);
    
    cat("\n\n#######################################");
    cat("\nfigure.02.04() starts ...\n");

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
    results.svymean <- svymean(x = ~api00+api99, design = designSRS);
    cat("\nresults.svymean\n");
    print( results.svymean );
    
    results.svycontrast <- svycontrast(
        stat     = results.svymean,
        contrast = c(api00 = 1, api99 = -1)
        );
    cat("\nresults.svycontrast\n");
    print( results.svycontrast );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    updated_design <- update(
        object  = designSRS,
        apidiff = api00 - api99
        );

    updated_design <- update(
        object = updated_design,
        apipct = apidiff / api99
        );
    
    results.svymean <- svymean(
        x      = ~ apidiff + apipct,
        design = updated_design
        );
    
    cat("\nresults.svymean\n");
    print( results.svymean );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### figure.02.04() quits ...");
    cat("\n#######################################\n");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }