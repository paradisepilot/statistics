
visualize.data <- function(
    DF.input       = NULL,
    results.OPLS   = NULL,
    results.PCA    = NULL,
    textsize.title = 35,
    textsize.axis  = 35,
    dots.per.inch  = 300,
    PNG.output     = "plot-data.png"
    ) {

    thisFunctionName <- "visualize.data";

    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n# ",thisFunctionName,"() starts.\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    require(ggplot2);
    require(RColorBrewer);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    vector.index    <- which(results.OPLS[['values']] > 1);
    dominant.vector <- results.OPLS[['vectors']][,vector.index];
    dominant.vector <- dominant.vector / sqrt(sum(dominant.vector^2));
    xend.OPLS <- 25 * dominant.vector[1];
    yend.OPLS <- 25 * dominant.vector[2];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    vector.index    <- which(results.PCA[['sdev']] == max(results.PCA[['sdev']]));
    dominant.vector <- results.PCA[['rotation']][,vector.index];
    dominant.vector <- dominant.vector / sqrt(sum(dominant.vector^2));
    xend.PCA <- 25 * dominant.vector[1];
    yend.PCA <- 25 * dominant.vector[2];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.colour.palette <- unique(DF.input[,'colour']);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.input[,'y.numeric'] <- DF.input[,'y'];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.colour.scheme <- data.frame(
        colour = my.colour.palette,
        label  = as.character(sort(unique(DF.input[,'y.numeric'])))
        );

    cat("\nDF.colour.scheme\n");
    print( DF.colour.scheme   );

    DF.input[,'y'] <- factor(
        x      = DF.input[,'colour'],
        levels = DF.colour.scheme[,'colour'],
        labels = DF.colour.scheme[,'label' ]
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot <- initializePlot(
        textsize.title = textsize.title,
        textsize.axis  = textsize.axis
        );

    # my.ggplot <- my.ggplot + ggplot2::scale_fill_manual( 'y', values = my.colour.palette);
    # my.ggplot <- my.ggplot + ggplot2::scale_color_manual('y', values = my.colour.palette);

    my.ggplot <- my.ggplot + ggplot2::geom_point(
        data    = DF.input,
        mapping = ggplot2::aes(
            x      = x1,
            y      = x2,
            colour = y
            ),
        size = 0.5
        );

    my.ggplot <- my.ggplot + ggplot2::geom_segment(
        mapping = ggplot2::aes(x = 0, y = 0, xend = xend.OPLS, yend = yend.OPLS),
        arrow   = ggplot2::arrow(length = unit(1, "cm")),
        size    = 3
        );

    my.ggplot <- my.ggplot + ggplot2::geom_segment(
        mapping  = ggplot2::aes(x = 0, y = 0, xend = xend.PCA, yend = yend.PCA),
        arrow    = ggplot2::arrow(length = unit(1, "cm")),
        size     = 3,
        linetype = "dashed"
        );

    my.ggplot <- my.ggplot + ggplot2::geom_segment(
        mapping = ggplot2::aes(x = 0.85 * xend.PCA, y = 0.85 * yend.PCA, xend = xend.PCA, yend = yend.PCA),
        arrow   = ggplot2::arrow(length = unit(1, "cm")),
        size    = 3
        );

    my.ggplot <- my.ggplot + ggplot2::scale_x_continuous(limits = 50 * c(-1,1));
    my.ggplot <- my.ggplot + ggplot2::scale_y_continuous(limits = 50 * c(-1,1));

    # my.ggplot <- my.ggplot + ggplot2::labs(fill = 'y');
    # my.ggplot <- my.ggplot + ggplot2::theme(legend.position = "none");

    ggplot2::ggsave(
        filename = PNG.output,
        plot     = my.ggplot,
        # scale  = 1,
        width    = 16,
        height   = 16,
        units    = "in",
        dpi      = dots.per.inch
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n# ",thisFunctionName,"() exits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( NULL );

    }
