
#myRLib <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library"
#.libPaths(c(myRLib,.libPaths()));

library(tidyr);
library(ggplot2);
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
DF.data[,"Entropy"] <- myEntropy(DF.data[,"p"]);
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
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.05,1.05),breaks=seq(0,1,0.1));

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
