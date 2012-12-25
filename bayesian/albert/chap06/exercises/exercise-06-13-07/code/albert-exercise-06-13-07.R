
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

### AUXILIARY FUNCTIONS ############################################################################
log.posterior.pre.density <- function(model.parameters = NULL, prior.and.data = NULL) {

	a0 <- prior.and.data[['prior']][['a0']];
	b0 <- prior.and.data[['prior']][['b0']];

	DF.data <- prior.and.data[['data']];
	w       <- DF.data[,'dosage'];
	y       <- DF.data[,'num.killed'];
	n       <- DF.data[,'num.exposed'];

	output <- NULL;
	if (is.null(dim(model.parameters))) {

		theta1 <- model.parameters[1];
		theta2 <- model.parameters[2];
		theta3 <- model.parameters[3];

		mu    <- theta1;
		sigma <- exp(theta2);
		m1    <- exp(theta3);

		x     <- (w - mu) / sigma;
		exp.x <- exp(x);
		p     <- (exp.x / (1 + exp.x)) ^ m1;

		if (0 == prod(p*(1-p))) {
			output <- -Inf;
			} else {
			temp   <- sum(y * log(p) + (n - y) * log(1 - p));
			output <- temp + a0 * theta3 - exp(theta3) / b0;
			}

		} else {

		theta1 <- model.parameters[,1];
		theta2 <- model.parameters[,2];
		theta3 <- model.parameters[,3];

		mu    <- theta1;
		sigma <- exp(theta2);
		m1    <- exp(theta3);

		output <- numeric(nrow(model.parameters));

		for (i in 1:length(output)) {
			x       <- (w - mu[i]) / sigma[i];
			exp.x   <- exp(x);
			p       <- (exp.x / (1 + exp.x)) ^ m1[i];

			#print("c(theta1[i],theta2[i],theta3[i])");
			#print( c(theta1[i],theta2[i],theta3[i]) );
			#print("cbind(x,exp.x,p)");
			#print( cbind(x,exp.x,p) );
			#print("prod(p*(1-p))");
			#print( prod(p*(1-p)) );

			if (0 == prod(p*(1-p))) {
				output[i] <- -Inf;
				} else {
				temp      <- sum(y * log(p) + (n - y) * log(1 - p));
				output[i] <- temp + a0 * theta3 - exp(theta3) / b0;
				}
			}

		}

	return(output);

	}

### Exercise 6.13.7(a,b,c,d) #######################################################################
prior.and.data <- list(
	prior = list(a0 = 0.25, b0 = 4),
	data = data.frame(
		dosage      = c(1.6907, 1.7242, 1.7552, 1.7842, 1.8113, 1.8369, 1.8610, 1.8839),
		num.killed  = c( 6, 13, 18, 28, 52, 53, 61, 60),
		num.exposed = c(59, 60, 62, 56, 63, 59, 62, 60)
		)
	);

dosage.mean <- mean(prior.and.data[['data']][,'dosage']);
dosage.sd   <-   sd(prior.and.data[['data']][,'dosage']);
dosage.mean;
dosage.sd;

temp.parameters <- c(0.23173484, -3.096383, -3.4627867141);
log.posterior.pre.density(
	#model.parameters = c(dosage.mean,log(dosage.sd),log(0.5)),
	model.parameters = temp.parameters,
	prior.and.data   = prior.and.data
	);

sample.size <- 5*(1e+4);  # 1e+5;  # 1e+6;

parameter.limits = as.matrix(t(data.frame(
        mu        = c(-3,3),
        log.sigma = c(-4.5,-2.5),
        log.m1    = c(-2,2),
        row.names = c('min','max')
        )));
parameter.limits;

bootstrap.sample <- generate.bootstrap.sample(
	sample.size            = sample.size,
	log.pre.density        = log.posterior.pre.density,
	parameter.limits       = parameter.limits,
	pre.density.parameters = prior.and.data
	);
bootstrap.sample <- as.data.frame(bootstrap.sample);
colnames(bootstrap.sample) <- c('mu','log.sigma','log.m1');
summary(bootstrap.sample);

### find posterior mode using laplace
laplace.results <- laplace(
	logpost = log.posterior.pre.density,
	mode = c(1.85,-4.25,-1.5),
	prior.and.data
	);
laplace.results;

### generate posterior sample using random walk Metropolis
sample.size <- 2*(1e+5);

### Exercise 6.13.7(b)
rwmetrop.results <- rwmetrop(
	logpost  = log.posterior.pre.density,
	proposal = list(
		var   = diag(diag(laplace.results[['var']])),
		scale = 2
		),
	start    = laplace.results[['mode']],
	m        = sample.size,
	prior.and.data
	);
str(rwmetrop.results);

rwmetrop.sample <- as.data.frame(rwmetrop.results[['par']]);
colnames(rwmetrop.sample) <- c('mu','log.sigma','log.m1');
rwmetrop.sample <- rwmetrop.sample[-c(1:5000),];
str(rwmetrop.sample);
summary(rwmetrop.sample);

### Exercise 6.13.7(c)
rwmetrop.results <- rwmetrop(
	logpost  = log.posterior.pre.density,
	proposal = list(
		var   = laplace.results[['var']],
		scale = 2
		),
	start    = laplace.results[['mode']],
	m        = sample.size,
	prior.and.data
	);
str(rwmetrop.results);

rwmetrop.sample.2 <- as.data.frame(rwmetrop.results[['par']]);
colnames(rwmetrop.sample.2) <- c('mu','log.sigma','log.m1');
rwmetrop.sample.2 <- rwmetrop.sample.2[-c(1:5000),];
str(rwmetrop.sample.2);
summary(rwmetrop.sample.2);

### Exercise 6.13.7(d)
### generate diagnostic plots
png("Fig01_mu-bootstrap-posterior-density.png");
my.levels <- c('bootstrap','rwmetrop','rwmetrop.2');
DF.bootstrap <- data.frame(
	mu     = bootstrap.sample[,'mu'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	mu     = rwmetrop.sample[,'mu'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.rwmetrop.2 <- data.frame(
	mu     = rwmetrop.sample.2[,'mu'],
	sample = factor(rep('rwmetrop.2',nrow(rwmetrop.sample.2)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop,DF.rwmetrop.2);
qplot(data = DF.temp, x = mu, color = sample, geom = "density");
dev.off();

png("Fig02_log-sigma-bootstrap-posterior-density.png");
my.levels <- c('bootstrap','rwmetrop','rwmetrop.2');
DF.bootstrap <- data.frame(
	log.sigma = bootstrap.sample[,'log.sigma'],
	sample    = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	log.sigma = rwmetrop.sample[,'log.sigma'],
	sample    = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.rwmetrop.2 <- data.frame(
	log.sigma = rwmetrop.sample.2[,'log.sigma'],
	sample    = factor(rep('rwmetrop.2',nrow(rwmetrop.sample.2)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop,DF.rwmetrop.2);
qplot(data = DF.temp, x = log.sigma, color = sample, geom = "density");
dev.off();

png("Fig03_log-m1-bootstrap-posterior-density.png");
my.levels <- c('bootstrap','rwmetrop','rwmetrop.2');
DF.bootstrap <- data.frame(
	log.m1 = bootstrap.sample[,'log.m1'],
	sample = factor(rep('bootstrap',nrow(bootstrap.sample)),levels=my.levels)
	);
DF.rwmetrop <- data.frame(
	log.m1 = rwmetrop.sample[,'log.m1'],
	sample = factor(rep('rwmetrop',nrow(rwmetrop.sample)),levels=my.levels)
	);
DF.rwmetrop.2 <- data.frame(
	log.m1 = rwmetrop.sample.2[,'log.m1'],
	sample = factor(rep('rwmetrop.2',nrow(rwmetrop.sample.2)),levels=my.levels)
	);
DF.temp <- rbind(DF.bootstrap,DF.rwmetrop,DF.rwmetrop.2);
qplot(data = DF.temp, x = log.m1, color = sample, geom = "density");
dev.off();

####################################################################################################

q();

