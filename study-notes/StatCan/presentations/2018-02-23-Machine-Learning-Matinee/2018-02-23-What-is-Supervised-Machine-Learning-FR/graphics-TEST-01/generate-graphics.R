
myRLib <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library"
.libPaths(c(myRLib,.libPaths()));

library(ggplot2);
library(glmnet);
set.seed(7654321);
#set.seed(1234567);
#set.seed(12345);

### ~~~~~~~~~~ ###
b0 <- 2.5; b1 <- 0.5;
x <- seq(0,10,0.25);
x <- x + rnorm(length(x),0,0.1);
y <- b0 + b1 * x + rnorm(length(x),0,0.5);

DF.data <- data.frame(
    x     = x,
    y     = y,
    split = sample(x=c('training','validation'),prob=c(0.6,0.4),size=length(x),replace=TRUE)
    );

DF.train <- DF.data[DF.data[,"split"]=="training",];
DF.valid <- DF.data[DF.data[,"split"]=="validation",];

palette.Train.Validation <- c("black","red");
names(palette.Train.Validation) <- c("training","validation");

### ~~~~~~~~~~ ###
textsize.title = 40;
textsize.axis  = 20;

### ~~~~~~~~~~ ###
myScaler <- function(x) {

    return(
        scale(as.matrix(data.frame(
            x1  = x,
            x2  = x^2,
            x3  = x^3,
            x4  = x^4,
            x5  = x^5,
            x6  = x^6,
            x7  = x^7,
            x8  = x^8,
            x9  = x^9,
            x10 = x^10,
            x11 = x^11,
            x12 = x^12,
            x13 = x^13,
            x14 = x^14,
            x15 = x^15,
            x16 = x^16,
            x17 = x^17,
            x18 = x^18,
            x19 = x^19,
            x20 = x^20,
            x21 = x^21,
            x22 = x^22,
            x23 = x^23,
            x24 = x^24,
            x25 = x^25
        )))
        );
    }

myPlot.LM <- function(DF.train, DF.valid, FILE.output) {

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
        data    = DF.data,
        mapping = aes(x = x, y = y, color = split),
        size    = 2
        );
    my.ggplot <- my.ggplot + scale_colour_manual(values = palette.Train.Validation);
    
    DF.temp <- as.data.frame(cbind(y=DF.train[,"y"],myScaler(x=DF.train[,"x"])));
    DF.temp <- DF.temp[,setdiff(colnames(DF.temp),c("x19","x20","x21","x22","x23","x24","x25"))];
    fit.lm  <- lm(
        formula = y ~ .,
        data    = DF.temp
        );
    coef.lm = coef(object = fit.lm);
    print("coef.lm");
    print( coef.lm );
    
    DF.temp <- cbind(
        x = DF.train[,"x"],
        prediction = predict(
            object  = fit.lm,
            newdata = DF.temp[,setdiff(colnames(DF.temp),"y")],
            type    = "response"
            ),
        DF.temp[,setdiff(colnames(DF.temp),"prediction")]
        );
    print("DF.temp (LM):");
    print( DF.temp );
    
    DF.spline <- data.frame(spline(DF.temp[,c("x","prediction")],n=nrow(DF.temp)*10));
    print("str(DF.spline)");
    print( str(DF.spline) );
    
    my.ggplot <- my.ggplot + geom_line(
        data     = DF.spline,
        mapping  = aes(x = x, y = y),
        colour   = "black",
        linetype = 1,
        size     = 0.5
        );
    
    yHat <- spline(DF.temp[,c("x","prediction")],xout=DF.valid[,"x"]);
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
    
    RMSE.train <- sqrt(mean((DF.temp[ ,"y"] - DF.temp[,"prediction"])^2));
    RMSE.valid <- sqrt(mean((DF.valid[,"y"] - yHat[["y"]])^2));
    
    RMSE.train.formatted <- format(RMSE.train,digits=3,nsmall=3);
    RMSE.valid.formatted <- format(RMSE.valid,digits=3,nsmall=3);
    RMSE.train.label <- paste0("RMSE(italic(train)) == ",RMSE.train.formatted);
    RMSE.valid.label <- paste0("RMSE(italic(valid)) == ",RMSE.valid.formatted);
    
    my.ggplot <- my.ggplot + annotate(
        geom  = "text",
        x     = 0.5,
        y     = 9.0,
        label = RMSE.train.label,
        parse = TRUE,
        size  = 8,
        hjust = 0
        );
    
    my.ggplot <- my.ggplot + annotate(
        geom  = "text",
        x     = 0.5,
        y     = 8.0,
        label = RMSE.valid.label,
        parse = TRUE,
        size  = 8,
        hjust = 0
        );
    
    my.ggplot <- my.ggplot + annotate(
        geom  = "text",
        x     = 0.5,
        y     = 10,
        label = "lambda == 0",
        parse = TRUE,
        size  = 8,
        hjust = 0
        );
    
    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height = 6,
        width  = 6,
        units  = 'in'
        );
    
    }

myPlot.LASSO <- function(DF.train, DF.valid, lambda, FILE.output) {

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
        data    = DF.data,
        mapping = aes(x = x, y = y, color = split),
        size    = 2
        );
    my.ggplot <- my.ggplot + scale_colour_manual(values = palette.Train.Validation);
    
    Xmatrix <- myScaler(x=DF.train[,"x"]);
    fit.glmnet <- glmnet(
        x           = Xmatrix,
        y           = DF.train[,"y"],
        intercept   = TRUE,
        family      = "gaussian",
        standardize = TRUE,
        alpha       = 0, # Ridge Regression
        # alpha     = 1, # LASSO
        lambda      = lambda
        );
    coef.glmnet = coef(
        object = fit.glmnet,
        exact  = TRUE,
        x      = Xmatrix,
        y      = DF.train[,"y"]
        );
    print("coef.glmnet");
    print( coef.glmnet );
    
    DF.train <- cbind(
        DF.train[,setdiff(colnames(DF.train),"prediction")],
        prediction = predict(
            object = fit.glmnet,
            newx   = Xmatrix,
            type   = "response",
            s      = lambda
            )
        );
    colnames(DF.train) <- gsub(
        x           = colnames(DF.train),
        pattern     = "1",
        replacement = "prediction"
        );
    print("DF.train (LASSO):");
    print( DF.train );
    
    DF.spline <- data.frame(spline(DF.train[,c("x","prediction")],n=nrow(DF.train)*10));
    print("str(DF.spline)");
    print( str(DF.spline) );
    
    my.ggplot <- my.ggplot + geom_line(
        data     = DF.spline,
        mapping  = aes(x = x, y = y),
        colour   = "black",
        linetype = 1,
        size     = 0.5
        );
    
    yHat <- spline(DF.train[,c("x","prediction")],xout=DF.valid[,"x"]);
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
    
    RMSE.train <- sqrt(mean((DF.train[,"y"] - DF.train[,"prediction"])^2));
    RMSE.valid <- sqrt(mean((DF.valid[,"y"] - yHat[["y"]])^2));
    
    RMSE.train.formatted <- format(RMSE.train,digits=3,nsmall=3);
    RMSE.valid.formatted <- format(RMSE.valid,digits=3,nsmall=3);
    RMSE.train.label <- paste0("RMSE(italic(train)) == ",RMSE.train.formatted);
    RMSE.valid.label <- paste0("RMSE(italic(valid)) == ",RMSE.valid.formatted);
    
    my.ggplot <- my.ggplot + annotate(
        geom  = "text",
        x     = 0.5,
        y     = 9.0,
        label = RMSE.train.label,
        parse = TRUE,
        size  = 8,
        hjust = 0
        );
    
    my.ggplot <- my.ggplot + annotate(
        geom  = "text",
        x     = 0.5,
        y     = 8.0,
        label = RMSE.valid.label,
        parse = TRUE,
        size  = 8,
        hjust = 0
        );
    
    my.ggplot <- my.ggplot + annotate(
        geom  = "text",
        x     = 0.5,
        y     = 10,
        label = paste0("lambda == ",lambda),
        parse = TRUE,
        size  = 8,
        hjust = 0
        );
    
    ggsave(
        file   = FILE.output,
        plot   = my.ggplot,
        dpi    = 300,
        height = 6,
        width  = 6,
        units  = 'in'
        );
    
    }

### ~~~~~~~~~~ ###
myPlot.LM(
    DF.train    = DF.train,
    DF.valid    = DF.valid,
    FILE.output = 'xy-LASSO-fit-lambda-0.png'
    );

### ~~~~~~~~~~ ###
lambdas <- c(
    1e-12,1e-11,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,0.001,0.01,
    0.1,0.2,0.3,0.4,0.5,0.525,0.550,0.575,0.6,0.7,0.8,0.9,
    1,10,100,500,1000
    );
DF.lambdas <- data.frame(
    lambda = lambdas,
    suffix = gsub(x=as.character(lambdas),pattern='\\.',replacement="pt")
    );
print("DF.lambdas");
print( DF.lambdas );

### ~~~~~~~~~~ ###
for (i in 1:nrow(DF.lambdas)) {
    myPlot.LASSO(
        DF.train    = DF.train,
        DF.valid    = DF.valid,
        lambda      = DF.lambdas[i,"lambda"],
        FILE.output = paste0('xy-LASSO-fit-lambda-',DF.lambdas[i,"suffix"],'.png')
        );
    }

### ~~~~~~~~~~ ###
q()

