
plotDensityParameters <- function(
    DF.input    = NULL,
    methodology = NULL,
    parameter   = NULL,
    true.value  = NULL,
    resolution  = 300
    ) {
    
    require(dplyr);
    require(ggplot2);
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.ggplot <- paste0(
        "density-",
        methodology,"-",
        parameter,
        ".png"
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- DF.input;
    DF.temp[,"tempParameter"] <- DF.temp[,paste(methodology,parameter,sep=".")];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot <- ggplot(data = NULL) + theme_bw() + coord_fixed(ratio=1);
    #my.ggplot <- my.ggplot + ggtitle(plot.title);
    #my.ggplot <- my.ggplot + scale_colour_manual(
    #    name   = "Contact Type (Main)",
    #    values = input.palette
    #    );
    
    #my.ggplot <- my.ggplot + scale_size(
    #    name   = "Contact\nDonation Amount\n(summed over time)"
    #    #, breaks = (1e6) * seq(0,20,10), range  = c(0,6)
    #    );
    
    #is.selected <- DF.temp[['ContactTypeMain']] %in% contact.types;
    #DF.temp     <- na.omit(DF.temp[is.selected,]);

    my.ggplot <- my.ggplot + geom_density(
        data    = DF.temp,
        mapping = aes(
            x     = tempParameter,
            color = myGroup
            )
        );
    
    my.ggplot <- my.ggplot + facet_grid(
        nobs ~ reviewFraction,
        labeller = labeller(nobs = label_both, reviewFraction = label_both)
        );

    my.ggplot <- my.ggplot + scale_x_continuous(
        limits = true.value + 2.5 * c(-1,1),
        breaks = seq(-10,10,1)
        );
    
    my.ggplot <- my.ggplot + scale_y_continuous(
        limits = c(0,6.5),
        breaks = seq(0,7,1)
        );
    
    my.ggplot <- my.ggplot + xlab(label=paste0("parameter: ",parameter,",  ","method: ",methodology));
    my.ggplot <- my.ggplot + scale_colour_discrete(name="Error Rate")
    my.ggplot <- my.ggplot + geom_vline(
        xintercept = true.value,
        size       = 0.5,
        linetype   = 2,
        colour     = "black"
        );
    
    my.ggplot <- my.ggplot + theme(
        title             = element_text(size = 25, face = "bold"),
        axis.title        = element_text(size = 22, face = "bold"),
        axis.text.x       = element_text(size = 10, angle = 0),
        axis.text.y       = element_text(size = 10),
        panel.grid.major  = element_line(size = 0.5),
        panel.grid.minor  = element_line(size = 1.0),
        legend.position   = "bottom",
        legend.title      = element_text(size = 16, face = "bold"),
        legend.text       = element_text(size = 16, face = "bold")
        );
    
    ggsave(
        file   = FILE.ggplot,
        plot   = my.ggplot,
        dpi    = resolution,
        height = 11,
        width  =  8,
        units  = 'in'
        );
    
    }
