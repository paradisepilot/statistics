
visualizeEventHistories <- function(
    event.histories = NULL,
    FILE.output     = 'event-histories.png',
    textsize.title  =  30,
    textsize.axis   =  20,
    dpi             = 300,
    height          =   1,
    width           =  18,
    units           = 'in'
    ) {

    require(ggplot2);
    require(lubridate);

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    event.histories.long <- data.frame(
        event.type  = character(0),
        date.time   = rep(as_datetime(""),0),
        event.count = integer(0)
        );

    for ( temp.event.type in names(event.histories) ) {
        n.rows <- length(event.histories[[temp.event.type]]);
        event.histories.long <- rbind(
            event.histories.long,
            data.frame(
                event.type  = rep( temp.event.type, n.rows ),
                date.time   = event.histories[[ temp.event.type ]],
                event.count = rep(1,n.rows)
                )
            );
        }

    cat("\nevent.histories.long\n");
    print( event.histories.long   );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    my.ggplot <- ggplot(data = NULL) + theme_bw();
    my.ggplot <- my.ggplot + theme(
        title              = element_text(size = textsize.title, face = "bold"),
        axis.title.x       = element_blank(),
        axis.title.y       = element_blank(),
        axis.text.x        = element_text(size = textsize.axis, face = "bold"),
        axis.text.y        = element_blank(),
        strip.text.y       = element_text(size = textsize.axis, face = "bold", angle = 0),
        panel.grid.major   = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor.x = element_line(colour="gray", linetype=2, size=0.25),
        panel.grid.minor.y = element_blank(),
        legend.title       = element_text(size = textsize.axis,  face = "bold")
        );

    #my.ggplot <- my.ggplot + labs(
    #    title    = NULL,
    #    subtitle = paste0("Population ",population.flag)
    #    );

    #my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
    #my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
    #my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
    #my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

    #my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.05,1.05),breaks=seq(0,1,0.2));
    my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,1),breaks=seq(0,1));

    my.ggplot <- my.ggplot + geom_bar(
        data    = event.histories.long,
        mapping = aes(x = date.time, y = event.count),
        stat    = "identity",
        width   = 0.1,
        color   = "red"
        );

    my.ggplot <- my.ggplot + facet_grid( rows = vars(event.type) );

    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =   4,
        width  =  12,
        units  = 'in'
        );

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    return(NULL);

    }

