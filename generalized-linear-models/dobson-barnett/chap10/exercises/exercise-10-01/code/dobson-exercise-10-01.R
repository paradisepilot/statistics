
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(survival);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.delim(
	file = paste0(data.directory,'/table-10-04-leukemia-data.csv'),
	sep  = '\t'
	);
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = 'survival\\.time', replacement = 'time');
DF.data[,'AG'] <- factor(x = DF.data[,'AG'], levels = c('+','-'));
DF.data[,'censored'] <- rep(FALSE,nrow(DF.data));

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
		DF.output[i,'death.at']    <- sum(DF.output[i,'time'] == DF.input[,'time'] & FALSE == DF.input[,'censored']);
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
	groups <- unique(as.character(DF.input[,'AG']));
	DF.output <- data.frame();
	for (group in groups) {
		DF.temp <- DF.input[group == DF.input[,'AG'],];
		DF.temp <- DF.temp[order(DF.temp[,'time']),];
		DF.temp <- km.estimate.single.group(DF.input = DF.temp);
		DF.temp <- cbind(
			AG = factor(x = rep(group,nrow(DF.temp)), levels = levels(DF.input[,'AG'])),
			DF.temp
			);
		DF.output <- rbind(DF.output,DF.temp);
		}
	rownames(DF.output) <- NULL;
	return(DF.output);
	}

####################################################################################################
### Exercise 10.1(a)

DF.KM.estimates <- km.estimate(DF.input = DF.data);
DF.KM.estimates;

resolution <- 200;
graphics.format <- 'png';
my.filename <- paste('exercise-10-01-km-estimates',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-1,161), breaks = seq(0,160,10));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-0.01,1.01), breaks = seq(0,1,0.1));
my.ggplot <- my.ggplot + geom_step(
        data    = DF.KM.estimates,
        mapping = aes(x = time, y = km.estimate, colour = AG)
        );
ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        height = 0.5 * par("din")[1],
        dpi    = resolution,
        units  = 'in'
        );

####################################################################################################
### Exercise 10.1(b)

# goodness of fit diagnostics for Weibull models
my.filename <- paste('exercise-10-01-GOF-Weibull',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-0.1,5.6), breaks = seq(0,5.5,0.5));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-3.1,1.1), breaks = seq(-3,1,0.5));
my.ggplot <- my.ggplot + geom_point(
        data    = DF.KM.estimates,
        mapping = aes(x = log(time), y = log(-log(km.estimate)), colour = AG)
        );
ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        height = 0.5 * par("din")[1],
        dpi    = resolution,
        units  = 'in'
        );

surv.weibull <- survreg(Surv(time,censored) ~ AG + log(WBC), data = DF.data, dist = "weibull");
str(surv.weibull);
summary(surv.weibull);

q();

####################################################################################################

q();

