
getPopulation <- function(
    N      = 10000,
    alpha0 = 0.25
    ) {

    require(e1071);

    temp.centres <- c(0.5,1.5,2.5);

    c1 <- sample(x = temp.centres, size = N, replace = TRUE);
    c2 <- sample(x = temp.centres, size = N, replace = TRUE);

    is.high.propensity <- (c2 - c1 == 1 | c2 - c1 == -1);

    sigma <- 0.20;
    x1    <- c1 + rnorm(n = N, mean = 0, sd = sigma);
    x2    <- c2 + rnorm(n = N, mean = 0, sd = sigma);

    propensity <- rnorm(n = N, mean = 0.25, sd = 0.025);
    propensity[is.high.propensity] <- rnorm(n = sum(is.high.propensity), mean = 0.75, sd = 0.025);

    y0 <- rep(x = 30, times = N);
    y0[is.high.propensity] <- 110;

    epsilon <- rnorm(n = N, mean = 0, sd = 1.0)
    y       <- y0 + epsilon^2; 

    DF.output <- data.frame(
        ID = seq(1,N),
        y  = y,
        x1 = x1,
        x2 = x2,
        propensity = propensity
        );

    return(DF.output);

    }

