
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(MPV);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
#DF.data <- read.table(
#	file      = paste0(data.directory,'/chap08/examples/data-example-8-1-Tool-Life.csv'),
#	row.names = 1,
#	header    = TRUE,
#	sep       = '\t',
#	quote     = ""
#	);
#colnames(DF.data) <- c('effective.life','revolution.speed','tool.type');
DF.data <- table.b3;

colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^y$',   replacement = 'mileage');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x1$',  replacement = 'displacement');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x2$',  replacement = 'horsepower');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x3$',  replacement = 'torque');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x4$',  replacement = 'compression.ratio');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x5$',  replacement = 'rear.axle.ratio');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x6$',  replacement = 'carburetor');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x7$',  replacement = 'num.trans.speeds');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x8$',  replacement = 'length');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x9$',  replacement = 'width');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x10$', replacement = 'weight');
colnames(DF.data) <- gsub(x = colnames(DF.data), pattern = '^x11$', replacement = 'transmission.type');

str(DF.data);

### data correction: downloaded data were differ from those in text.
### here, we correct the downloaded data to those in the text.
#DF.data[7,'revolution.speed'] <- 680;

### (a) ############################################################################################
lm.full <- lm(
	formula = mileage ~ displacement + transmission.type,
	data    = DF.data
	);

lm.reduced <- lm(
	formula = mileage ~ displacement,
	data    = DF.data
	);

summary(lm.full);
anova(lm.reduced,lm.full);

### The above shows that transmission type does NOT significantly affect mileage performance,
### at least in the model with only engine displacement as the other predictor variable.

### There is no difference whether 'transmission.type' is converted to a factor or not:
DF.temp <- DF.data;
DF.temp[,'transmission.type'] <- as.factor(DF.temp[,'transmission.type']);
str(DF.temp);

lm.full <- lm(
	formula = mileage ~ displacement + transmission.type,
	data    = DF.temp
	);
summary(lm.full);

### manual verification
X <- as.matrix(cbind(
	intercept = rep(1,nrow(DF.data)),DF.data[,c('displacement','transmission.type')]
	));

betas.hat <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'mileage'];
betas.hat;

y.hat   <- X %*% solve(t(X) %*% X) %*% t(X) %*% DF.data[,'mileage'];
SS.full <- sum((DF.data[,'mileage'] - y.hat)^2);
SS.full;
MS.full <- SS.full / (nrow(DF.data) - 3);

betas.sd.hat <- sqrt(MS.full * diag(solve(t(X) %*% X)));
betas.sd.hat;

t.stats <- betas.hat / betas.sd.hat;
t.stats;

p.values <- 2 * pt(q = t.stats, df = nrow(DF.data) - 3);
p.values;

X.reduced <- as.matrix(cbind(
	intercept = rep(1,nrow(DF.data)),DF.data[,'displacement']
	));

y.hat.reduced   <- X.reduced %*% solve(t(X.reduced) %*% X.reduced) %*% t(X.reduced) %*% DF.data[,'mileage'];
SS.reduced <- sum((DF.data[,'mileage'] - y.hat.reduced)^2);
SS.reduced;

F.stat <- ((SS.reduced - SS.full)/1) / MS.full;
F.stat;

F.pvalue <- pf(q = F.stat, df1 = 1, df2 = nrow(DF.data) - 3, lower.tail = FALSE);
F.pvalue;

