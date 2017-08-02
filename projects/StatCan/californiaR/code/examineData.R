
examineData <- function(DF.input) {

    require(ggplot2);
    require(dplyr);
    require(reshape2)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("str(DF.input)")
    print( str(DF.input) )

    print("head(DF.input)")
    print( head(DF.input) )

    print("DF.input %>% group_by(ocean_proximity) %>% summarise(n = n())")
    print( DF.input %>% group_by(ocean_proximity) %>% summarise(n = n()) )

    print("summary(DF.input)")
    print( summary(DF.input) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    melted.DF.input <- melt(
        data = DF.input[,setdiff(colnames(DF.input),"ocean_proximity")]
        );

    print('str(melted.DF.input)');
    print( str(melted.DF.input) );
    print('head(melted.DF.input)');
    print( head(melted.DF.input) );

    my.ggplot <- ggplot(data = NULL);
    my.ggplot <- my.ggplot + geom_histogram(data = melted.DF.input, mapping = aes(x = value), bins = 50); 
    my.ggplot <- my.ggplot + facet_wrap(~variable,scales = "free_x");

    FILE.ggplot <- "plot-histograms.png";
    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 600, height = 8, width = 12, units = 'in');

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(NULL);

    }
