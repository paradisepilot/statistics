
test.fda <- function(
    seed = 1234567
    ) {

    require(fda);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    set.seed(seed);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(daily):\n");
    print( str(daily)    );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    rangeval <- c(0,365);
    period   <- 365;
    nbasis   <- 365;
    nharm    <- 300; #150;

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    daybasis <- create.fourier.basis(
        rangeval = rangeval,
        nbasis   = nbasis,
        period   = period
        );

    cat("\nstr(daybasis)\n");
    print( str(daybasis)   );

    harmaccelLfd <- vec2Lfd(
        bwtvec   = c(0,(2*pi/365)^2,0),
        rangeval = rangeval
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    daytime  <- (1:365) - 0.5;
    tempav   <- daily[["tempav"]];
    precav   <- daily[["precav"]];
    station  <- daily[["place"]];

    lambda   <- 100  #  minimum GCV estimate, corresponding to 255 df
    fdParobj <- fdPar(
        fdobj  = daybasis,
        Lfdobj = harmaccelLfd,
        lambda = lambda
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    smoothlist <- smooth.basis(
        argvals  = daytime,
        y        = tempav,
        fdParobj = fdParobj
        );

    cat("\nstr(smoothlist)\n");
    print( str(smoothlist)   );

    DF.temp <- smoothlist[["fd"]][["coefs"]] - smoothlist[["y2cMap"]] %*% smoothlist[["y"]];
    cat("\nstr(DF.temp):\n");
    print( str(DF.temp)    );
    #cat("\nsummary(DF.temp):\n");
    #print( summary(DF.temp)    );
    cat("\nmax(abs(DF.temp)):\n");
    print( max(abs(DF.temp))    );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    tempfdPar <- fdPar(
        fdobj  = smoothlist[['fd']],
        Lfdobj = harmaccelLfd,
        lambda = 1e2
        );

    harmfdPar <- fdPar(
        fdobj  = smoothlist[["fd"]],
        Lfdobj = harmaccelLfd,
        lambda = 1e5
        );

    daytemppcaobj <- pca.fd(
        fdobj     = tempfdPar[["fd"]],
        nharm     = nharm,
        harmfdPar = harmfdPar
        );

    #daytemppcaobj <- varmx.pca.fd(pcafd = daytemppcaobj);
    cat("\nstr(daytemppcaobj):\n");
    print( str(daytemppcaobj)    );

    my.checks <- daytemppcaobj[["harmonics"]][["coefs"]] %*% t(daytemppcaobj[["scores"]]);
    my.checks <- apply(
        X      = my.checks,
        MARGIN = 2,
        FUN    = function(x) { return(x + daytemppcaobj[["meanfd"]][["coefs"]]) }
        );
    cat("\nstr(my.checks)\n");
    print( str(my.checks)   );

    my.00 <- eval.fd(
        evalarg = daytime,
        fdobj   = daytemppcaobj[["meanfd"]]
        );
    cat("\nstr(my.00)\n");
    print( str(my.00)   );

    my.01 <- eval.fd(
        evalarg = daytime,
        fdobj   = daytemppcaobj[["harmonics"]]
        );
    my.01 <- my.01 %*% t(daytemppcaobj[["scores"]]);
    cat("\nstr(my.01)\n");
    print( str(my.01)   );

    my.02 <- apply(
        X      = my.01,
        MARGIN = 2,
        FUN    = function(x) { return(x + my.00) }
        );
    cat("\nstr(my.02)\n");
    print( str(my.02)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(daily):\n");
    print( str(daily)    );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for ( j in 1:ncol(my.02) ) {
        temp.file <- paste0("plot-",j,".png");
        png(filename = temp.file, height = 6, width = 12, units = "in", res = 300);
        plot(  x = daytime, y = daily[["tempav"]][,j], type = "l", col = "black" );
        lines( x = daytime, y = my.02[,j],             type = "l", col = "red"   );
        dev.off();
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.inprod <- inprod(
        fdobj1 = smoothlist[["fd"]],
        fdobj2 = daytemppcaobj[["harmonics"]]
        );

    cat("\nstr(results.inprod):\n");
    print( str(results.inprod)    );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }

##### ##### ##### ##### ##### ##### ##### #####

