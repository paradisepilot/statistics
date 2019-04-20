
visualizeData <- function(DF.input, palette.iris) {

    require(ggplot2);
    require(RColorBrewer);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    textsize.title <- 40;
    textsize.axis  <- 40;
    
    textsize.axis.title     <- 40;
    textsize.axis.tickLabel <- 20;

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "scatter-sepalLength-vs-sepalWidth.png";

    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        legend.title     = element_blank(),
        legend.text      = element_text(size = textsize.title, face = "bold"),
        legend.key.size  = unit(x=0.1,units="in"),
        #legend.position  = "bottom",
        #legend.direction = "horizontal",
        #axis.title.x    = element_blank(),
        #axis.title.y    = element_blank(),
        axis.title       = element_text(size = textsize.axis.title,     face = "bold"),
        axis.text        = element_text(size = textsize.axis.tickLabel, face = "bold"),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
        );
    
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(2,4.5),breaks=seq(1,10,1));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(4,8),breaks=seq(1,10,1));
    my.ggplot <- my.ggplot + scale_colour_manual(values = palette.iris);
    
    my.ggplot <- my.ggplot + geom_point(
        data    = DF.input,
        mapping = aes(
            x     = Sepal.Width,
            y     = Sepal.Length,
            color = Self.Selected
            ),
        size  = 3.5,
        alpha = 0.75
        ); 

    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 300, height = 8, width = 12, units = 'in');

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "scatter-petalLength-vs-petalWidth.png";
    
    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        legend.title     = element_blank(),
        legend.text      = element_text(size = textsize.title, face = "bold"),
        legend.key.size  = unit(x=0.1,units="in"),
        legend.position  = "bottom",
        legend.direction = "horizontal",
        axis.title       = element_text(size = textsize.axis.title,     face = "bold"),
        axis.text        = element_text(size = textsize.axis.tickLabel, face = "bold"),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
        #axis.title.x    = element_blank(),
        #axis.title.y    = element_blank(),
    );
    
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,2.5),breaks=seq(0,10,1));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(1,7),breaks=seq(0,10,1));
    my.ggplot <- my.ggplot + scale_colour_manual(values = palette.iris);
    
    my.ggplot <- my.ggplot + geom_point(
        data    = DF.input,
        mapping = aes(
            x     = x1,
            y     = x2,
            color = Self.Selected
            ),
        size  = 3.5,
        alpha = 0.75
        ); 
    
    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 300, height = 10, width = 8, units = 'in');
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- "scatter-petalLength-vs-petalWidth-boundaries.png";
    
    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title            = element_text(size = textsize.title, face = "bold"),
        legend.title     = element_blank(),
        legend.text      = element_text(size = textsize.title, face = "bold"),
        legend.key.size  = unit(x=0.1,units="in"),
        legend.position  = "bottom",
        legend.direction = "horizontal",
        legend.spacing.x = unit(20, 'pt'),
        axis.title       = element_text(size = textsize.axis.title,     face = "bold"),
        axis.text        = element_text(size = textsize.axis.tickLabel, face = "bold"),
        panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
        );
    
    my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,2.5),breaks=seq(0,10,1));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(1,7),breaks=seq(0,10,1));
    my.ggplot <- my.ggplot + scale_colour_manual(values = palette.iris);
    
    my.ggplot <- my.ggplot + geom_point(
        data    = DF.input,
        mapping = aes(
            x     = x1,
            y     = x2,
            color = Self.Selected
            ),
        size  = 3.5,
        alpha = 0.75
        );

    DF.temp <- data.frame(x1 = 0, x2 = 2.5, y1 = 2.5, y2 = 2.5)
    my.ggplot <- my.ggplot + geom_segment(
        data = DF.temp,
        mapping = aes(
            x    = x1,
            y    = y1,
            xend = x2,
            yend = y2
            ),
        size     = 2,
        linetype = 2,
        colour   = "black"
        );
    
    DF.temp <- data.frame(x1 = 1.8, x2 = 1.8, y1 = 2.5, y2 = 7)
    my.ggplot <- my.ggplot + geom_segment(
        data = DF.temp,
        mapping = aes(
            x    = x1,
            y    = y1,
            xend = x2,
            yend = y2
            ),
        size     = 2,
        linetype = 2,
        colour   = "black"
        );
    
    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = 300, height = 10, width = 8, units = 'in');
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }
