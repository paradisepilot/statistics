
command.arguments <- commandArgs(trailingOnly = TRUE);
code.directory    <- normalizePath(command.arguments[1]);
output.directory  <- normalizePath(command.arguments[2]);
tmp.directory     <- normalizePath(command.arguments[3]);

####################################################################################################
library(ggplot2);

resolution <- 100;

####################################################################################################
generate.DF.output <- function(
	num.replicates = NULL,
	lambdas        = NULL,
	fold.change    = NULL,
	group          = NULL
	) {

	DF.output <- data.frame(
		lambda  = numeric(length(lambdas)),
		log2.FC = numeric(length(lambdas)),
		pval    = numeric(length(lambdas))
		);

	for (i in 1:length(lambdas)) {

		temp.mean   <- lambdas[i];
		temp.factor <- fold.change;
		if (0.5 < sample(x = c(0,1), size = 1)) { temp.factor <- 1/temp.factor; }

		lambda0 <- rnorm(n = num.replicates, mean =               temp.mean, sd =               temp.mean/100);
		lambda1 <- rnorm(n = num.replicates, mean = temp.factor * temp.mean, sd = temp.factor * temp.mean/100);

		obs0 <- rpois(n = num.replicates, lambda = lambda0);
		obs1 <- rpois(n = num.replicates, lambda = lambda1);

		DF.data <- rbind(
			data.frame(count = obs0, group = rep('A',length(obs0))),
			data.frame(count = obs1, group = rep('B',length(obs1)))
			);

		results.glm   <- glm(formula = count ~ group, data = DF.data, family = 'poisson');
		results.anova <- anova(results.glm,test='LRT');

		temp.pvalue   <- results.anova[['Pr(>Chi)']][2];
		temp.log2.FC  <- log2(mean(obs1)/mean(obs0));
		DF.output[i,] <- c(temp.mean,temp.log2.FC,temp.pvalue);

		}

	DF.output[,'minus.log10.pval'] <- -log10(DF.output[,'pval']);
	DF.output <- cbind(DF.output, group = factor(rep(group,nrow(DF.output))));

	return(DF.output);

	}

####################################################################################################
setwd(output.directory);

####################################################################################################
num.replicates <- 5;
lambdas        <- seq(1000,2e6,1000);
fold.change    <- 1;

DF.output.0 <- generate.DF.output(
	num.replicates = num.replicates,
	lambdas        = lambdas,
	fold.change    = fold.change,
	group          = paste0('FC = ',fold.change)
	);

####################################################################################################
num.replicates <- 5;
lambdas        <- seq(1000,2e6,1000);
fold.change    <- 1.01;

DF.output.1 <- generate.DF.output(
	num.replicates = num.replicates,
	lambdas        = lambdas,
	fold.change    = fold.change,
	group          = paste0('FC = ',fold.change)
	);

####################################################################################################
num.replicates <- 5;
lambdas        <- seq(10,100,1);
fold.change    <- 2;

DF.output.2 <- generate.DF.output(
	num.replicates = num.replicates,
	lambdas        = lambdas,
	fold.change    = fold.change,
	group          = paste0('FC = ',fold.change)
	);

####################################################################################################
num.replicates <- 5;
lambdas        <- seq(10,100,1);
fold.change    <- 3;

DF.output.3 <- generate.DF.output(
	num.replicates = num.replicates,
	lambdas        = lambdas,
	fold.change    = fold.change,
	group          = paste0('FC = ',fold.change)
	);

####################################################################################################
num.replicates <- 5;
lambdas        <- seq(10,100,1);
fold.change    <- 4;

DF.output.4 <- generate.DF.output(
	num.replicates = num.replicates,
	lambdas        = lambdas,
	fold.change    = fold.change,
	group          = paste0('FC = ',fold.change)
	);

####################################################################################################
DF.output <- rbind(DF.output.0,DF.output.1,DF.output.2,DF.output.3,DF.output.4);
write.table(
	file      = 'rare-events-count-data.csv',
	x         = DF.output,
	sep       = '\t',
	quote     = FALSE,
	row.names = FALSE
	);

####################################################################################################
temp.filename <- 'pvalues.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = lambda, y = minus.log10.pval, colour = group), data = DF.output, alpha = 0.5);
my.ggplot <- my.ggplot + xlab(expression(mu[0]));
my.ggplot <- my.ggplot + ylab(expression('- log'[10]('p-value'))); #ylab("-log10(p-value)");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
temp.filename <- 'volcanoplot.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = log2.FC, y = minus.log10.pval, colour = group), data = DF.output, alpha = 0.5);
my.ggplot <- my.ggplot + xlab(expression('log'[2]('FC')));         #xlab("log2(FC)");
my.ggplot <- my.ggplot + ylab(expression('- log'[10]('p-value'))); #ylab("-log10(p-value)");
my.ggplot <- my.ggplot + scale_x_continuous(limits = 3.0 * c(-1,1));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

