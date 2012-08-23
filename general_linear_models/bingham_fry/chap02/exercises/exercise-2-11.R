
library(lattice);

### Define data ####################################################################################
DF.rats <- data.frame(matrix(nrow=0,ncol=3));
colnames(DF.rats) <- c('weight.gain','protein.source','protein.level');
str(DF.rats);
DF.rats;

DF.rats <- rbind(DF.rats,data.frame(weight.gain = c( 73,102,118,104, 81,107,100, 87,117,111), protein.source  = rep('beef',  10), protein.level = rep('high',10)));
DF.rats <- rbind(DF.rats,data.frame(weight.gain = c( 90, 76, 90, 64, 86, 51, 72, 90, 95, 78), protein.source  = rep('beef',  10), protein.level = rep('low', 10)));

DF.rats <- rbind(DF.rats,data.frame(weight.gain = c( 98, 74, 56,111, 95, 88, 82, 77, 86, 92), protein.source  = rep('cereal',10), protein.level = rep('high',10)));
DF.rats <- rbind(DF.rats,data.frame(weight.gain = c(107, 95, 97, 80, 98, 74, 74, 67, 89, 58), protein.source  = rep('cereal',10), protein.level = rep('low', 10)));

DF.rats <- rbind(DF.rats,data.frame(weight.gain = c( 94, 79, 96, 98,102,102,108, 91,120,105), protein.source  = rep('pork',  10), protein.level = rep('high',10)));
DF.rats <- rbind(DF.rats,data.frame(weight.gain = c( 49, 82, 73, 86, 81, 97,106, 70, 61, 82), protein.source  = rep('pork',  10), protein.level = rep('low', 10)));

str(DF.rats);
DF.rats;

### Using predefined functions lm() and anova() ####################################################
LM.rats.2 <- lm(
	formula = weight.gain ~ protein.source * protein.level,
	data    = DF.rats
	);
anova(LM.rats.2);

LM.rats.1 <- lm(
	formula = weight.gain ~ protein.source + protein.level,
	data    = DF.rats
	);
anova(LM.rats.1);

LM.rats.0 <- lm(
	formula = weight.gain ~ protein.level,
	data    = DF.rats
	);
anova(LM.rats.0);

# plot the fat absorbed data, stratified by fat type:
pdf("exercise-2-11_dotplot-rats-protein-source-protein-level.pdf");
dotplot(
	1 ~ weight.gain | protein.source + protein.level,
	data = DF.rats
	);
dev.off();

pdf("exercise-2-11_dotplot-rats-protein-source.pdf");
dotplot(
	1 ~ weight.gain | protein.level,
	data = DF.rats
	);
dev.off();

### Conclusion #####################################################################################
# If we take our significance threshold to be 0.05, then we conclude that
# (1)  there is significant evidence for non-trivial protein.source effect, and
# (2)  there is significant evidence for non-trivial protein.level effect, but
# (3)  there is NOT significant evidence for non-trivial protein.source-protein.level interaction.

### Computing from first principle #################################################################
num.of.replicates      <- 10;
num.of.protein.sources <- length(levels(DF.rats[,'protein.source']));
num.of.protein.levels  <- length(levels(DF.rats[,'protein.level']));

mean.overall <- mean(DF.rats[,'weight.gain']);

# compute SS.null.model
SS.null.model <- sum((DF.rats[,'weight.gain'] - mean.overall)^2);
SS.null.model;

# compute SS.protein.source
DF.temp <- aggregate(
	formula = weight.gain ~ protein.source,
	data    = DF.rats,
	FUN     = mean
	);
SS.protein.source <- num.of.protein.levels * num.of.replicates * sum((DF.temp[,'weight.gain'] - mean.overall)^2);
SS.protein.source;

# compute SS.protein.level
DF.temp <- aggregate(
	formula = weight.gain ~ protein.level,
	data    = DF.rats,
	FUN     = mean
	);
SS.protein.level <- num.of.protein.sources * num.of.replicates * sum((DF.temp[,'weight.gain'] - mean.overall)^2);
SS.protein.level;

# compute SS.full.model
DF.temp <- aggregate(
	formula = weight.gain ~ protein.source + protein.level,
	data    = DF.rats,
	FUN     = mean
	);
DF.temp <- merge(
	x  = DF.rats,
	y  = DF.temp,
	by = c('protein.source','protein.level')
	);
SS.full.model <- sum((DF.temp[,'weight.gain.x'] - DF.temp[,'weight.gain.y'])^2);
SS.full.model;

# compute SS.interaction
DF.temp.0 <- aggregate(
	formula = weight.gain ~ protein.source + protein.level,
	data    = DF.rats,
	FUN     = mean
	);
colnames(DF.temp.0) <- c('protein.source','protein.level','value');
DF.temp.1 <- DF.temp.0;

DF.temp.2 <- aggregate(
	formula = weight.gain ~ protein.source,
	data    = DF.rats,
	FUN     = mean
	);

DF.temp.3 <- aggregate(
	formula = weight.gain ~ protein.level,
	data    = DF.rats,
	FUN     = mean
	);

DF.temp <- merge(
	x  = DF.temp.1,
	y  = DF.temp.2,
	by = "protein.source"
	);

DF.temp <- merge(
	x  = DF.temp,
	y  = DF.temp.3,
	by = "protein.level"
	);

SS.interaction <- num.of.replicates * sum((DF.temp[,'value'] - DF.temp[,'weight.gain.x'] - DF.temp[,'weight.gain.y'] + mean.overall)^2);
SS.interaction;

# compute F-statistics
df.full.model <- num.of.protein.sources*num.of.protein.levels*num.of.replicates - num.of.protein.sources*num.of.protein.levels;
print("df.full.model");
print(df.full.model);

df.protein.source <- num.of.protein.sources - 1;
F.protein.source <- (SS.protein.source/df.protein.source)/(SS.full.model/df.full.model);
pvalue.protein.source <- pf(q=F.protein.source, df1=df.protein.source, df2=df.full.model, lower.tail=FALSE);
print("F.protein.source");
print(F.protein.source);
print("pvalue.protein.source");
print(pvalue.protein.source);

df.protein.level <- num.of.protein.levels - 1;
F.protein.level <- (SS.protein.level/df.protein.level)/(SS.full.model/df.full.model);
pvalue.protein.level <- pf(q=F.protein.level, df1=df.protein.level, df2=df.full.model, lower.tail=FALSE);
print("F.protein.level");
print(F.protein.level);
print("pvalue.protein.level");
print(pvalue.protein.level);

df.interaction <- num.of.protein.sources * num.of.protein.levels - df.protein.source - df.protein.level - 1;
F.interaction <- (SS.interaction/df.interaction)/(SS.full.model/df.full.model);
pvalue.interaction <- pf(q=F.interaction, df1=df.interaction, df2=df.full.model, lower.tail=FALSE);
print("F.interaction");
print(F.interaction);
print("pvalue.interaction");
print(pvalue.interaction);

