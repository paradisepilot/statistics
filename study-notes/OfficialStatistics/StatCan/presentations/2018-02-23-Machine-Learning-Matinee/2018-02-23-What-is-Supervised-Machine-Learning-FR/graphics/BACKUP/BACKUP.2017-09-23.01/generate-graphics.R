
myRLib <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library"
.libPaths(c(myRLib,.libPaths()));

library(ggplot2);

### ~~~~~~~~~~ ###
b0 <- 1; b1 <- 0.5;
x <- seq(0,10,0.1); x <- x + rnorm(length(x),0,0.01);
y <- b0 + b1 * x + rnorm(length(x),0,1);
    
DF.temp <- data.frame(x = x,y = y);
DF.temp;

### ~~~~~~~~~~ ###
textsize.title = 40;
textsize.axis  = 25;

### ~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
    title            = element_text(size = textsize.title, face = "bold"),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
    axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
    );
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(-0.5,10.5),breaks=seq(0,10,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c( 0.0,10.0),breaks=seq(0,10,1));

#my.ggplot <- my.ggplot + ggtitle('D\u{E9} #1');
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
q();

### ~~~~~~~~~~ ###

my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + theme(
	title            = element_text(size = textsize.title, face = "bold"),
	axis.title.x     = element_blank(),
	axis.title.y     = element_blank(),
	axis.text.x      = element_text(size = textsize.axis,  face = "bold"),
	axis.text.y      = element_text(size = textsize.axis,  face = "bold"),
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank()
	);
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,1),breaks=seq(0,1,0.1));

my.ggplot <- my.ggplot + ggtitle('D\u{E9} #0');
my.ggplot <- my.ggplot + geom_bar(
	data    = DF.temp,
	mapping = aes(
		x = side,
		y = certain 
		),
	stat  = "identity",
	width = 0.75,
	alpha = 0.50
	);

ggsave(
	file   = 'certain-die.png',
	plot   = my.ggplot,
	dpi    = 300,
	height = 6,
	width  = 3,
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
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank()
	);
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,1),breaks=seq(0,1,0.1));

my.ggplot <- my.ggplot + ggtitle('D\u{E9} #1');
my.ggplot <- my.ggplot + geom_bar(
	data    = DF.temp,
	mapping = aes(
		x = side,
		y = loaded
		),
	stat  = "identity",
	width = 0.75,
	alpha = 0.50
	);

ggsave(
	file   = 'loaded-die.png',
	plot   = my.ggplot,
	dpi    = 300,
	height = 6,
	width  = 3,
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
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank()
	);
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,1),breaks=seq(0,1,0.1));

my.ggplot <- my.ggplot + ggtitle('D\u{E9} #2');
my.ggplot <- my.ggplot + geom_bar(
	data    = DF.temp,
	mapping = aes(
		x = side,
		y = fair
		),
	stat  = "identity",
	width = 0.75,
	alpha = 0.50
	);

ggsave(
	file   = 'fair-die.png',
	plot   = my.ggplot,
	dpi    = 300,
	height = 6,
	width  = 3,
	units  = 'in'
	);

### ~~~~~~~~~~ ###

q();

