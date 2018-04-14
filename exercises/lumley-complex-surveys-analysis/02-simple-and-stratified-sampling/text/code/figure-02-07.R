
figure.02.07 <- function() {
    
    require(survey);
    require(survival);

    cat("\n\n#######################################");
    cat("\n### figure.02.07() starts ...\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    data(nwtco);

    nwtco[,"edrel.in.years"] <- nwtco[,"edrel"] / 365.25;
        
    cat("\n### str(nwtco)\n");
    print(     str(nwtco)   );
    
    cat("\n### summary(nwtco)\n");
    print(     summary(nwtco)   );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cases    <- nwtco[nwtco[,"rel"] == 1,];
    controls <- nwtco[nwtco[,"rel"] == 0,];

    cases[,   "sampling.weight"] <-  1;
    controls[,"sampling.weight"] <- 10;
    
    my.sample <- rbind(
        cases,
        controls[sample(x=nrow(controls),size=325,replace=FALSE),]
        );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.sampling.design <- svydesign(
        data    = my.sample,
        id      = ~1,
        strata  = ~rel,
        weights = ~sampling.weight
        );

    design.Jackknife <- as.svrepdesign(my.sampling.design);
    
    design.Bootstrap <- as.svrepdesign(
        design     = my.sampling.design,
        type       = "bootstrap",
        replicates = 500
        );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.temp <- withReplicates(
        design = design.Bootstrap, # design.Jackknife,
        theta  = my.survival.estimate
        );

    cat("\n### str(results.withReplicates)\n");
    print(     str(results.temp)             );
    
    cat("\n### results.withReplicates\n");
    print(     results.temp             );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### figure.02.07() quits ...");
    cat("\n#######################################\n");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);
    
    }

#################################################
my.survival.estimate <- function(sampling.weight,data) {

    require(survival);

    my.survival.curve <- survfit(
        Surv(time = data[,"edrel.in.years"], event = data[,"rel"]) ~ 1,
        weights   = sampling.weight
        );

    #cat("\n### str(my.survival.curve)\n");
    #print(     str(my.survival.curve)   );

    return(
        my.survival.curve[["surv"]][min(which(my.survival.curve[["time"]] > 5))]
        );

    }
