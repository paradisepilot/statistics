
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
DF.data <- read.table(
	file      = paste0(data.directory,'/chap08/examples/data-example-8-1-Tool-Life.csv'),
	row.names = 1,
	header    = TRUE,
	sep       = '\t',
	quote     = ""
	);
colnames(DF.data) <- c('effective.life','revolution.speed','tool.type');
str(DF.data);

### data correction: downloaded data were differ from those in text.
### here, we correct the downloaded data to those in the text.
DF.data[7,'revolution.speed'] <- 680;

####################################################################################################
lm.full <- lm(
	formula = effective.life ~ revolution.speed + tool.type + revolution.speed * tool.type,
	data    = DF.data
	);
summary(lm.full);

### VERIFICATION OF REGRESSION RESULTS #############################################################
X <- cbind(rep(1,nrow(DF.data)),DF.data[,'revolution.speed'],-1+as.integer(DF.data[,'tool.type']));
X <- cbind(X,X[,2]*X[,3]);
cbind(X,DF.data[,'effective.life']);

betas <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'effective.life'];
betas;

sigma2.hat <- sum(residuals(lm.full)^2) / (nrow(DF.data) - 4);
sigma2.hat;

V.beta.hat <- sigma2.hat * solve(t(X) %*% X);
V.beta.hat;
sqrt(diag(V.beta.hat));

### t-test for beta1:
t.stat <- betas[2] / sqrt(diag(V.beta.hat))[2];
t.stat;
2 * pt(q = t.stat, df = nrow(DF.data) - 4, lower.tail = TRUE);

### t-test for beta2:
t.stat <- betas[3] / sqrt(diag(V.beta.hat))[3];
t.stat;
2 * pt(q = t.stat, df = nrow(DF.data) - 4, lower.tail = FALSE);

### t-test for beta3:
t.stat <- betas[4] / sqrt(diag(V.beta.hat))[4];
t.stat;
2 * pt(q = t.stat, df = nrow(DF.data) - 4, lower.tail = TRUE);

summary(lm.full);

### VERIFICATION OF ANOVA RESULTS ##################################################################
SS.full <- sum(residuals(lm.full)^2);
SS.full;

SS.grand.mean <- sum((DF.data[,'effective.life'] - mean(DF.data[,'effective.life']))^2);
SS.grand.mean;

MS.full <- SS.full / (nrow(DF.data) - 4);
MS.full;

F.stat <- ((SS.grand.mean - SS.full)/3) / MS.full;
F.stat;

pf(q = F.stat, df1 = 3, df2 = nrow(DF.data) - 4, lower.tail = FALSE);

lm.null <- lm(formula = effective.life ~ 1, data    = DF.data);
anova(lm.null,lm.full);

####################################################################################################
lm.zeroBeta3  <- lm(formula = effective.life ~ revolution.speed + tool.type, data = DF.data);
lm.zeroBeta23 <- lm(formula = effective.life ~ revolution.speed, data = DF.data);
lm.zeroBeta1  <- lm(formula = effective.life ~ tool.type, data = DF.data);
anova(lm.full);
anova(lm.null,lm.zeroBeta23);
anova(lm.zeroBeta23, lm.zeroBeta3);
anova(lm.zeroBeta3, lm.full);

####################################################################################################
resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('figure-08-05',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + ylim(0,50);
my.ggplot <- my.ggplot + geom_point(
        data     = DF.data,
        mapping  = aes(x = revolution.speed, y = effective.life, col = tool.type)
        );
temp.x <- seq(480,1020,1);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(x = temp.x, y = betas[1] + betas[2] * temp.x),
	mapping = aes(x = x, y = y)
	);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(x = temp.x, y = betas[1]+betas[3]+(betas[2]+betas[4])*temp.x),
	mapping = aes(x = x, y = y)
	);
ggsave(file = my.filename, plot = my.ggplot, height = 0.5 * par("din")[1], dpi = resolution, units = 'in');

####################################################################################################

q();

