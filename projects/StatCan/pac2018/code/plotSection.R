
plotSection <- function(
    CSV.input,
    custom.palette,
    textsize.axis   = 18,
    textsize.legend = 18,
    textsize.title  = 25
    ) {

    require(ggplot2);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.wide <- read_csv(file = CSV.input);
    DF.wide <- DF.wide %>%
        mutate(Section = paste0(division,":",chief));
    
    DF.wide <- as.data.frame(DF.wide);
    
    DF.wide[,"division"] <- factor(x=gsub(
        x           = as.character(DF.wide[,"division"]),
        pattern     = "/",
        replacement = " / "
        ));
    
    colnames(DF.wide) <- gsub(
        x           = colnames(DF.wide),
        pattern     = "week",
        replacement = paste0(string.week," ")
        );
    
    DF.long <- as.data.frame(gather(
        data  = DF.wide,
        key   = week,
        value = score,
        names(custom.palette)
        ));
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot <- ggplot(data = NULL) + theme_bw();
    
    my.ggplot <- my.ggplot + theme(
        title             = element_text(size = textsize.title, face = "bold"),
        plot.background   = element_rect(fill = "black", colour = "black"),
        axis.title.x      = element_blank(),
        axis.title.y      = element_blank(),
        axis.text.x       = element_text(size=textsize.axis,face="bold",color="gray",angle=90,vjust=0.5),
        axis.text.y       = element_text(size=textsize.axis,face="bold",color="gray"),
        panel.background  = element_rect(fill = "black", colour = "black"),
        panel.grid.major  = element_line(colour="gray", linetype=2, size=0.50),
        panel.grid.minor  = element_line(colour="gray", linetype=2, size=0.50),
        legend.position   = "bottom",
        legend.title      = element_blank(),
        legend.direction  = "horizontal",
        legend.key        = element_rect(fill=alpha('white',0)),
        legend.text       = element_text(size=textsize.legend,face="bold",color="gray",margin=margin(l=24,r=24,unit="pt")),
        legend.background = element_rect(fill=alpha('white',0)),
        legend.key.size   = unit(1,"cm"),
        legend.spacing    = unit(1,"cm"),
        legend.margin     = margin(t = 1, r = 1, b = 1, l = 1, unit = "pt"),
        strip.text        = element_text(size=textsize.axis,colour="black")
        );
    
    my.ggplot <- my.ggplot + scale_y_continuous(limits=1000*c(0,6),breaks=1000*seq(0,6,1));
    
    my.ggplot <- my.ggplot + scale_fill_manual(
        values = custom.palette,
        labels = paste0(names(custom.palette),paste0(rep(" ",4),collapse=""))
        );
    
    my.ggplot <- my.ggplot + geom_col(
        data     = DF.long,
        mapping  = aes(y=score,x=chief,fill=week),
        position = position_stack(reverse = TRUE)
        );
    
    my.ggplot <- my.ggplot + facet_grid( ~ division, scales = "free_x");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( my.ggplot );

    }
