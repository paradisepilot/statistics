
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### 4.8.2(a) #######################################################################################

### 4.8.2(b) #######################################################################################

### 4.8.2(c) #######################################################################################
DF.obns <- data.frame(
	male   = c(120, 107, 110, 116, 114, 111, 113, 117, 114, 112),
	female = c(110, 111, 107, 108, 110, 105, 107, 106, 111, 111)
	);

         n <- nrow(DF.obns);
  male.bar <- mean(DF.obns[,  'male']);
female.bar <- mean(DF.obns[,'female']);
  male.S   <- sum((DF.obns[,  'male'] -   male.bar)^2);
female.S   <- sum((DF.obns[,'female'] - female.bar)^2);

sample.size <- 1e+5;

male.sigma2.sample <- male.S / rchisq(n = sample.size, df = n - 1);
male.mu.sample <- rnorm(
	n    = sample.size,
	mean = male.bar,
	sd   = sqrt(male.sigma2.sample)/sqrt(n)
	);

female.sigma2.sample <- female.S / rchisq(n = sample.size, df = n - 1);
female.mu.sample <- rnorm(
	n    = sample.size,
	mean = female.bar,
	sd   = sqrt(female.sigma2.sample)/sqrt(n)
	);

delta.mu.sample <- male.mu.sample - female.mu.sample;
quantile(x = delta.mu.sample, probs = c(0.025,0.975));
sum(delta.mu.sample > 0) / length(delta.mu.sample);

png("Fig1_difference-of-means.png");
qplot(x = delta.mu.sample, geom = "histogram", binwidth = 0.1);
dev.off();

png("Fig2_mean-posterior-distributions.png");
DF.male <- data.frame(
	mean = male.mu.sample,
	sex  = factor(rep("male",length(male.mu.sample)),levels=c('male','female'))
	);
DF.female <- data.frame(
	mean = female.mu.sample,
	sex  = factor(rep("female",length(female.mu.sample)),levels=c('male','female'))
	);
DF.temp <- rbind(DF.male,DF.female);
qplot(data = DF.temp, x = mean, color = sex, geom = "density");
dev.off();

####################################################################################################
t.test(
	x           = DF.obns[,  'male'],
	y           = DF.obns[,'female'],
	alternative = "two.sided",
	mu          = 0,
	paired      = FALSE,
	var.equal   = FALSE,
	conf.level  = 0.95
	);

####################################################################################################
wilcox.test(
	x           = DF.obns[,  'male'],
	y           = DF.obns[,'female'],
	alternative = "two.sided",
	mu          = 0,
	paired      = FALSE,
	exact       = FALSE,
	correct     = TRUE,
	conf.int    = TRUE,
	conf.level  = 0.95
	);

