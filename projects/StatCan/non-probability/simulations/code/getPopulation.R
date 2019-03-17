
getPopulation <- function(N = 10000) {

    require(e1071);

    z1 <- rnorm(n = N);
    z2 <- rnorm(n = N);

    sigma <- 0.25;
    x1    <- exp(sigma * z1);
    x2    <- exp(sigma * z2);

    b0 <-   11;
    b1 <-   13;
    b2 <- - 17;
    epsilon <- rnorm(n = N, mean = 0, sd = 5.0)
    y       <- b0 + b1 * x1 + b2 * x2 + epsilon^2; 

    w <- 10 * (x1 - x2);
    propensity <- e1071::sigmoid(w);

    DF.output <- data.frame(
        ID = seq(1,N),
        y  = y,
        x1 = x1,
        x2 = x2,
        w  = w,
        propensity = propensity
        );

    return(DF.output);

    }

