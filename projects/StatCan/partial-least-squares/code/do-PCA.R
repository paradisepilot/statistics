
do.PCA <- function(
    DF.input = NULL
    ) {

    thisFunctionName <- "do.PCA";

    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n# ",thisFunctionName,"() starts.\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    require(geigen);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.prcomp <- stats::prcomp(
        formula = ~ x1 + x2,
        data    = DF.input
        );

    cat("\nresults.prcomp\n");
    print( results.prcomp   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # results.geigen.values  <- results.geigen[['values']];
    #
    # results.geigen.vectors <- results.geigen[['vectors']];
    # results.geigen.vectors <- apply(
    #     X      = results.geigen.vectors,
    #     MARGIN = 2,
    #     FUN    = function(x) { return( x / sqrt(sum(x*x)) ) }
    #     );
    #
    # cat("\nresults.geigen.vectors\n");
    # print( results.geigen.vectors   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # for ( i in 1:length(results.geigen.values) ) {
    #
    #     cat("\n##### i =",i,"\n")
    #
    #     cat("\nX.Yt.Y.Xt %*% results.geigen.vectors[,i]\n");
    #     print( X.Yt.Y.Xt %*% results.geigen.vectors[,i]   );
    #
    #     cat("\nX.Xt %*% results.geigen.vectors[,i]\n");
    #     print( X.Xt %*% results.geigen.vectors[,i]   );
    #
    #     cat("\nX.Yt.Y.Xt %*% results.geigen.vectors[,i] - results.geigen.values[i] * X.Xt %*% results.geigen.vectors[,i]\n");
    #     print( X.Yt.Y.Xt %*% results.geigen.vectors[,i] - results.geigen.values[i] * X.Xt %*% results.geigen.vectors[,i]   );
    #
    #     cat("\n");
    #
    #     }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n# ",thisFunctionName,"() exits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( results.prcomp );

    }
