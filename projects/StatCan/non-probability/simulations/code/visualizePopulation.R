
visualizePopulation <- function(
    population     = NULL,
    textsize.title = 30,
    textsize.axis  = 20
    ) {

    require(ggplot2);

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    FILE.output <- 'plot-population-propensity.png'

    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        axis.title.x     = element_blank(),
        axis.title.y     = element_blank(),
        axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
        axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
        );

    my.ggplot <- my.ggplot + labs(
        title    = "Self-selection Propensity",
        subtitle = "(population)"
        );

    #my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    #my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    #my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
    #my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

    my.ggplot <- my.ggplot + geom_density(
        data    = population,
        mapping = aes(x = propensity)
        );

    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =   8,
        width  =  12,
        units  = 'in'
        );
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    FILE.output <- 'plot-population-predictors.png'

    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        legend.text      = element_text(size = textsize.axis,  face = "bold"),
        axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
        axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
        axis.title.x     = element_blank(),
        axis.title.y     = element_blank(),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25),
        legend.position  = "bottom",
        legend.key.width = ggplot2::unit(0.75,"in")
        );

    my.ggplot <- my.ggplot + labs(
        title    = "Predictors",
        subtitle = "(population)"
        );

    my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,3),breaks=seq(0,3,0.5));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,3),breaks=seq(0,3,0.5));

    my.ggplot <- my.ggplot + scale_colour_gradient(breaks = c(0,0.25,0.5,0.75,1));

    my.ggplot <- my.ggplot + geom_point(
        data    = population,
        mapping = aes(x = x1, y = x2, colour = propensity),
        alpha   = 0.2
        );

    my.ggplot <- my.ggplot + geom_abline(slope=1, intercept=0, colour="gray", size=0.75);

    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =   9,
        width  =   8,
        units  = 'in'
        );

 
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    return(NULL);

    }

