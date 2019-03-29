
getChenLiWuEstimate <- function(
    LIST.input = NULL,
    formula    = NULL,
    weight     = NULL,
    population = NULL
    ) {

    require(stats);

    #cat("\nstr(LIST.input)\n");
    #print( str(LIST.input)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    temp       <- all.vars(as.formula(formula));
    response   <- temp[1];
    predictors <- base::setdiff(temp,c(response));

    #cat("\nresponse\n");
    #print( response   );
    #cat("\npredictors\n");
    #print( predictors   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nonprob <- LIST.input[['non.probability.sample']];
    results.lm <- lm(
        formula = as.formula(formula),
        data    = LIST.input[['non.probability.sample']],
        );

    beta.hat <- coef(results.lm);

    #cat("\nresults.lm\n");
    #print( results.lm   );

    #cat("\nbeta.hat\n");
    #print( beta.hat   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X.nonprob <- as.matrix(cbind(
        intercept = rep(1,nrow(LIST.input[['non.probability.sample']])),
        LIST.input[['non.probability.sample']][,predictors]
        ));
    #cat("\nhead(X.nonprob)\n");
    #print( head(X.nonprob)   );

    X.prob <- as.matrix(cbind(
        intercept = rep(1,nrow(LIST.input[['probability.sample']])),
        LIST.input[['probability.sample']][,predictors]
        ));
    #cat("\nhead(X.prob)\n");
    #print( head(X.prob)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X.prob_beta.hat <- X.prob %*% beta.hat;
    #cat("\nstr(X.prob_beta.hat)\n");
    #print( str(X.prob_beta.hat)   );

    weights <- LIST.input[['probability.sample']][,weight];
    #cat("\nstr(weights)\n");
    #print( str(weights)   ); 

    T.prob  <- sum( weights * X.prob_beta.hat );
    #cat("\nT.prob\n");
    #print( T.prob   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    minus_logL <- function(theta) {

        #cat("\ntheta\n");
        #print( theta   );

        X.nonprob_theta   <- X.nonprob %*% theta;
        X.prob_theta      <- X.prob    %*% theta;
        exp.prob          <- exp( X.prob_theta );
        one_plus_exp.prob <- 1 + exp.prob;
        minus_logL.out    <- - sum(X.nonprob_theta) + sum( weights * log(one_plus_exp.prob) )

        Pi.prob         <- exp.prob / one_plus_exp.prob
        weights_Pi.prob <- weights * Pi.prob;

        #cat("\nsummary(weights_Pi.prob)\n");
        #print( summary(weights_Pi.prob)   );

        #cat("\nstr(colSums(X.nonprob))\n")
        #print( str(colSums(X.nonprob))   );

        temp          <- apply(X=X.prob,MARGIN=2,FUN=function(z){z * weights_Pi.prob});
        temp.gradient <- - colSums(X.nonprob) + colSums(temp);
        #cat("\ntemp.gradient\n");
        #print( temp.gradient );

        temp         <- weights_Pi.prob * (1 - Pi.prob);
        temp.Hessian <- t(X.prob) %*% apply(X=X.prob,MARGIN=2,FUN=function(z){z * temp});
        #cat("temp.Hessian");
        #print( temp.Hessian );

        new.theta <- theta - solve(temp.Hessian,temp.gradient);
        #cat("\nnew.theta\n");
        #print( new.theta   );

        attr(minus_logL.out,"gradient") <- temp.gradient;
        attr(minus_logL.out,"hessian" ) <- temp.Hessian;

        #cat("\n~~~~~~~~~~\n")
        return(minus_logL.out);

        }

    #cat("\n~~~~~~~~~~\n")
    theta0 <- rep(0,ncol(X.prob));
    results.nlm <- stats::nlm(
        f = minus_logL,
        p = theta0
        );
    #cat("\nresults.nlm\n");
    #print( results.nlm   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    theta.hat            <- results.nlm[["estimate"]];
    X.nonprob_theta.hat  <- X.nonprob %*% theta.hat;
    exp.nonprob          <- exp( X.nonprob_theta.hat );
    one_plus_exp.nonprob <- 1 + exp.nonprob;
    weights.nonprob      <- one_plus_exp.nonprob / exp.nonprob;

    X.nonprob_beta.hat <- X.nonprob %*% beta.hat;
    T.nonprob <- sum( weights.nonprob * (LIST.input[['non.probability.sample']][,response] - X.nonprob_beta.hat) );
    #cat("\nT.nonprob\n");
    #print( T.nonprob   );

    temp <- merge(
        x = LIST.input[['non.probability.sample']],
        y = population,
        by = "ID"
        );
    cor.propensity <- cor( temp[,"propensity"] , 1/weights.nonprob );
    #cat("\ncor.propensity\n");
    #print( cor.propensity   );

    cor.response <- cor( LIST.input[['non.probability.sample']][,response] , X.nonprob_beta.hat );
    #cat("\ncor.response\n");
    #print( cor.response   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    Y_total_hat_CLW <- T.nonprob + T.prob;
    #cat("\nY_total_hat_CLW\n");
    #print( Y_total_hat_CLW   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    LIST.output <- list(
        estimate       = Y_total_hat_CLW,
        cor.propensity = cor.propensity,
        cor.response   = cor.response
        );
    return( LIST.output );

    }

