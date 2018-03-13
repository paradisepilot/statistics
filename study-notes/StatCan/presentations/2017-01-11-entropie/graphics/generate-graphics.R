
library(ggplot2);

DF.temp <- data.frame(
	side    = as.character(seq(1,6)),
	fair    = rep(1,6)/6,
	loaded  = c(0.05,0.05,0.05,0.2,0.45,0.2),
	certain = c(0,0,0,0,1,0)
	);
DF.temp;

entropy.loaded <- sum( DF.temp[,'loaded'] * log2(1/DF.temp[,'loaded']) );
entropy.loaded;

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

