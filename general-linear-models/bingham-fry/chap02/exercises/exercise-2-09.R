
library(lattice);

### Using predefined functions lm() and anova() ####################################################
DF.photoperiod <- data.frame(
	growth = c(
		2,3,1,1,2,1,
		3,4,2,1,2,1,
		3,5,1,2,2,2,
		4,6,2,2,2,3
		),
	photoperiod = c(rep("very.short",6),rep("short",6),rep("long",6),rep("very.long",6)),
	genotype    = rep(c('A','B','C','D','E','F'),4)
	);
str(DF.photoperiod);
DF.photoperiod;

LM.photoperiod <- lm(
	formula = growth ~ photoperiod + genotype,
	data    = DF.photoperiod
	);

anova(LM.photoperiod);

# plot the fat absorbed data, stratified by fat type:
pdf("exercise-2-09_dotplot-photoperiod.pdf");
dotplot(
	growth ~ photoperiod | genotype,
	data = DF.photoperiod
	);
dev.off();


### Computing from first principle #################################################################
mean.overall <- mean(DF.photoperiod[,'growth']);
mean.overall;

MAT.photoperiod <- matrix(DF.photoperiod[,'growth'], nrow = 6, ncol = 4);
rownames(MAT.photoperiod) <- c('A','B','C','D','E','F');
colnames(MAT.photoperiod) <- c("very.short","short","long","very.long");
MAT.photoperiod;

num.of.genotypes    <- nrow(MAT.photoperiod);
num.of.photoperiods <- ncol(MAT.photoperiod);

photoperiod.means <- colMeans(MAT.photoperiod);
photoperiod.means;

genotype.means <- rowMeans(MAT.photoperiod);
genotype.means;

MAT.temp <- MAT.photoperiod;
MAT.temp <- t(apply(
	X      = MAT.temp,
	MARGIN = 1,
	FUN    = function(x) { return(x - photoperiod.means); }
	));
MAT.temp <- apply(
	X      = MAT.temp,
	MARGIN = 2,
	FUN    = function(x) { return(x - genotype.means); }
	);
MAT.temp <- MAT.temp + mean.overall;
MAT.temp;
SS.full.model <- sum(MAT.temp^2);
SS.full.model;

SS.genotype    <- num.of.photoperiods * sum((genotype.means    - mean.overall)^2);
SS.photoperiod <- num.of.genotypes    * sum((photoperiod.means - mean.overall)^2);
SS.genotype;
SS.photoperiod;

df.genotype    <- num.of.genotypes    - 1;
df.photoperiod <- num.of.photoperiods - 1;
df.null.model  <- num.of.genotypes * num.of.photoperiods - 1;
df.full.model  <- df.null.model - df.genotype - df.photoperiod;
df.full.model;

F.genotype    <- (SS.genotype   /df.genotype)    / (SS.full.model/df.full.model);
F.photoperiod <- (SS.photoperiod/df.photoperiod) / (SS.full.model/df.full.model);

F.genotype;
F.photoperiod;

pvalue.genotype    <- pf(F.genotype,   df1=df.genotype,   df2=df.full.model,lower.tail=FALSE);
pvalue.photoperiod <- pf(F.photoperiod,df1=df.photoperiod,df2=df.full.model,lower.tail=FALSE);

pvalue.genotype;
pvalue.photoperiod;

### Conclusion #####################################################################################
# If we take our significance threshold to be 0.05, then we conclude that
# (1)  there is significant evidence for non-trivial genotype effect, and
# (2)  there is significant evidence for non-trivial photoperiod effect.
#

