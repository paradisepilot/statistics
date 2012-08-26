
library(lattice);

### Define data ####################################################################################
DF.potatoes <- data.frame(matrix(nrow=0,ncol=3));
colnames(DF.potatoes) <- c('yield','variety','location');
str(DF.potatoes);
DF.potatoes;

DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(15,19,22), variety  = rep('A',3), location = rep('Loc.1')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(17,10,13), variety  = rep('A',3), location = rep('Loc.2')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c( 9,12, 6), variety  = rep('A',3), location = rep('Loc.3')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(14, 8,11), variety  = rep('A',3), location = rep('Loc.4')));

DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(20,24,18), variety  = rep('B',3), location = rep('Loc.1')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(24,18,22), variety  = rep('B',3), location = rep('Loc.2')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(12,15,10), variety  = rep('B',3), location = rep('Loc.3')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(21,16,14), variety  = rep('B',3), location = rep('Loc.4')));

DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(22,17,14), variety  = rep('C',3), location = rep('Loc.1')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(26,19,21), variety  = rep('C',3), location = rep('Loc.2')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(10, 5, 8), variety  = rep('C',3), location = rep('Loc.3')));
DF.potatoes <- rbind(DF.potatoes,data.frame(yield = c(19,15,12), variety  = rep('C',3), location = rep('Loc.4')));

str(DF.potatoes);
DF.potatoes;

### Using predefined functions lm() and anova() ####################################################
LM.potatoes.2 <- lm(
	formula = yield ~ variety * location,
	data    = DF.potatoes
	);
anova(LM.potatoes.2);

LM.potatoes.1 <- lm(
	formula = yield ~ variety + location,
	data    = DF.potatoes
	);
anova(LM.potatoes.1);

LM.potatoes.0 <- lm(
	formula = yield ~ variety,
	data    = DF.potatoes
	);
anova(LM.potatoes.0);

# plot the fat absorbed data, stratified by fat type:
pdf("exercise-2-10_dotplot-potatoes-variety-location.pdf");
dotplot(
	yield ~ variety | location,
	data = DF.potatoes
	);
dev.off();

pdf("exercise-2-10_dotplot-potatoes-variety.pdf");
dotplot(
	yield ~ variety,
	data = DF.potatoes
	);
dev.off();

### Conclusion #####################################################################################
# If we take our significance threshold to be 0.05, then we conclude that
# (1)  there is significant evidence for non-trivial variety effect, and
# (2)  there is significant evidence for non-trivial location effect, but
# (3)  there is NOT significant evidence for non-trivial variety-location interaction.

### Computing from first principle #################################################################
num.of.replicates <- 3;
num.of.varieties  <- length(levels(DF.potatoes[,'variety']));
num.of.locations  <- length(levels(DF.potatoes[,'location']));

mean.overall <- mean(DF.potatoes[,'yield']);

# compute SS.null.model
SS.null.model <- sum((DF.potatoes[,'yield'] - mean.overall)^2);
SS.null.model;

# compute SS.variety
DF.temp <- aggregate(
	formula = yield ~ variety,
	data    = DF.potatoes,
	FUN     = mean
	);
SS.variety <- num.of.locations * num.of.replicates * sum((DF.temp[,'yield'] - mean.overall)^2);
SS.variety;

# compute SS.location
DF.temp <- aggregate(
	formula = yield ~ location,
	data    = DF.potatoes,
	FUN     = mean
	);
SS.location <- num.of.varieties * num.of.replicates * sum((DF.temp[,'yield'] - mean.overall)^2);
SS.location;

# compute SS.full.model
DF.temp <- aggregate(
	formula = yield ~ variety + location,
	data    = DF.potatoes,
	FUN     = mean
	);
DF.temp <- merge(
	x  = DF.potatoes,
	y  = DF.temp,
	by = c('variety','location')
	);
SS.full.model <- sum((DF.temp[,'yield.x'] - DF.temp[,'yield.y'])^2);
SS.full.model;

# compute SS.interaction
DF.temp.0 <- aggregate(
	formula = yield ~ variety + location,
	data    = DF.potatoes,
	FUN     = mean
	);
colnames(DF.temp.0) <- c('variety','location','value');
DF.temp.1 <- DF.temp.0;

DF.temp.2 <- aggregate(
	formula = yield ~ variety,
	data    = DF.potatoes,
	FUN     = mean
	);

DF.temp.3 <- aggregate(
	formula = yield ~ location,
	data    = DF.potatoes,
	FUN     = mean
	);

DF.temp <- merge(
	x  = DF.temp.1,
	y  = DF.temp.2,
	by = "variety"
	);

DF.temp <- merge(
	x  = DF.temp,
	y  = DF.temp.3,
	by = "location"
	);

SS.interaction <- num.of.replicates * sum((DF.temp[,'value'] - DF.temp[,'yield.x'] - DF.temp[,'yield.y'] + mean.overall)^2);
SS.interaction;

# compute F-statistics
df.full.model <- num.of.varieties*num.of.locations*num.of.replicates - num.of.varieties*num.of.locations;
print("df.full.model");
print(df.full.model);

df.variety <- num.of.varieties - 1;
F.variety <- (SS.variety/df.variety)/(SS.full.model/df.full.model);
pvalue.variety <- pf(q=F.variety, df1=df.variety, df2=df.full.model, lower.tail=FALSE);
print("F.variety");
print(F.variety);
print("pvalue.variety");
print(pvalue.variety);

df.location <- num.of.locations - 1;
F.location <- (SS.location/df.location)/(SS.full.model/df.full.model);
pvalue.location <- pf(q=F.location, df1=df.location, df2=df.full.model, lower.tail=FALSE);
print("F.location");
print(F.location);
print("pvalue.location");
print(pvalue.location);

df.interaction <- num.of.varieties * num.of.locations - df.variety - df.location - 1;
F.interaction <- (SS.interaction/df.interaction)/(SS.full.model/df.full.model);
pvalue.interaction <- pf(q=F.interaction, df1=df.interaction, df2=df.full.model, lower.tail=FALSE);
print("F.interaction");
print(F.interaction);
print("pvalue.interaction");
print(pvalue.interaction);

