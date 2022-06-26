
visualize.data <- function(
    DF.input        = NULL,
    results.OPLS    = NULL,
    results.PCA     = NULL,
    textsize.title  = 35,
    textsize.axis   = 35,
    dots.per.inch   = 300,
    PNG.OPLS.vs.PCA = "plot-OPLS-vs-PCA.png",
    PNG.PCA         = "plot-PCA.png"
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
    my.ggplot.0 <- initializePlot(
        textsize.title = textsize.title,
        textsize.axis  = textsize.axis
        );

    my.ggplot.0 <- my.ggplot.0 + ggplot2::scale_x_continuous(limits = 50 * c(-1,1));
    my.ggplot.0 <- my.ggplot.0 + ggplot2::scale_y_continuous(limits = 50 * c(-1,1));

    my.ggplot.0 <- my.ggplot.0 + ggplot2::geom_point(
        data    = DF.input,
        mapping = ggplot2::aes(
            x      = x1,
            y      = x2,
            colour = y
            ),
        size = 0.5
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot.1 <- my.ggplot.0;

    my.ggplot.1 <- my.ggplot.1 + ggplot2::geom_segment(
        mapping = ggplot2::aes(x = 0, y = 0, xend = xend.OPLS, yend = yend.OPLS),
        arrow   = ggplot2::arrow(length = unit(1, "cm")),
        size    = 3,
        color    = "red"
        );

    my.ggplot.1 <- my.ggplot.1 + ggplot2::geom_segment(
        mapping  = ggplot2::aes(x = 0, y = 0, xend = xend.PCA, yend = yend.PCA),
        arrow    = ggplot2::arrow(length = unit(1, "cm")),
        size     = 3,
        color    = "black"
        );

    my.ggplot.1 <- my.ggplot.1 + ggplot2::geom_segment(
        mapping = ggplot2::aes(x = 0.85 * xend.PCA, y = 0.85 * yend.PCA, xend = xend.PCA, yend = yend.PCA),
        arrow   = ggplot2::arrow(length = unit(1, "cm")),
        size    = 3
        );

    ggplot2::ggsave(
        filename = PNG.OPLS.vs.PCA,
        plot     = my.ggplot.1,
        # scale  = 1,
        width    = 16,
        height   = 16,
        units    = "in",
        dpi      = dots.per.inch
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot.2 <- my.ggplot.0;

    my.ggplot.2 <- my.ggplot.2 + ggplot2::geom_segment(
        mapping = ggplot2::aes(x = 0, y = 0, xend = xend.OPLS, yend = yend.OPLS),
        arrow   = ggplot2::arrow(length = unit(1, "cm")),
        size    = 3,
        linetype = "dashed"
        );

    my.ggplot.2 <- my.ggplot.2 + ggplot2::geom_segment(
        mapping = ggplot2::aes(x = 0.85 * xend.OPLS, y = 0.85 * yend.OPLS, xend = xend.OPLS, yend = yend.OPLS),
        arrow   = ggplot2::arrow(length = unit(1, "cm")),
        size    = 3
        );

    my.ggplot.2 <- my.ggplot.2 + ggplot2::geom_segment(
        mapping  = ggplot2::aes(x = 0, y = 0, xend = xend.PCA, yend = yend.PCA),
        arrow    = ggplot2::arrow(length = unit(1, "cm")),
        size     = 3
        );

    ggplot2::ggsave(
        filename = PNG.PCA,
        plot     = my.ggplot.2,
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
