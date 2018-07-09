
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
require(LearnBayes);
require(ggplot2);
require(scales);
require(coda);
#require(sn);

source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

### AUXILIAR FUNCTIONS #############################################################################
log.posterior.grouped.data <- function(model.parameters = NULL, prior.and.data = NULL) {
        
	observed.frequencies  <- prior.and.data[['observations']][,'frequency'];
	interval.lower.bounds <- prior.and.data[['observations']][,'interval.lower.bound'];
	interval.upper.bounds <- prior.and.data[['observations']][,'interval.upper.bound'];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		mu    <- model.parameters[1];
		sigma <- exp(model.parameters[2]);

		temp <- pnorm(q = interval.upper.bounds, mean = mu, sd = sigma);
		temp <- temp - pnorm(q = interval.lower.bounds, mean = mu, sd = sigma);
		temp <- observed.frequencies * log(temp);

		output.value <- sum(temp);

		} else {

		mu    <- model.parameters[,1];
		sigma <- exp(model.parameters[,2]);

		output.value <- numeric(nrow(model.parameters));
		for (i in 1:length(output.value)) {

			temp <- pnorm(
				q    = interval.upper.bounds,
				mean = mu[i],
				sd   = sigma[i]
				);

			temp <- temp - pnorm(
				q    = interval.lower.bounds,
				mean = mu[i],
				sd   = sigma[i]
				);

			temp <- observed.frequencies * log(temp);

			output.value[i] <- sum(temp);

			}
		}

        return(output.value);

        }

### SECTION 6.8 ####################################################################################
prior.and.data <- list(
	observations = as.matrix(data.frame(
		interval.lower.bound = c(-Inf,seq(66,74,2)),
		interval.upper.bound = c(seq(66,74,2),Inf),
		frequency            = c(14,30,49,70,33,15)
		))
	);

laplace.results <- laplace(logpost = log.posterior.grouped.data, mode = c(70,1), prior.and.data);
laplace.results;

### Fig. 6.2, p.130
bad.start <- c(65,1);
bad.proposal.parameters <- list(var = laplace.results[['var']], scale = 0.2);
bad.fit <- rwmetrop(
	logpost  = log.posterior.grouped.data,
	proposal = bad.proposal.parameters,
	start    = bad.start,
	m        = 10000,
	prior.and.data
	);
str(bad.fit);

DF.bad.fit <- as.data.frame(bad.fit[['par']]);
DF.bad.fit <- cbind(
	iteration = 1:nrow(DF.bad.fit),
	DF.bad.fit
	);
colnames(DF.bad.fit) <- c('iteration','mu','log.sigma');

png("Fig6-02A.png");
par(mfrow=c(2,1));
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = DF.bad.fit,
	aes(x = iteration, y = mu)
	);
my.ggplot;
dev.off();

png("Fig6-02B.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = DF.bad.fit,
	aes(x = iteration, y = log.sigma)
	);
my.ggplot;
dev.off();

### Fig. 6.3, p.131
png("Fig6-03.png");
acf(
	x       = DF.bad.fit[-c(1:2000),c('mu','log.sigma')],
	lag.max = 36,
	type    = "correlation",
	plot    = TRUE
	);
dev.off();

### Fig. 6.4, p.132
good.start <- c(70,1);
good.proposal.parameters <- list(var = laplace.results[['var']], scale = 2);
good.fit <- rwmetrop(
	logpost  = log.posterior.grouped.data,
	proposal = good.proposal.parameters,
	start    = good.start,
	m        = 10000,
	prior.and.data
	);
str(good.fit);

DF.good.fit <- as.data.frame(good.fit[['par']]);
DF.good.fit <- cbind(
	iteration = 1:nrow(DF.good.fit),
	DF.good.fit
	);
colnames(DF.good.fit) <- c('iteration','mu','log.sigma');

png("Fig6-04A.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = DF.good.fit,
	aes(x = iteration, y = mu)
	);
my.ggplot;
dev.off();

png("Fig6-04B.png");
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data = DF.good.fit,
	aes(x = iteration, y = log.sigma)
	);
my.ggplot;
dev.off();

### Fig. 6.5, p.133
png("Fig6-05.png");
acf(
	x       = DF.good.fit[-c(1:2000),c('mu','log.sigma')],
	lag.max = 36,
	type    = "correlation",
	plot    = TRUE
	);
dev.off();

