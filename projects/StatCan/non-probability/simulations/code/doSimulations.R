
doSimulations <- function(
    FILE.results   = "results-simulations.csv",
    n.iterations   = 10,
    DF.population  = NULL,
    prob.selection = 0.1
    ) {

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
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
        Y_total_hat_naive       = as.numeric(rep(NA,n.iterations)),
        Y_total_hat_CLW         = as.numeric(rep(NA,n.iterations)),
        cor_propensity_tree     = as.numeric(rep(NA,n.iterations)),
        cor_propensity_CLW      = as.numeric(rep(NA,n.iterations)),
        cor_response_CLW        = as.numeric(rep(NA,n.iterations))
        );

    Y_total <- sum(DF.population[,"y"]);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    Y_total_hat_propensity  <- NA;
    Y_total_hat_tree        <- NA;
    Y_total_hat_calibration <- NA;
    Y_total_hat_naive       <- NA;
    Y_total_hat_CLW         <- NA;

    cor_propensity_tree <- NA;
    cor_propensity_CLW  <- NA;
    cor_response_CLW    <- NA;

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for (i in seq(1,n.iterations)) {

        cat(paste0("\n### iteration: ",i,"\n"));

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        LIST.samples <- getSamples(
            DF.population  = DF.population,
            prob.selection = 0.1
            );

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        pnpTree <- pnpCART$new(
            predictors = c("x1","x2"),
            np.data    = LIST.samples[['non.probability.sample']],
            p.data     = LIST.samples[['probability.sample']],
            weight     = "weight"
            );
        pnpTree$grow();

        #print( str(pnpTree) );

        pnpTree$print(
            FUN.format = function(x) {return( round(x,digits=3) )} 
            );

        DF.npdata_with_propensity <- pnpTree$get_npdata_with_propensity();
        colnames(DF.npdata_with_propensity) <- gsub(
            x           = colnames(DF.npdata_with_propensity),
            pattern     = "propensity",
            replacement = "p_hat"
            );
        DF.npdata_with_propensity <- merge(
            x  = DF.npdata_with_propensity,
            y  = DF.population[,c("ID","propensity")],
            by = "ID"
            );
        DF.npdata_with_propensity <- DF.npdata_with_propensity[order(DF.npdata_with_propensity[,"ID"]),];

        Y_total_hat_tree <- sum(
            DF.npdata_with_propensity[,"y"] / DF.npdata_with_propensity[,"p_hat"]
            );

        cor_propensity_tree <- cor(
            x = DF.npdata_with_propensity[,"p_hat"],
            y = DF.npdata_with_propensity[,"propensity"]
            );

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        DF.temp <- merge(
            x  = LIST.samples[['non.probability.sample']][,c("ID","y")],
            y  = DF.population[,c("ID","propensity")],
            by = "ID"
            );

        Y_total_hat_propensity <- sum( DF.temp[,"y"] / DF.temp[,"propensity"] );

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        Y_total_hat_calibration <- getCalibrationEstimate(
            DF.input          = LIST.samples[['non.probability.sample']],
            population.totals = population.totals
            );

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        naive.factor      <- nrow(DF.population) / nrow(LIST.samples[['non.probability.sample']]);
        Y_total_hat_naive <- naive.factor * sum(LIST.samples[['non.probability.sample']][,"y"]);

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        results.CLW <- getChenLiWuEstimate(
            LIST.input = LIST.samples,
            formula    = y ~ x1 + x2,
            weight     = "weight",
            population = DF.population
            );

        Y_total_hat_CLW    <- results.CLW[["estimate"]];
        cor_propensity_CLW <- results.CLW[["cor.propensity"]];
        cor_response_CLW   <- results.CLW[["cor.response"]];

        ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
        DF.results[i,] <- c(
            i,
            Y_total,
            Y_total_hat_propensity,
            Y_total_hat_tree,
            Y_total_hat_calibration,
            Y_total_hat_naive,
            Y_total_hat_CLW,
            cor_propensity_tree,
            cor_propensity_CLW,
            cor_response_CLW
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

