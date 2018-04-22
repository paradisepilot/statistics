
#myRLib <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library"
#.libPaths(c(myRLib,.libPaths()));

require(tidyr);
require(ggplot2);
require(rpart);
require(rpart.plot);
require(RColorBrewer);

set.seed(7654321);

### ~~~~~~~~~~ ###
textsize.title  <- 30;
textsize.legend <- 20;
textsize.axis   <- 15;

### ~~~~~~~~~~ ###
myEntropy <- function(p) {
    output <- rep(0,length(p));
    isAdmissible <- (0 < p & p < 1);
    output[isAdmissible] <- - p[isAdmissible] * log2(p[isAdmissible]) - (1-p[isAdmissible]) * log2(1-p[isAdmissible]);
    return(output);
}

myGini <- function(p) {
    return(2 * p * (1-p));
}

### ~~~~~~~~~~ ###
DF.data <- data.frame(p = seq(0,1,0.01));
#DF.data[,"Entropy"] <- myEntropy(DF.data[,"p"]);
DF.data[,"Gini"]    <- myGini(   DF.data[,"p"]);

DF.data;

### ~~~~~~~~~~ ###
DF.plot <- gather(
    data  = DF.data,
    key   = "impurity",
    value = "value",
    -p
);

DF.plot;

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold", hjust = 0.5, vjust = 0.5),
    legend.position  = "bottom",
    legend.title     = element_blank(),
    legend.text      = element_text(size = textsize.legend, face = "bold", margin = margin(t=100, r=100, b=100, l=100, unit="pt")),
    legend.spacing   = unit(1,"cm"),
    axis.title.x     = element_text(size = textsize.axis, face = "bold"),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis, face = "bold"),
    axis.text.y      = element_text(size = textsize.axis, face = "bold"),
    panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor = element_blank()
    #panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
);

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.05,1.05),breaks=seq(0,1,0.2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.05,0.55),breaks=seq(0,1,0.1));

my.ggplot <- my.ggplot + geom_line(
    data    = DF.plot,
    mapping = aes(x = p, y = value, colour = impurity),
    size    = 1.3
);

my.ggplot <- my.ggplot + labs(labs(x = "P(Z = a), where Z is {a,b}-valued"));

ggsave(
    file   = 'plot-impurity-metrics.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 5.5,
    units  = 'in'
);

### ~~~~~~~~~~ ###

q();

### ~~~~~~~~~~ ###
textsize.title  <- 30;
textsize.legend <- 20;
textsize.axis   <- 15;

my.palette <- brewer.pal(3,"Set1")[c(1,2)]; # c("green","blue","red");
names(my.palette) <- c("A","B");

my.palette.light        <- c("#ffad99","#99ccff");
names(my.palette.light) <- c("A","B");

### ~~~~~~~~~~ ###
nObservations <- 100;
DF.plot <- data.frame(
    group = c(
        rep(x = "A", times = nObservations),
        rep(x = "B", times = nObservations)
        ),
    x = rnorm(n = 2 * nObservations, mean =  0, sd = 3),
    y = c(
        rnorm(n = nObservations, mean = +2, sd = 0.5),
        rnorm(n = nObservations, mean = -2, sd = 0.5)
        )
    );

DF.plot[,"x1"] <- (DF.plot[,"x"] - DF.plot[,"y"]) / sqrt(2);
DF.plot[,"y1"] <- (DF.plot[,"x"] + DF.plot[,"y"]) / sqrt(2);

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold", hjust = 0.5, vjust = 0.5),
    legend.position  = "none",
    legend.title     = element_blank(),
    legend.text      = element_text(size = textsize.legend, face = "bold", margin = margin(t=100, r=100, b=100, l=100, unit="pt")),
    legend.spacing   = unit(1,"cm"),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis, face = "bold"),
    axis.text.y      = element_text(size = textsize.axis, face = "bold"),
    panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor = element_blank()
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=12*c(-1,1),breaks=seq(-12,12,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=12*c(-1,1),breaks=seq(-12,12,2));

my.ggplot <- my.ggplot + scale_colour_manual(values = my.palette);
my.ggplot <- my.ggplot + geom_point(
    data    = DF.plot,
    mapping = aes(x = x, y = y, colour = group, alpha = 0.5),
    size    = 1.3
    );

ggsave(
    file   = 'plot-horizontal-scatter.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

results.rpart <- rpart(
    formula = group ~ x + y,
    data    = DF.plot
    );

FILE.ggplot <- "plot-horizontal-tree.png";
png(filename = FILE.ggplot, height = 12, width = 8.0, units = "in", res = 300);
prp(
    x           = results.rpart,
    extra       = 101,
    cex         = 3.5, # 3.5,
    legend.cex  = 3.5,
    box.palette = as.list(my.palette.light)
    );
dev.off();

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold", hjust = 0.5, vjust = 0.5),
    legend.position  = "none",
    legend.title     = element_blank(),
    legend.text      = element_text(size = textsize.legend, face = "bold", margin = margin(t=100, r=100, b=100, l=100, unit="pt")),
    legend.spacing   = unit(1,"cm"),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis, face = "bold"),
    axis.text.y      = element_text(size = textsize.axis, face = "bold"),
    panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor = element_blank()
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=12*c(-1,1),breaks=seq(-12,12,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=12*c(-1,1),breaks=seq(-12,12,2));

my.ggplot <- my.ggplot + scale_colour_manual(values = my.palette);
my.ggplot <- my.ggplot + geom_point(
    data    = DF.plot,
    mapping = aes(x = x1, y = y1, colour = group, alpha = 0.5),
    size    = 1.3
);

ggsave(
    file   = 'plot-diagonal-scatter.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
);

results.rpart <- rpart(
    formula = group ~ x1 + y1,
    data    = DF.plot
    );

FILE.ggplot <- "plot-diagonal-tree.png";
png(filename = FILE.ggplot, height = 12, width = 8.0, units = "in", res = 300);
prp(
    x           = results.rpart,
    extra       = 101,
    cex         = 3.5, # 3.5,
    legend.cex  = 3.5,
    box.palette = as.list(my.palette.light)
    );
dev.off();

### ~~~~~~~~~~ ###
q();
