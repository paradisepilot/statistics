
ex.04.07.11.b <- function(DF.auto = NULL) {

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	### (b) ###

	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = year, y = jitter(mpg01,amount=0.25)),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);

	#my.ggplot <- my.ggplot + scale_x_date(limits = c(as.Date("1969-01-01"),as.Date("1983-12-31")),date_breaks="1 year");
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-0.5,1.5), breaks = c(0,1));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg01-vs-year.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = jitter(cylinders,0.75), y = weight),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15) #, angle = 90)
		);

	temp.filename <- 'plot-weight-vs-cylinders.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = weight, y = displacement),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15) #, angle = 90)
		);

	temp.filename <- 'plot-displacement-vs-weight.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 8, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = weight, y = horsepower),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15) #, angle = 90)
		);

	temp.filename <- 'plot-horsepower-vs-weight.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 8, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = manufacturer, y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
	my.ggplot <- my.ggplot + geom_hline(
		mapping = aes(yintercept=median(DF.auto[['mpg']])),
		colour  = "green"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg-vs-manufacturer.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');
	
	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = year, y = mpg),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);
	my.ggplot <- my.ggplot + geom_hline(
		mapping = aes(yintercept=median(DF.auto[['mpg']])),
		colour  = "green"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg-vs-year.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = year, y = weight),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-weight-vs-year.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = jitter(cylinders,amount=0.25), y = mpg),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);
	my.ggplot <- my.ggplot + geom_hline(
		mapping = aes(yintercept=median(DF.auto[['mpg']])),
		colour  = "green"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg-vs-cylinders.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = jitter(origin,amount=0.25), y = mpg),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);
	my.ggplot <- my.ggplot + geom_hline(
		mapping = aes(yintercept=median(DF.auto[['mpg']])),
		colour  = "green"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg-vs-origin.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = displacement, y = mpg),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);
	my.ggplot <- my.ggplot + geom_hline(
		mapping = aes(yintercept=median(DF.auto[['mpg']])),
		colour  = "green"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg-vs-displacement.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = horsepower, y = mpg),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg-vs-horsepower.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = weight, y = mpg),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);
	my.ggplot <- my.ggplot + geom_hline(
		mapping = aes(yintercept=median(DF.auto[['mpg']])),
		colour  = "green"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);

	temp.filename <- 'plot-mpg-vs-weight.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw();
	my.ggplot <- my.ggplot + geom_point(
		data    = DF.auto,
		mapping = aes(x = acceleration, y = mpg),
		alpha   = 0.5,
		size    = 0.8,
		colour  = "red"
		);
	my.ggplot <- my.ggplot + geom_hline(
		mapping = aes(yintercept=median(DF.auto[['mpg']])),
		colour  = "green"
		);

	#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
	my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
	my.ggplot <- my.ggplot + theme(
		title       = element_text(size = 20),
		axis.title  = element_text(size = 25),
		axis.text   = element_text(size = 12),
		axis.text.x = element_text(size = 15, angle = 90)
		);
	
	temp.filename <- 'plot-mpg-vs-acceleration.png';
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	###################################################

	}

