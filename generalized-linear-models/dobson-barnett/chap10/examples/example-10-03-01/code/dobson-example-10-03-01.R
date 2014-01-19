
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.delim(
	file = paste0(data.directory,'/table-10-01-remission-times.csv'),
	sep  = '\t'
	);
DF.data[,'censor'] <- as.factor(DF.data[,'censor']);

str(DF.data);
DF.data;

####################################################################################################
km.estimate.single.group <- function(DF.input = NULL) {
	times <- unique(DF.input[,'time']);
	DF.output <- data.frame(
		time        = times,
		alive.up.to = numeric(length(times)),
		death.at    = numeric(length(times))
		);
	for (i in 1:nrow(DF.output)) {
		DF.output[i,'alive.up.to'] <- sum(DF.output[i,'time'] <= DF.input[,'time']);
		DF.output[i,'death.at']    <- sum(DF.output[i,'time'] == DF.input[,'time'] & '1' == DF.input[,'censor']);
		}
	DF.output <- DF.output[0 < DF.output[,'death.at'],];
	DF.output <- rbind(
		data.frame(time = 0, alive.up.to = nrow(DF.input), death.at = 0),
		DF.output
		);
	DF.output[,'km.pre.estimate'] <- (DF.output[,'alive.up.to'] - DF.output[,'death.at']) / DF.output[,'alive.up.to']
	DF.output[,'km.estimate'] <- cumprod(DF.output[,'km.pre.estimate']);
	return(DF.output);
	}

km.estimate <- function(DF.input = NULL) {
	groups <- unique(as.character(DF.input[,'group']));
	DF.output <- data.frame();
	for (group in groups) {
		DF.temp <- DF.input[group == DF.input[,'group'],];
		DF.temp <- km.estimate.single.group(DF.input = DF.temp);
		DF.temp <- cbind(
			group = factor(x = rep(group,nrow(DF.temp)), levels = levels(DF.input[,'group'])),
			DF.temp
			);
		DF.output <- rbind(DF.output,DF.temp);
		}
	rownames(DF.output) <- NULL;
	return(DF.output);
	}

####################################################################################################
### Figure 10.3

DF.KM.estimates <- km.estimate(DF.input = DF.data);
DF.KM.estimates;

resolution <- 200;
graphics.format <- 'png';
my.filename <- paste('figure-10-03',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-1,26),      breaks = seq(0,25,5));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-0.01,1.01), breaks = seq(0,1,0.1));
my.ggplot <- my.ggplot + geom_step(
        data    = DF.KM.estimates,
        mapping = aes(x = time, y = km.estimate, colour = group)
        );
ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        height = 0.5 * par("din")[1],
        dpi    = resolution,
        units  = 'in'
        );

####################################################################################################
### Figure 10.4

my.filename <- paste('figure-10-04',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-0.1,3.1), breaks = seq(0,3,0.5));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-2.6,2.6), breaks = seq(-2.5,2.5,0.5));
my.ggplot <- my.ggplot + geom_point(
        data    = DF.KM.estimates,
        mapping = aes(x = log(time), y = log(-log(km.estimate)), colour = group)
        );
ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        height = 0.5 * par("din")[1],
        dpi    = resolution,
        units  = 'in'
        );

####################################################################################################

q();

