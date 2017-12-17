
plot.results.rpart <- function(results.rpart,palette.iris) {

    require(rpart.plot);
    require(RColorBrewer);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #FILE.ggplot <- "plot-rpart.png";
    #png(filename = FILE.ggplot, height = 8, width = 12, units = "in", res = 300);
    #
    #rpart.plot(
    #    x           = results.rpart,
    #    box.palette = as.list(palette.iris),
    #    cex         = 2
    #    );
    #
    #dev.off();
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "plot-rpart.png";
    png(filename = FILE.ggplot, height = 12, width = 8, units = "in", res = 300);
    
    prp(
        x           = results.rpart,
        extra       = 2,
        cex         = 3.5,
        legend.cex  = 3.5,
        box.palette = as.list(palette.iris)
        );
    
    dev.off();
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );
    
    }
