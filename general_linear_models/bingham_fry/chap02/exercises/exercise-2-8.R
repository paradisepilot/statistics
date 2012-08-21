
library(lattice);

### Using predefined functions lm() and anova() ####################################################
DF.soybeans <- data.frame(
	failures = c(
		 8, 2, 4, 3, 9,
		10, 6,10, 5, 7,
		12, 7, 9, 9, 5,
		13,11, 8,10, 5,
		11, 5,10, 6, 3
		),
	batch = c(
		rep("Rep1",5),
		rep("Rep2",5),
		rep("Rep3",5),
		rep("Rep4",5),
		rep("Rep5",5)
		),
	treatment = rep(c('Check','Arasan','Spergon','Semesan.Jr','Fermate'),5)
	);
str(DF.soybeans);
DF.soybeans;

LM.soybeans <- lm(
	formula = failures ~ batch + treatment,
	data    = DF.soybeans
	);

anova(LM.soybeans);

### Computing from first principle #################################################################
mean.overall <- mean(DF.soybeans[,'failures']);
mean.overall;

MAT.soybeans <- matrix(DF.soybeans[,'failures'], nrow = 5, ncol = 5);
rownames(MAT.soybeans) <- c('Check','Arasan','Spergon','Semesan.Jr','Fermate');
colnames(MAT.soybeans) <- paste("Rep",1:5,sep="");
MAT.soybeans;

num.of.treatments <- nrow(MAT.soybeans);
num.of.blocks     <- ncol(MAT.soybeans);

block.means <- colMeans(MAT.soybeans);
block.means;

treatment.means <- rowMeans(MAT.soybeans);
treatment.means;

MAT.temp <- MAT.soybeans;
MAT.temp <- t(apply(
	X      = MAT.temp,
	MARGIN = 1,
	FUN    = function(x) { return(x - block.means); }
	));
MAT.temp <- apply(
	X      = MAT.temp,
	MARGIN = 2,
	FUN    = function(x) { return(x - treatment.means); }
	);
MAT.temp <- MAT.temp + mean.overall;
MAT.temp;
SS.full.model <- sum(MAT.temp^2);
SS.full.model;

SS.treatment <- num.of.blocks     * sum((treatment.means - mean.overall)^2);
SS.block     <- num.of.treatments * sum((block.means     - mean.overall)^2);
SS.treatment;
SS.block;

df.treatment  <- num.of.treatments - 1;
df.block      <- num.of.blocks     - 1;
df.null.model <- num.of.treatments * num.of.blocks - 1;
df.full.model <- df.null.model - df.treatment - df.block;
df.full.model;

F.treatment <- (SS.treatment/df.treatment) / (SS.full.model/df.full.model);
F.block     <- (SS.block    /df.block)     / (SS.full.model/df.full.model);

F.treatment;
F.block;

pvalue.treatment <- pf(F.treatment,df1=df.treatment,df2=df.full.model,lower.tail=FALSE);
pvalue.block     <- pf(F.block,    df1=df.block,    df2=df.full.model,lower.tail=FALSE);

pvalue.treatment;
pvalue.block;

### Conclusion #####################################################################################
# If we take our significance threshold to be 0.05, then we conclude that
# (1)  there is significant treatment effect, but
# (2)  there is NOT significant block effect.
#

