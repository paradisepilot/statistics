
visualizePropensity <- function(
    population.flag = NULL,
    DF.input        = NULL,
    textsize.title  = 30,
    textsize.axis   = 20,
    scale_fill_gradient_limits = NULL,
    scale_fill_gradient_breaks = NULL
    ) {

    require(ggplot2);

    #DF.output <- data.frame(
    #    ID = seq(1,N),
    #    y  = y,
    #    x1 = x1,
    #    x2 = x2,
    #    w  = w,
    #    propensity = propensity
    #    );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    FILE.output <- paste0('np-propensity-scatter-',population.flag,'.png');

    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
        axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
        axis.title.x     = element_blank(),
        axis.title.y     = element_blank(),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25),
        legend.title     = element_text(size = textsize.axis,  face = "bold"),
        legend.text      = element_text(size = textsize.axis,  face = "bold"),
        legend.position  = "bottom",
        legend.key.width = ggplot2::unit(0.75,"in")
        );

    my.ggplot <- my.ggplot + labs(
        title    = NULL,
        subtitle = paste0("non-probability sample ",population.flag),
        colour   = "estimated propensity   "
        );

    my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,3),breaks=seq(0,3,0.5));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,3),breaks=seq(0,3,0.5));

    my.ggplot <- my.ggplot + scale_colour_gradient(
        limits = c(0,1),
        breaks = c(0,0.25,0.5,0.75,1),
        low    = "black",
        high   = "red"
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.input,
        mapping = aes(x = x1, y = x2, colour = p_hat),
        alpha   = 0.2
        );

    if (population.flag %in% c("01","03")) {
        my.ggplot <- my.ggplot + geom_abline(slope=1, intercept=0, colour="gray", size=0.75);
        }

    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =   9,
        width  =   8,
        units  = 'in'
        );

     # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    FILE.output <- paste0('np-propensity-estimated-vs-true-',population.flag,'.png');

    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        legend.text      = element_text(size = textsize.axis,  face = "bold"),
        axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
        axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
        axis.title.x     = element_text(size = textsize.axis,  face = "bold"),
        axis.title.y     = element_text(size = textsize.axis,  face = "bold"),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25),
        legend.position  = "bottom"
        );

    my.ggplot <- my.ggplot + labs(
        title    = NULL,
        subtitle = paste0("non-probability sample ",population.flag)
        );

    my.ggplot <- my.ggplot + xlab("true propensity");
    my.ggplot <- my.ggplot + ylab("tree-estimated propensity");

    my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,1),breaks=seq(0,1,0.2));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,1),breaks=seq(0,1,0.2));

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
    FILE.output <- paste0('np-propensity-estimated-vs-true-',population.flag,'-hex.png');

    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
        axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
        axis.title.x     = element_text(size = textsize.axis,  face = "bold"),
        axis.title.y     = element_text(size = textsize.axis,  face = "bold"),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25),
        legend.title     = element_text(size = textsize.axis,  face = "bold"),
        legend.text      = element_text(size = textsize.axis,  face = "bold"),
        legend.position  = "bottom",
        legend.key.width = ggplot2::unit(1.0,"in")
        );

    my.ggplot <- my.ggplot + labs(
        title    = NULL,
        subtitle = paste0("non-probability sample ",population.flag)
        );

    my.ggplot <- my.ggplot + xlab("true propensity");
    my.ggplot <- my.ggplot + ylab("tree-estimated propensity");

    my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,1),breaks=seq(0,1,0.2));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,1),breaks=seq(0,1,0.2));

    my.ggplot <- my.ggplot + scale_fill_gradient(
        limits = scale_fill_gradient_limits,
        breaks = scale_fill_gradient_breaks,
        low    = "lightgrey",
        high   = "red"
        );

    my.ggplot <- my.ggplot + geom_hex(
        data     = DF.input,
        mapping  = aes(x = propensity, y = p_hat),
        binwidth = c(0.02,0.02)
        );

    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height = 8.5,
        width  = 8.0,
        units  = 'in'
        );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    return(NULL);

    }

