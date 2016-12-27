
plotDensityParameters <- function(
    FILE.ggplot   = NULL,
    plot.title    = NULL,
    DF.input      = NULL,
    input.palette = NULL,
    input.alpha   = 0.2,
    resolution    = 300
    ) {
    
    require(dplyr);
    require(ggplot2);
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- DF.input %>% filter(
        nobs == 5000 &
        reviewFraction > 0.5
        );
    
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
            x     = all.x3,
            color = myGroup
            )
        );

    my.ggplot <- my.ggplot + scale_x_continuous(
        limits = c(-5,0)
        #,breaks = temp.breaks,
        #labels = 10 ^ temp.breaks
        );

    #my.ggplot <- my.ggplot + xlab("Deposit Date");
    #my.ggplot <- my.ggplot + ylab("Donation Receipt Date");
    
    #my.ggplot <- my.ggplot + geom_abline(intercept = 0, slope = 1, size = 1, linetype = 2, colour = "gray");
    
    #my.ggplot <- my.ggplot + scale_x_date(
    #    date_labels        = "%b %Y",
    #    limits             = c(as.Date(start.date),as.Date(end.date)),
    #    date_breaks        = "1 year"
    #);
    
    #my.ggplot <- my.ggplot + scale_y_date(
    #    date_labels        = "%b %Y",
    #    limits             = c(as.Date(start.date),as.Date(end.date)),
    #    date_breaks        = "1 year"
    #);
    
    #my.ggplot <- my.ggplot + theme(
    #    title             = element_text(size = 25, face = "bold"),
    #    axis.title        = element_text(size = 22, face = "bold"),
    #    axis.text.x       = element_text(size = 10, angle = 90),
    #    axis.text.y       = element_text(size = 10),
    #    panel.grid.major  = element_line(size = 0.5),
    #    panel.grid.minor  = element_line(size = 1.0),
    #    legend.position   = "right",
    #    legend.title      = element_text(size = 16, face = "bold"),
    #    legend.text       = element_text(size = 16, face = "bold")
    #);
    
    ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = resolution, height = 8, width = 12, units = 'in');
    
    }
