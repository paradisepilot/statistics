
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(faraway);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 100;

####################################################################################################
data(orings);
orings;

####################################################################################################
setwd(output.directory);


results.lm <- lm(formula = damage/6 ~ temp, data = orings);
slope      <- coef(results.lm)[['temp']];
intercept  <- coef(results.lm)[['(Intercept)']];

temp.filename <- 'figure-02-01.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = temp, y = damage/6), data = orings);
my.ggplot <- my.ggplot + geom_abline(intercept = intercept, slope = slope);
#my.ggplot <- my.ggplot + stat_smooth(method = "lm", se = FALSE, data = orings);
my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,85), breaks = seq(0,80,10));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + xlab("temperature (Fahrenheit)");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

