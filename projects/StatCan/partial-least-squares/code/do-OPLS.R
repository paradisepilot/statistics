
do.OPLS <- function(
    DF.input = NULL
    ) {

    thisFunctionName <- "do.OPLS";

    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n# ",thisFunctionName,"() starts.\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    require(geigen);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X <- as.matrix(t(DF.input[,c('x1','x2')]));
    Y <- as.matrix(t(DF.input[,c('y')]));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X.Yt.Y.Xt <- X %*% t(Y) %*% Y %*% t(X);
    X.Xt      <- X %*% t(X);

    cat("\nX.Yt.Y.Xt\n");
    print( X.Yt.Y.Xt   );

    cat("\ndet(X.Yt.Y.Xt)\n");
    print( det(X.Yt.Y.Xt)   );

    cat("\nX.Xt\n");
    print( X.Xt   );

    cat("\ndet(X.Xt)\n");
    print( det(X.Xt)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.geigen <- geigen::geigen(
        A           = X.Yt.Y.Xt,
        B           = X.Xt,
        symmetric   = TRUE,
        only.values = FALSE
        );

    cat("\nresults.geigen\n");
    print( results.geigen   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.geigen.values  <- results.geigen[['values']];

    results.geigen.vectors <- results.geigen[['vectors']];
    results.geigen.vectors <- apply(
        X      = results.geigen.vectors,
        MARGIN = 2,
        FUN    = function(x) { return( x / sqrt(sum(x*x)) ) }
        );

    cat("\nresults.geigen.vectors\n");
    print( results.geigen.vectors   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for ( i in 1:length(results.geigen.values) ) {

        cat("\n##### i =",i,"\n")

        cat("\nX.Yt.Y.Xt %*% results.geigen.vectors[,i]\n");
        print( X.Yt.Y.Xt %*% results.geigen.vectors[,i]   );

        cat("\nX.Xt %*% results.geigen.vectors[,i]\n");
        print( X.Xt %*% results.geigen.vectors[,i]   );

        cat("\nX.Yt.Y.Xt %*% results.geigen.vectors[,i] - results.geigen.values[i] * X.Xt %*% results.geigen.vectors[,i]\n");
        print( X.Yt.Y.Xt %*% results.geigen.vectors[,i] - results.geigen.values[i] * X.Xt %*% results.geigen.vectors[,i]   );

        cat("\n");

        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n# ",thisFunctionName,"() exits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( results.geigen );

    }
