
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

### manual verification
X <- as.matrix(cbind(
	intercept = rep(1,nrow(DF.data)),DF.data[,c('displacement','transmission.type')]
	));

y.hat   <- X %*% solve(t(X) %*% X) %*% t(X) %*% DF.data[,'mileage'];
SS.full <- sum((DF.data[,'mileage'] - y.hat)^2);
MS.full <- SS.full / (nrow(X) - ncol(X));

ones <- matrix(X[,1],ncol=1);
y.hat.grand.mean <- ones %*% solve(t(ones) %*% ones) %*% t(ones) %*% DF.data[,'mileage'];
SS.grand.mean <- sum((DF.data[,'mileage'] - y.hat.grand.mean)^2);

betas.hat    <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'mileage'];
betas.sd.hat <- sqrt(MS.full * diag(solve(t(X) %*% X)));
t.stats      <- betas.hat / betas.sd.hat;
p.values     <- 2 * pt(q = t.stats, df = nrow(X) - ncol(X));
cbind(betas = betas.hat, stddev = betas.sd.hat,t.stat = t.stats, pval = p.values);
F.stat <- ((SS.grand.mean - SS.full)/(ncol(X)-1)) / (SS.full/(nrow(X)-ncol(X)))
F.stat;
pf(q = F.stat, df1 = ncol(X)-1, df2 = nrow(X)-ncol(X), lower.tail = FALSE);
1 - SS.full / SS.grand.mean;
1 - (SS.full/(nrow(X)-ncol(X))) / (SS.grand.mean/(nrow(X)-1));
summary(lm.full);

X.reduced <- as.matrix(cbind(
	intercept = rep(1,nrow(DF.data)),DF.data[,'displacement']
	));

y.hat.reduced   <- X.reduced %*% solve(t(X.reduced) %*% X.reduced) %*% t(X.reduced) %*% DF.data[,'mileage'];
SS.reduced <- sum((DF.data[,'mileage'] - y.hat.reduced)^2);
SS.reduced;

F.stat <- ((SS.reduced - SS.full)/1) / MS.full;
F.stat;

F.pvalue <- pf(q = F.stat, df1 = 1, df2 = nrow(X) - ncol(X), lower.tail = FALSE);
F.pvalue;

anova(lm.reduced,lm.full);

### GRAPHICS (a) ###################################################################################
DF.temp <- DF.data[,c('mileage','displacement','transmission.type')];
DF.temp[,'transmission.type'] <- as.factor(DF.temp[,'transmission.type']);
DF.temp[order(DF.temp[,'displacement']),];

resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('problem-08-04',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-20,620);
my.ggplot <- my.ggplot + ylim(0,50);
my.ggplot <- my.ggplot + geom_point(
        data     = DF.temp,
        mapping  = aes(x = displacement, y = mileage, col = transmission.type)
        );
temp.x <- seq(-20,620,1);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(x = temp.x, y = betas.hat[1] + betas.hat[2] * temp.x),
	mapping = aes(x = x, y = y)
	);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(x = temp.x, y = betas.hat[1]+betas.hat[3]+betas.hat[2]*temp.x),
	mapping = aes(x = x, y = y)
	);
ggsave(file = my.filename, plot = my.ggplot, height = 0.5 * par("din")[1], dpi = resolution, units = 'in');

### (b) ############################################################################################
### manual verification
X <- as.matrix(cbind(
	intercept = rep(1,nrow(DF.data)),DF.data[,c('displacement','transmission.type')]
	));
X <- as.matrix(cbind(
	X,displacement_transmission.type = X[,'displacement'] * X[,'transmission.type']
	));
#X;

y.hat   <- X %*% solve(t(X) %*% X) %*% t(X) %*% DF.data[,'mileage'];
SS.full <- sum((DF.data[,'mileage'] - y.hat)^2);
SS.full;
MS.full <- SS.full / (nrow(X) - ncol(X));

betas.hat <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'mileage'];
betas.sd.hat <- sqrt(MS.full * diag(solve(t(X) %*% X)));
t.stats      <- betas.hat / betas.sd.hat;
p.values     <- 2 * pt(q = t.stats, df = nrow(X) - ncol(X));

cbind(betas = betas.hat, stddev = betas.sd.hat,t.stat = t.stats, pval = p.values);

### using R built-in functions
lm.full <- lm(
	formula = mileage ~ displacement + transmission.type + displacement*transmission.type,
	data    = DF.data
	);

lm.reduced <- lm(
	formula = mileage ~ displacement,
	data    = DF.data
	);

summary(lm.full);
anova(lm.reduced,lm.full);

### GRAPHICS (b) ###################################################################################
DF.temp <- DF.data[,c('mileage','displacement','transmission.type')];
DF.temp[,'transmission.type'] <- as.factor(DF.temp[,'transmission.type']);
DF.temp[order(DF.temp[,'displacement']),];

resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('problem-08-04-interaction',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-20,620);
my.ggplot <- my.ggplot + ylim(0,50);
my.ggplot <- my.ggplot + geom_point(
        data     = DF.temp,
        mapping  = aes(x = displacement, y = mileage, col = transmission.type)
        );
temp.x <- seq(-20,620,1);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(x = temp.x, y = betas.hat[1] + betas.hat[2] * temp.x),
	mapping = aes(x = x, y = y)
	);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(x = temp.x, y = betas.hat[1]+betas.hat[3]+(betas.hat[2]+betas.hat[4])*temp.x),
	mapping = aes(x = x, y = y)
	);
ggsave(file = my.filename, plot = my.ggplot, height = 0.5 * par("din")[1], dpi = resolution, units = 'in');

