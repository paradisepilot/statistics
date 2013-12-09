
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(faraway);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
data(teengamb);

teengamb[,'sex'] <- as.factor(teengamb[,'sex']);
#str(teengamb);
#summary(teengamb);
#teengamb;

####################################################################################################
lm.results <- lm(formula = gamble ~ sex + status + income + verbal, data = teengamb);
summary(lm.results);

### (a) ############################################################################################
### The percentage of variation in the response explained by these predictors is the
### "multiple R-squared", which has value 0.5267, i.e. 52.67%

### (b) ############################################################################################
temp <- residuals(lm.results);
cbind(1:length(temp),temp);
which(temp == max(temp));

### (c) ############################################################################################
mean(temp);
median(temp);

### (d) ############################################################################################
cor(residuals(lm.results),fitted(lm.results));

### (e) ############################################################################################
cor(residuals(lm.results),lm.results[['model']][,'income']);

### (f) ############################################################################################
summary(lm.results);

####################################################################################################

q();

