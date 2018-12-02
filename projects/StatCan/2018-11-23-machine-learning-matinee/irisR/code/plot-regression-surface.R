
plot.regression.surface <- function(results.rpart) {

    require(plotmo);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.graphics <- "plot-regression-surface.png";
    png(filename = FILE.graphics, height = 10, width = 8, units = "in", res = 300);
    
    plotmo(
        object    = results.rpart,
        #type2    = "prob",
        nresponse = "virginica",
        swapxy    = TRUE,
        do.par    = FALSE
        );

    dev.off();
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );
    
    }
