
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

N  <- 300;
u1 <- 10;
u2 <- 30;
s1 <- 10;
s2 <- 10;

DF.output <- data.frame(n = numeric(N), pval = numeric(N));
for (n in 3:(N-3)) {
	temp.x = rnorm(n = n,     mean = u1, sd = s1);
	temp.y = rnorm(n = N - n, mean = u2, sd = s2);
	results.t.test <- t.test(x = temp.x, y = temp.y);
	DF.output[n,] <- c(n,results.t.test[['p.value']]);
	if (3 == (n %% 10)) {
		temp.filename <- paste0('simulated-data',n,'.png');
		DF.temp <- rbind(
			data.frame(value = temp.x, group = rep('A',length(temp.x)), stringsAsFactors = FALSE),
			data.frame(value = temp.y, group = rep('B',length(temp.y)), stringsAsFactors = FALSE)
			);
		print('str(DF.temp)');
		print( str(DF.temp) );
		DF.temp[,'group'] <- as.factor(DF.temp[,'group']);
		my.ggplot <- ggplot(data = NULL);
		my.ggplot <- my.ggplot + geom_point(mapping = aes(x = jitter(as.numeric(group)), y = value), data = DF.temp);
		#my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
		ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');
		}
	}
DF.output <- DF.output[DF.output[,1] > 0,];
DF.output[,'log10.pval'] <- log10(DF.output[,'pval']);

write.table(
	file      = 'rare-events.csv',
	x         = DF.output,
	sep       = '\t',
	quote     = FALSE,
	row.names = FALSE
	);

temp.filename <- 'pvalues.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = n, y = log10.pval), data = DF.output);
my.ggplot <- my.ggplot + xlab("size of first group");
my.ggplot <- my.ggplot + ylab("log10(p-value)");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

