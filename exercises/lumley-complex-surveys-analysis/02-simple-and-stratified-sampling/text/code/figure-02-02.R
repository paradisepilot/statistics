
figure.02.02 <- function() {
    
    require(survey);
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    data(api);
    
    print("str(apisrs)");
    print( str(apisrs) );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    designSRS <- svydesign(id = ~1, fpc = ~fpc, data = apisrs);
    print("designSRS");
    print( designSRS );
    print("str(designSRS)");
    print( str(designSRS) );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.svytotal <- svytotal(x = ~enroll, design = designSRS);
    print("results.svytotal");
    print( results.svytotal );
    
    results.svymean <- svymean(x = ~enroll, design = designSRS);
    print("results.svymean");
    print( results.svymean );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }