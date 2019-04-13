
getPopulation <- function(
    seed            = 1234567,
    N               = 10000,
    alpha0          = 0.25,
    population.flag = "01"
    ) {

    set.seed(seed);

    DF.output <- data.frame(
        ID = seq( 1,N),
        y  = rep(NA,N),
        x1 = rep(NA,N),
        x2 = rep(NA,N),
        w  = rep(NA,N),
        propensity = rep(NA,N)
        );

    if (        "01" == population.flag) {
        DF.output <- getPopulation.01(N = N, alpha0 = alpha0);
    } else  if ("02" == population.flag) {
        DF.output <- getPopulation.02(N = N, alpha0 = alpha0);
    } else  if ("03" == population.flag) {
        DF.output <- getPopulation.03(N = N, alpha0 = alpha0);
    }

    return(DF.output);

    }

##################################################
getPopulation.01.00 <- function(
    N      = 10000,
    alpha0 = 0.25
    ) {

    require(e1071);

    z1 <- rnorm(n = N);
    z2 <- rnorm(n = N);

    sigma <- 0.25;
    x1    <- exp(sigma * z1);
    x2    <- exp(sigma * z2);

    b0 <-   11;
    b1 <-   13;
    b2 <- - 17;

    epsilon <- rnorm(n = N, mean = 0, sd = 2.0)
    y       <- b0 + b1 * x1 + b2 * x2 + epsilon;

    w <- 10 * (x1 - x2);
    propensity <- e1071::sigmoid(w);
    propensity <- alpha0 + (1 - alpha0) * propensity;

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

my.transform <- function(x) {

    if ( x[1] >= x[2] ) {

        return( x ); 

    } else {

        theta <- pi / 4;
        R_minus_theta <- matrix(
            data  = c(cos(-theta),-sin(-theta),sin(-theta),cos(-theta)),
            nrow  = 2,
            byrow = TRUE
            );

        M <- matrix(
            data = c(1,0,0,1/8),
            nrow  = 2,
            byrow = TRUE
            );

        R_theta <- matrix(
            data  = c(cos(theta),-sin(theta),sin(theta),cos(theta)),
            nrow  = 2,
            byrow = TRUE
            );

        w    <- x;
        w    <- M %*% R_minus_theta %*% w;
        w[2] <- (0.3) * sqrt(w[2]);
        w    <- R_theta %*% w;

        return( c(w[1],w[2]) );
    
        }

    }

getPopulation.01 <- function(
    N      = 10000,
    alpha0 = 0.25
    ) {

    require(e1071);

    z1 <- rnorm(n = N);
    z2 <- rnorm(n = N);

    sigma <- 0.25;
    x1    <- exp(sigma * z1);
    x2    <- exp(sigma * z2);

    X <- rbind(x1,x2);
    X <- apply(X = X, MARGIN = 2, FUN = my.transform);

    x1 <- X[1,];
    x2 <- X[2,];

    b0 <-   11;
    b1 <-   13;
    b2 <- - 17;

    epsilon <- rnorm(n = N, mean = 0, sd = 2.0)
    y       <- b0 + b1 * x1 + b2 * x2 + epsilon;

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

getPopulation.02 <- function(
    N      = 10000,
    alpha0 = 0.25
    ) {

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
    propensity <- alpha0 + (1 - alpha0) * propensity;

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

getPopulation.03 <- function(
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

