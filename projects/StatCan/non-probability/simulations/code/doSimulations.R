
doSimulations <- function(
    FILE.results   = "results-simulations.csv",
    n.iterations   = 10,
    DF.population  = NULL,
    prob.selection = 0.1
    ) {

    population.totals <- c(
        "(Intercept)" = nrow(DF.population),
        x1            = sum(DF.population[,"x1"]),
        x2            = sum(DF.population[,"x2"])
        );

    DF.results <- data.frame(
        index                   = seq(1,n.iterations),
        Y_total                 = as.numeric(rep(NA,n.iterations)),
        Y_total_hat_propensity  = as.numeric(rep(NA,n.iterations)),
        Y_total_hat_tree        = as.numeric(rep(NA,n.iterations)),
        Y_total_hat_calibration = as.numeric(rep(NA,n.iterations)),
        correlation             = as.numeric(rep(NA,n.iterations))
        );

    Y_total <- sum(DF.population[,"y"]);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    Y_total_hat_propensity  <- NA;
    Y_total_hat_tree        <- NA;
    cor_phat_propensity     <- NA;
    Y_total_hat_calibration <- NA;

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for (i in seq(1,n.iterations)) {

        cat(paste0("\n### iteration: ",i,"\n"));

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        LIST.samples <- getSamples(
            DF.population  = DF.population,
            prob.selection = 0.1
            );

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        #pnpTree <- pnpCART$new(
        #    predictors = c("x1","x2"),
        #    np.data    = LIST.samples[['non.probability.sample']],
        #    p.data     = LIST.samples[['probability.sample']],
        #    weight     = "weight"
        #    );
        #pnpTree$grow();

        #print( str(pnpTree) );

        #pnpTree$print(
        #    FUN.format = function(x) {return( round(x,digits=3) )} 
        #    );

        #DF.npdata_with_propensity <- pnpTree$get_npdata_with_propensity();
        #colnames(DF.npdata_with_propensity) <- gsub(
        #    x           = colnames(DF.npdata_with_propensity),
        #    pattern     = "propensity",
        #    replacement = "p_hat"
        #    );
        #DF.npdata_with_propensity <- merge(
        #    x  = DF.npdata_with_propensity,
        #    y  = my.population[,c("ID","propensity")],
        #    by = "ID"
        #    );
        #DF.npdata_with_propensity <- DF.npdata_with_propensity[order(DF.npdata_with_propensity[,"ID"]),];

        #Y_total_hat_propensity <- sum(
        #    DF.npdata_with_propensity[,"y"] / DF.npdata_with_propensity[,"propensity"]
        #    );

        #Y_total_hat_tree <- sum(
        #    DF.npdata_with_propensity[,"y"] / DF.npdata_with_propensity[,"p_hat"]
        #    );

        #cor_phat_propensity <- cor(
        #    x = DF.npdata_with_propensity[,"p_hat"],
        #    y = DF.npdata_with_propensity[,"propensity"]
        #    );

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        Y_total_hat_calibration <- getCalibrationEstimate(
            DF.input          = LIST.samples[['non.probability.sample']],
            population.totals = population.totals
            );

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        DF.results[i,] <- c(
            i,
            Y_total,
            Y_total_hat_propensity,
            Y_total_hat_tree,
            Y_total_hat_calibration,
            cor_phat_propensity
            );

        write.csv(
            x         = DF.results,
            file      = FILE.results,
            row.names = FALSE
            );

        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(DF.results);

    }

