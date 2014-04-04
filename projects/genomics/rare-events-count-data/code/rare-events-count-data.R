
command.arguments <- commandArgs(trailingOnly = TRUE);
code.directory    <- normalizePath(command.arguments[1]);
output.directory  <- normalizePath(command.arguments[2]);
tmp.directory     <- normalizePath(command.arguments[3]);

####################################################################################################
#library(RMySQL);
library(ggplot2);

#source(paste0(code.directory,'/get-transplant-life-table.R'));

resolution <- 100;

####################################################################################################
setwd(output.directory);

X  <- paste0('x',1:3);
Y  <- paste0('y',1:2);
XY <- expand.grid(X,Y);
colnames(XY) <- c('X','Y');

prob.independent <- c( 8,12,20,12,18,30);
prob.perturb     <- c( 1, 1,-2, 2,-1,-1);
DF.prob          <- cbind(XY, prob = prob.independent + 5*prob.perturb);

sizes <- seq(10,10000,10);
DF.output <- data.frame(size = numeric(length(sizes)), pval = numeric(length(sizes)));
for (i in 1:length(sizes)) {
	temp.size     <- sizes[i];
	DF.temp       <- cbind(XY, Z = rmultinom(n = 1, size = temp.size, prob = DF.prob[,'prob']));
	results.glm   <- glm(formula = Z ~ X + Y + X:Y, data = DF.temp, family = 'poisson');
	results.anova <- anova(results.glm,test='LRT');
	temp.pvalue   <- results.anova[['Pr(>Chi)']][4];
	DF.output[i,] <- c(temp.size,temp.pvalue);
	}
DF.output[,'log10.pval'] <- log10(DF.output[,'pval']);

write.table(
	file      = 'rare-events-count-data.csv',
	x         = DF.output,
	sep       = '\t',
	quote     = FALSE,
	row.names = FALSE
	);

temp.filename <- 'pvalues.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = size, y = log10.pval), data = DF.output);
my.ggplot <- my.ggplot + xlab("size of first group");
my.ggplot <- my.ggplot + ylab("log10(p-value)");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

