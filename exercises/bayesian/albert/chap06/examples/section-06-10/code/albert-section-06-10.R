
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
log.posterior.stanfordheart <- function(model.parameters = NULL, prior.and.data = NULL) {

	is.transplant <- rep(FALSE,nrow(prior.and.data[['data']]));
	is.transplant[prior.and.data[['data']][,'transplant']==1] <- TRUE;

	is.alive <- rep(FALSE,nrow(prior.and.data[['data']]));
	is.alive[prior.and.data[['data']][,'state']==1] <- TRUE;

	DF.transplant.alive    <- prior.and.data[['data']][is.transplant & is.alive,];
	DF.transplant.deceased <- prior.and.data[['data']][is.transplant & (!is.alive),];

	DF.nontransplant.alive    <- prior.and.data[['data']][(!is.transplant) & is.alive,];
	DF.nontransplant.deceased <- prior.and.data[['data']][(!is.transplant) & (!is.alive),];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		tau    <- exp(model.parameters[1]);
		lambda <- exp(model.parameters[2]);
		p      <- exp(model.parameters[3]);

		y <- DF.transplant.alive[,'timetotransplant'];
		z <- DF.transplant.alive[,'survtime'];
		temp.transplant.alive <- sum(p * (log(lambda) - log(lambda + y + tau * z)));

		y <- DF.transplant.deceased[,'timetotransplant'];
		z <- DF.transplant.deceased[,'survtime'];
		temp.transplant.deceased <- sum(
			log(tau) + log(p) + p * log(lambda) - (p + 1) * log(lambda + y + tau * z)
			);

		x <- DF.nontransplant.alive[,'survtime'];
		temp.nontransplant.alive <- sum(p * (log(lambda) - log(lambda + x)));

		x <- DF.nontransplant.deceased[,'survtime'];
		temp.nontransplant.deceased <- sum(
			log(p) + p * log(lambda) - (p + 1) * log(lambda + x)
			);

		output.value <- sum(model.parameters);
		output.value <- output.value + (temp.transplant.alive + temp.transplant.deceased +
			temp.nontransplant.alive + temp.nontransplant.deceased);

		} else {

		tau    <- exp(model.parameters[,1]);
		lambda <- exp(model.parameters[,2]);
		p      <- exp(model.parameters[,3]);

		output.value <- numeric(nrow(model.parameters));
		for (i in 1:length(output.value)) {

			y <- DF.transplant.alive[,'timetotransplant'];
			z <- DF.transplant.alive[,'survtime'];
			temp.transplant.alive <- sum(
				p[i] * (log(lambda[i]) - log(lambda[i] + y + tau[i] * z))
				);

			y <- DF.transplant.deceased[,'timetotransplant'];
			z <- DF.transplant.deceased[,'survtime'];
			temp.transplant.deceased <- sum(
				log(tau[i]) + log(p[i]) + p[i] * log(lambda[i])
				- (p[i] + 1) * log(lambda[i] + y + tau[i] * z)
				);

			x <- DF.nontransplant.alive[,'survtime'];
			temp.nontransplant.alive <- sum(
				p[i] * (log(lambda[i]) - log(lambda[i] + x))
				);

			x <- DF.nontransplant.deceased[,'survtime'];
			temp.nontransplant.deceased <- sum(
				log(p[i]) + p[i] * log(lambda[i]) - (p[i] + 1) * log(lambda[i] + x)
				);

			output.value[i] <- sum(model.parameters[i,]);
			output.value[i] <- output.value[i] + (temp.transplant.alive
				+ temp.transplant.deceased + temp.nontransplant.alive
				+ temp.nontransplant.deceased);

			}

		}

        return(output.value);

        }

### SECTION 6.10 ###################################################################################
prior.and.data <- list(data = LearnBayes::stanfordheart);
start.point    <- c(0,3,-1);

parameter.limits = as.matrix(t(data.frame(
	log.tau    = c(-3,3),
	log.lambda = c(0.5,7),
	log.p      = c(-3,3),
	row.names  = c('min','max')
	)));
parameter.limits;

bootstrap.sample <- generate.bootstrap.sample(
	sample.size            = 2 * (1e+6),
	log.pre.density        = log.posterior.stanfordheart,
	parameter.limits       = parameter.limits,
	pre.density.parameters = prior.and.data
	);
str(bootstrap.sample);
summary(bootstrap.sample);

laplace.results <- laplace(
	logpost = log.posterior.stanfordheart,
	mode    = start.point,
	prior.and.data
	);
laplace.results;

rwmetrop.proposal.parameters <- list(var = laplace.results[['var']], scale = 2);
rwmetrop.results <- rwmetrop(
	logpost  = log.posterior.stanfordheart,
	proposal = rwmetrop.proposal.parameters,
	start    = start.point,
	m        = 1e+6,
	prior.and.data
	);
str(rwmetrop.results);
rw.metropolis.sample <- rwmetrop.results[['par']];
colnames(rw.metropolis.sample) <- c('log.tau','log.lambda','log.p');
summary(rw.metropolis.sample);

### Fig. 6.11, p.143 ###############################################################################
png("Fig6-11_tau.png");
my.levels <- c('bootstrap','rw.metropolis');
DF.bootstrap <- data.frame(
	tau    = exp(bootstrap.sample[,'log.tau']),
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rw.metropolis <- data.frame(
	tau    = exp(rw.metropolis.sample[,'log.tau']),
	sample = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rw.metropolis);
qplot(data = DF.temp, x = tau, colour = sample, geom = "density");
dev.off();

png("Fig6-11_log-tau.png");
my.levels <- c('bootstrap','rw.metropolis');
DF.bootstrap <- data.frame(
	log.tau = bootstrap.sample[,'log.tau'],
	sample  = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rw.metropolis <- data.frame(
	log.tau = rw.metropolis.sample[,'log.tau'],
	sample  = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rw.metropolis);
qplot(data = DF.temp, x = log.tau, colour = sample, geom = "density");
dev.off();

png("Fig6-11_lambda.png");
my.levels <- c('bootstrap','rw.metropolis');
DF.bootstrap <- data.frame(
	lambda = exp(bootstrap.sample[,'log.lambda']),
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rw.metropolis <- data.frame(
	lambda = exp(rw.metropolis.sample[,'log.lambda']),
	sample = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rw.metropolis);
qplot(data = DF.temp, x = lambda, colour = sample, geom = "density");
dev.off();

png("Fig6-11_log-lambda.png");
my.levels <- c('bootstrap','rw.metropolis');
DF.bootstrap <- data.frame(
	log.lambda = bootstrap.sample[,'log.lambda'],
	sample     = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rw.metropolis <- data.frame(
	log.lambda = rw.metropolis.sample[,'log.lambda'],
	sample     = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rw.metropolis);
qplot(data = DF.temp, x = log.lambda, colour = sample, geom = "density");
dev.off();

png("Fig6-11_p.png");
my.levels <- c('bootstrap','rw.metropolis');
DF.bootstrap <- data.frame(
	p      = exp(bootstrap.sample[,'log.p']),
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rw.metropolis <- data.frame(
	p      = exp(rw.metropolis.sample[,'log.p']),
	sample = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rw.metropolis);
qplot(data = DF.temp, x = p, colour = sample, geom = "density");
dev.off();

png("Fig6-11_log-p.png");
my.levels <- c('bootstrap','rw.metropolis');
DF.bootstrap <- data.frame(
	log.p  = bootstrap.sample[,'log.p'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rw.metropolis <- data.frame(
	log.p  = rw.metropolis.sample[,'log.p'],
	sample = factor(rep('rw.metropolis',nrow(rw.metropolis.sample)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rw.metropolis);
qplot(data = DF.temp, x = log.p, colour = sample, geom = "density");
dev.off();

### Fig. 6.12, p.145 ###############################################################################
lambda.sample <- exp(bootstrap.sample[,'log.lambda']);
p.sample      <- exp(bootstrap.sample[,'log.p']);

time.points <- seq(1,240);

DF.survival <- as.data.frame(matrix(nrow=length(time.points),ncol=4));
colnames(DF.survival) <- c('time.point','p05','p50','p95');
DF.survival[,'time.point'] <- time.points;

for (i in 1:nrow(DF.survival)) {
	S <- ( lambda.sample / (lambda.sample + DF.survival[i,'time.point']) ) ^ p.sample;
	DF.survival[i,c('p05','p50','p95')] <- quantile(x = S, probs = c(0.05,0.50,0.95));
	}

png("Fig6-12.png");
my.levels   <- c('p95','p50','p05');
my.colnames <- c('time.point','survival.probability','quantile');
DF.p05 <- data.frame(
	DF.survival[,c('time.point','p05')],
	quantile = factor(rep('p05',nrow(DF.survival)),levels=my.levels)
	);
colnames(DF.p05) <- my.colnames;
DF.p50 <- data.frame(
	DF.survival[,c('time.point','p50')],
	quantile = factor(rep('p50',nrow(DF.survival)),levels=my.levels)
	);
colnames(DF.p50) <- my.colnames;
DF.p95 <- data.frame(
	DF.survival[,c('time.point','p95')],
	quantile = factor(rep('p95',nrow(DF.survival)),levels=my.levels)
	);
colnames(DF.p95) <- my.colnames;
DF.temp <- rbind(DF.p05,DF.p50,DF.p95);
print(summary(DF.temp))
qplot(
	data   = DF.temp,
	x      = time.point,
	y      = survival.probability,
	colour = quantile,
	ylim   = c(0,1),
	geom   = "line"
	);
dev.off();

####################################################################################################

q();

