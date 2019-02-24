
visualizeSimulations <- function(
    DF.input         = NULL,
    textsize.title   = 30,
    textsize.axis    = 20,
    vline_xintercept = NULL
    ) {

    require(ggplot2);

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    FILE.output <- 'plot-simulations-Y-total.png'

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
        title    = "Estimated Population Total of Y",
        subtitle = "(non-probability sample, tree-based propensity estimation)"
        );

    #my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    #my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,3),breaks=seq(0,3,0.5));
    #my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,3),breaks=seq(0,3,0.5));

    #my.ggplot <- my.ggplot + scale_colour_gradient(breaks = c(0,0.25,0.5,0.75,1));

    my.ggplot <- my.ggplot + geom_histogram(
        data     = DF.input,
        mapping  = aes(x = Y_total_hat),
        alpha    = 0.5,
        binwidth = 1000
        );

    my.ggplot <- my.ggplot + geom_vline(xintercept = vline_xintercept,colour="orange",size=1.00);

    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =   8,
        width  =  12,
        units  = 'in'
        );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    return(NULL);
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    FILE.output <- 'plot-np-phat-propensity.png'

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
        legend.position  = "bottom"
        );

    my.ggplot <- my.ggplot + labs(
        title    = "P_hat vs Propensity",
        subtitle = "(non-probability sample)"
        );

    my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,1),breaks=seq(0,1,0.2));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,1),breaks=seq(0,1,0.2));

    #my.ggplot <- my.ggplot + scale_colour_gradient(breaks = c(0,0.25,0.5,0.75,1));

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.input,
        mapping = aes(x = propensity, y = p_hat),
        alpha   = 0.2
        );

    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =   8,
        width  =   8,
        units  = 'in'
        );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    return(NULL);

    }

