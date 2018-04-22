
myRLib <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library"
.libPaths(c(myRLib,.libPaths()));

library(ggplot2);
set.seed(7654321);
#set.seed(1234567);
#set.seed(12345);

### ~~~~~~~~~~ ###
b0 <- 2.5; b1 <- 0.5;
x <- seq(0,10,0.25);
x <- x + rnorm(length(x),0,0.1);
#y <- b0 + b1 * x + rnorm(length(x),0,0.5);
y <- b0 + b1 * x + rnorm(length(x),0,0.5);

DF.temp <- data.frame(
    x     = x,
    y     = y,
    split = sample(x=c('training','validation'),prob=c(0.6,0.4),size=length(x),replace=TRUE)
    );

palette.Train.Validation <- c("black","red");
names(palette.Train.Validation) <- c("training","validation");

### ~~~~~~~~~~ ###
textsize.title = 40;
textsize.axis  = 20;

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold"),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
    axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
    panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

my.ggplot <- my.ggplot + geom_point(
    data    = DF.temp,
    mapping = aes(x = x,y = y)
    );

ggsave(
    file   = 'xy.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- my.ggplot + geom_abline(
    intercept  =  8.25,
    slope      = -0.85,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

my.ggplot <- my.ggplot + geom_abline(
    intercept  = -5.25,
    slope      =  1.5,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

my.ggplot <- my.ggplot + geom_abline(
    intercept  = 6.25,
    slope      = 0.30,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

ggsave(
    file   = 'xy-randomLines.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
DF.verticalSegments <- data.frame(
    x0 = x,
    y0 = 6.25 + 0.30 * x,
    x1 = x,
    y1 = y
    );

my.ggplot <- my.ggplot + geom_segment(
    mapping    = aes(x=x0,y=y0,xend=x1,yend=y1),
    data       = DF.verticalSegments,
    colour     = "cyan",
    linetype   = 1,
    size       = 0.5
    );

ggsave(
    file   = 'xy-verticalDifferences.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold"),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
    axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
    panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

my.ggplot <- my.ggplot + geom_point(
    data    = DF.temp,
    mapping = aes(x = x,y = y)
    );

my.ggplot <- my.ggplot + geom_abline(
    intercept  =  8.25,
    slope      = -0.85,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

my.ggplot <- my.ggplot + geom_abline(
    intercept  = -5.25,
    slope      =  1.5,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

my.ggplot <- my.ggplot + geom_abline(
    intercept  = 6.25,
    slope      = 0.30,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

results.lm <- lm(formula = y ~ x, data = DF.temp);
betaHat <- coefficients(results.lm);

my.ggplot <- my.ggplot + geom_abline(
    intercept  = betaHat["(Intercept)"],
    slope      = betaHat["x"],
    colour     = "black",
    linetype   = 1,
    size       = 0.5
    );

DF.verticalSegments <- data.frame(
    x0 = x,
    y0 = betaHat["(Intercept)"] + betaHat["x"] * x,
    x1 = x,
    y1 = y
    );

my.ggplot <- my.ggplot + geom_segment(
    mapping    = aes(x=x0,y=y0,xend=x1,yend=y1),
    data       = DF.verticalSegments,
    colour     = "cyan",
    linetype   = 1,
    size       = 0.5
    );

myRMSE           <- sqrt(mean((DF.verticalSegments[["y1"]] - DF.verticalSegments[["y0"]])^2));
myRMSE.formatted <- format(myRMSE,digits=3,nsmall=3);
myRMSE.label     <- paste0("RMSE(italic(train)) == ",myRMSE.formatted);
my.ggplot <- my.ggplot + annotate(
    geom  = "text",
    x     =  5.0,
    y     = 10.0,
    label = myRMSE.label,
    parse = TRUE,
    size  = 10
    );

ggsave(
    file   = 'xy-leastSquares.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
DF.verticalSegments <- data.frame(
    x0 = c(5.5,5.5),
    y0 = (betaHat["(Intercept)"] + betaHat["x"] * 5.5) * c(1,1),
    x1 = c(5.5,0),
    y1 = (betaHat["(Intercept)"] + betaHat["x"] * 5.5) * c(0,1)
    );

my.ggplot <- my.ggplot + geom_segment(
    mapping    = aes(x=x0,y=y0,xend=x1,yend=y1),
    data       = DF.verticalSegments,
    colour     = "blue",
    linetype   = 1,
    size       = 0.5
    );

ggsave(
    file   = 'xy-prediction.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- my.ggplot + geom_abline(
    intercept  = b0,
    slope      = b1,
    colour     = "red",
    linetype   = 1,
    size       = 0.5
    );

ggsave(
    file   = 'xy-trueValues.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold"),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
    axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
    panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

my.ggplot <- my.ggplot + geom_point(
    data    = DF.temp,
    mapping = aes(x = x,y = y)
    );

my.ggplot <- my.ggplot + geom_line(
    data     = data.frame(spline(DF.temp,n=nrow(DF.temp)*10)),
    mapping  = aes(x = x,y = y),
    #se       = FALSE,
    colour   = "gray",
    linetype = 1,
    size     = 0.5
    );

ggsave(
    file   = 'xy-overfitting.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
newX <- seq(0,10,0.5);
newX <- newX + rnorm(length(newX),0,0.1);
newY <- b0 + b1 * newX + rnorm(length(newX),0,0.5);

DF.newdata <- data.frame(x = newX,y = newY);
my.ggplot <- my.ggplot + geom_point(
    data    = DF.newdata,
    mapping = aes(x = x,y = y),
    colour  = "red"
    );

ggsave(
    file   = 'xy-newdata.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
yHat <- spline(DF.temp,xout=newX);
DF.verticalSegments <- data.frame(
    x0 = newX,
    y0 = yHat[["y"]],
    x1 = newX,
    y1 = newY
    );

myRMSE <- sqrt(mean((newY - yHat[["y"]])^2));
my.ggplot <- my.ggplot + geom_segment(
    mapping    = aes(x=x0,y=y0,xend=x1,yend=y1),
    data       = DF.verticalSegments,
    colour     = "cyan",
    linetype   = 1,
    size       = 0.5
    );

myRMSE           <- sqrt(mean((newY - yHat[["y"]])^2));
myRMSE.formatted <- format(myRMSE,digits=3,nsmall=3);
myRMSE.label     <- paste0("RMSE(italic(new)) == ",myRMSE.formatted);
my.ggplot <- my.ggplot + annotate(
    geom  = "text",
    x     = 5.0,
    y     = 0.6,
    label = myRMSE.label,
    parse = TRUE,
    size  = 10
    );

ggsave(
    file   = 'xy-newdata-with-errors.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title             = element_text(size = textsize.title, face = "bold"),
    axis.title.x      = element_blank(),
    axis.title.y      = element_blank(),
    axis.text.x       = element_text(size = textsize.axis,  face = "bold"),
    axis.text.y       = element_text(size = textsize.axis,  face = "bold"),
    panel.grid.major  = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor  = element_line(colour="gray", linetype=2, size=0.25),
    legend.position   = c(0.5,0.12),
    legend.title      = element_blank(),
    legend.direction  = "horizontal",
    legend.key.size   = unit(1,"cm"),
    legend.key        = element_rect(fill=alpha('white',0)),
    legend.text       = element_text(size=30,face = "bold"),
    legend.background = element_rect(fill=alpha('white',0))
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

my.ggplot <- my.ggplot + geom_point(
    data    = DF.temp,
    mapping = aes(x = x, y = y, color = split),
    size    = 2
    );
my.ggplot <- my.ggplot + scale_colour_manual(values = palette.Train.Validation);

ggsave(
    file   = 'xy-split-training-validation.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
results.lm <- lm(formula = y ~ x, data = DF.temp[DF.temp[,"split"]=="training",]);
betaHat <- coefficients(results.lm);

my.ggplot <- my.ggplot + geom_abline(
    intercept  = betaHat["(Intercept)"],
    slope      = betaHat["x"],
    colour     = "black",
    linetype   = 1,
    size       = 0.5
    );

train.X    <- DF.temp[DF.temp[,"split"]=="training","x"];
train.Y    <- DF.temp[DF.temp[,"split"]=="training","y"];
train.YHat <- betaHat["(Intercept)"] + betaHat["x"] * train.X;
RMSE.train           <- sqrt(mean((train.Y - train.YHat)^2));
RMSE.train.formatted <- format(RMSE.train,digits=3,nsmall=3);
RMSE.train.label     <- paste0("RMSE(italic(train)) == ",RMSE.train.formatted);
my.ggplot <- my.ggplot + annotate(
    geom  = "text",
    x     = 0.2,
    y     = 10.0,
    label = RMSE.train.label,
    parse = TRUE,
    size  = 8,
    hjust = 0
    );

valid.X    <- DF.temp[DF.temp[,"split"]=="validation","x"];
valid.Y    <- DF.temp[DF.temp[,"split"]=="validation","y"];
valid.YHat <- betaHat["(Intercept)"] + betaHat["x"] * valid.X;
RMSE.valid           <- sqrt(mean((valid.Y - valid.YHat)^2));
RMSE.valid.formatted <- format(RMSE.valid,digits=3,nsmall=3);
RMSE.valid.label     <- paste0("RMSE(italic(valid)) == ",RMSE.valid.formatted);
my.ggplot <- my.ggplot + annotate(
    geom  = "text",
    x     = 0.2,
    y     = 9.0,
    label = RMSE.valid.label,
    parse = TRUE,
    size  = 8,
    hjust = 0
    );

ggsave(
    file   = 'xy-fit-training.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title             = element_text(size = textsize.title, face = "bold"),
    axis.title.x      = element_blank(),
    axis.title.y      = element_blank(),
    axis.text.x       = element_text(size = textsize.axis,  face = "bold"),
    axis.text.y       = element_text(size = textsize.axis,  face = "bold"),
    panel.grid.major  = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor  = element_line(colour="gray", linetype=2, size=0.25),
    legend.position   = c(0.5,0.12),
    legend.title      = element_blank(),
    legend.direction  = "horizontal",
    legend.key.size   = unit(1,"cm"),
    legend.key        = element_rect(fill=alpha('white',0)),
    legend.text       = element_text(size=30,face = "bold"),
    legend.background = element_rect(fill=alpha('white',0))
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

my.ggplot <- my.ggplot + geom_point(
    data    = DF.temp,
    mapping = aes(x = x, y = y, color = split),
    size    = 2
    );
my.ggplot <- my.ggplot + scale_colour_manual(values = palette.Train.Validation);

DF.train <- DF.temp[DF.temp[,"split"]=="training",];
my.ggplot <- my.ggplot + geom_line(
    data     = data.frame(spline(DF.train,n=nrow(DF.train)*10)),
    mapping  = aes(x = x,y = y),
    #se       = FALSE,
    colour   = "black",
    linetype = 1,
    size     = 0.5
    );


DF.valid <- DF.temp[DF.temp[,"split"]=="validation",];
yHat     <- spline(DF.train,xout=DF.valid[,"x"]);
DF.verticalSegments <- data.frame(
    x0 = DF.valid[,"x"],
    y0 = yHat[["y"]],
    x1 = DF.valid[,"x"],
    y1 = DF.valid[,"y"]
    );

my.ggplot <- my.ggplot + geom_segment(
    mapping    = aes(x=x0,y=y0,xend=x1,yend=y1),
    data       = DF.verticalSegments,
    colour     = "cyan",
    linetype   = 1,
    size       = 0.5
    );

my.ggplot <- my.ggplot + annotate(
    geom  = "text",
    x     =  0.2,
    y     = 10.0,
    label = paste0("RMSE(italic(train)) == 0"),
    parse = TRUE,
    size  = 8,
    hjust = 0
    );

myRMSE <- sqrt(mean((DF.valid[,"y"] - yHat[["y"]])^2));
myRMSE.formatted <- format(myRMSE,digits=3,nsmall=3);
myRMSE.label     <- paste0("RMSE(italic(valid)) == ",myRMSE.formatted);
my.ggplot <- my.ggplot + annotate(
    geom  = "text",
    x     = 0.2,
    y     = 9.0,
    label = myRMSE.label,
    parse = TRUE,
    size  = 8,
    hjust = 0
    );

ggsave(
    file   = 'xy-poly-training.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
x <- seq(0,10,0.15);
x <- x + rnorm(length(x),0,0.05);
y <- -(8/25)*(x-5)^2 + 8 + rnorm(length(x),0,0.75);

DF.temp <- data.frame(
    x     = x,
    y     = y,
    split = sample(x=c('training','validation'),prob=c(0.6,0.4),size=length(x),replace=TRUE)
    );

my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold"),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
    axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
    panel.grid.major = element_line(colour="gray", linetype=2, size=0.25),
    panel.grid.minor = element_line(colour="gray", linetype=2, size=0.25)
    );

my.ggplot <- my.ggplot + geom_hline(yintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + geom_vline(xintercept = 0,colour="gray",size=0.75);
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(-0.2,10.2),breaks=seq(0,10,2));

my.ggplot <- my.ggplot + geom_point(
    data    = DF.temp,
    mapping = aes(x = x,y = y),
    size    = 2
    );

ggsave(
    file   = 'xy-quadratic.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- my.ggplot + geom_abline(
    intercept  =  8.25,
    slope      = -0.85,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

my.ggplot <- my.ggplot + geom_abline(
    intercept  = -5.25,
    slope      =  1.5,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

my.ggplot <- my.ggplot + geom_abline(
    intercept  = 6.25,
    slope      = 0.30,
    colour     = "gray",
    linetype   = 2,
    size       = 0.5
    );

ggsave(
    file   = 'qxy-straight-lines.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
my.ggplot <- my.ggplot + stat_smooth(
    data    = DF.temp,
    mapping = aes(x = x, y = y),
    method  = "lm",
    formula = y ~ x + I(x^2),
    size    = 1,
    colour  = "black",
    se      = FALSE
    );

ggsave(
    file   = 'qxy-quadratic-fit.png',
    plot   = my.ggplot,
    dpi    = 300,
    height = 6,
    width  = 6,
    units  = 'in'
    );

### ~~~~~~~~~~ ###
q();
