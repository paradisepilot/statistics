
visualizeData <- function(DF.input) {

    require(ggplot2);
    require(GGally);
    require(dplyr);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "plot-scatter.png";

    my.ggplot <- ggplot(data = NULL);
    my.ggplot <- my.ggplot + geom_point(
        data    = DF.input,
        mapping = aes(
            x     = longitude,
            y     = latitude,
            size  = population / 100,
            color = median_house_value
            ),
        alpha = 0.2
        ); 

    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 300, height = 8, width = 11, units = 'in');

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "plot-correlations.png";

    my.ggplot <- ggpairs(
        data    = DF.input,
        columns = c("median_house_value","median_income","total_rooms","housing_median_age"),
        diag    = list(continuous = "barDiag", discrete = "barDiag",  na = "naDiag"),
        upper   = list(continuous = wrap("points",alpha=0.05), discrete = "facetbar", na = "na", combo = "facethist"),
        lower   = list(continuous = "cor",                     discrete = "facetbar", na = "na", combo = "box_no_facet")
        );

    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 300, height = 8, width = 11, units = 'in');

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "plot-correlations-02.png";

    DF.temp <- DF.input %>%
        mutate(roomsPerHousehold =    total_rooms / households  ) %>%
        mutate(  bedroomsPerRoom = total_bedrooms / total_rooms )

    my.ggplot <- ggpairs(
        data    = DF.temp,
        columns = c("median_house_value","median_income","roomsPerHousehold","bedroomsPerRoom"),
        diag    = list(continuous = "barDiag", discrete = "barDiag",  na = "naDiag"),
        upper   = list(continuous = wrap("points",alpha=0.05), discrete = "facetbar", na = "na", combo = "facethist"),
        lower   = list(continuous = "cor",                     discrete = "facetbar", na = "na", combo = "box_no_facet")
        );

    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 300, height = 8, width = 11, units = 'in');

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "plot-medianIncome.png";

    my.ggplot <- ggplot(data = NULL);
    my.ggplot <- my.ggplot + geom_point(
        data    = DF.input,
        mapping = aes(
            x     = median_income,
            y     = median_house_value
            ),
        alpha = 0.2
        ); 

    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 300, height = 8, width = 11, units = 'in');


    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }
