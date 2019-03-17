
postVisualization <- function(
    FILE.input       = NULL,
    textsize.title   = 30,
    textsize.axis    = 20,
    vline_xintercept = NULL
    ) {

    require(ggplot2);

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    DF.input <- read.csv(file = FILE.input);

    cat("\nstr(DF.output)\n");
    print( str(DF.input)    );

    cat("\nsummary(DF.input)\n");
    print( summary(DF.input)   );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    plotOneHistogram(
        DF.input         = DF.input,
        target.variable  = 'Y_total_hat_propensity',
        FILE.output      = 'plot-histogram-Y-total-hat-propensity.png',
        plot.title       = "Estimated Population Total of Y",
        plot.subtitle    = "(non-probability sample, true propensity)",
        vline_xintercept = vline_xintercept,
        textsize.title   = textsize.title,
        textsize.axis    = textsize.axis
        );

    plotOneHistogram(
        DF.input         = DF.input,
        target.variable  = 'Y_total_hat_tree',
        FILE.output      = 'plot-histogram-Y-total-hat-tree.png',
        plot.title       = "Estimated Population Total of Y",
        plot.subtitle    = "(non-probability sample, tree-based propensity estimation)",
        vline_xintercept = vline_xintercept,
        textsize.title   = textsize.title,
        textsize.axis    = textsize.axis
        );

    plotOneHistogram(
        DF.input         = DF.input,
        target.variable  = 'Y_total_hat_calibration',
        FILE.output      = 'plot-histogram-Y-total-hat-calibration.png',
        plot.title       = "Estimated Population Total of Y",
        plot.subtitle    = "(non-probability sample, calibration)",
        vline_xintercept = vline_xintercept,
        textsize.title   = textsize.title,
        textsize.axis    = textsize.axis
        );

    plotOneHistogram(
        DF.input         = DF.input,
        target.variable  = 'Y_total_hat_naive',
        FILE.output      = 'plot-histogram-Y-total-hat-naive.png',
        plot.title       = "Estimated Population Total of Y",
        plot.subtitle    = "(non-probability sample, naive)",
        vline_xintercept = vline_xintercept,
        textsize.title   = textsize.title,
        textsize.axis    = textsize.axis
        );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    return(NULL);

    }

##################################################
plotOneHistogram <- function(
    DF.input         = NULL,
    target.variable  = NULL,
    FILE.output      = NULL,
    plot.title       = NULL,
    plot.subtitle    = NULL,
    vline_xintercept = NULL,
    textsize.title   = NULL,
    textsize.axis    = NULL
    ) {

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
        title    = plot.title,
        subtitle = plot.subtitle
        );

    my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);

    my.ggplot <- my.ggplot + scale_x_continuous(
        limits = 100000 *   c(0,6.5),
        breaks = 100000 * seq(0,6.0,1)
        );
    #my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,3),breaks=seq(0,3,0.5));

    DF.temp <- data.frame(x = DF.input[,target.variable]);

    my.ggplot <- my.ggplot + geom_histogram(
        data     = DF.temp,
        mapping  = aes(x = x),
        alpha    = 0.5,
        binwidth = 2000
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

    return( NULL );

    }

