
library(lattice);

### Using predefined functions lm() and anova() ####################################################
DF.growth <- data.frame(
	growth = c(
		2,3,1,1,2,1,
		3,4,2,1,2,1,
		3,5,1,2,2,2,
		4,6,2,2,2,3
		),
	photoperiod = c(rep("very.short",6),rep("short",6),rep("long",6),rep("very.long",6))
	);
str(DF.growth);
DF.growth;

# plot the fat absorbed data, stratified by fat type:
pdf("exercise-2-4_dotplot-growth.pdf");
dotplot(
	growth ~ photoperiod,
	data = DF.growth
	);
dev.off();

LM.growth <- lm(
	formula = growth ~ photoperiod,
	data    = DF.growth
	);

# generate residual plots for goodness-of-fit diagnostics:
pdf("exercise-2-4_LM-growth.pdf");
plot(LM.growth);
dev.off();

summary(LM.growth);

anova(LM.growth);

### Computing from first principle #################################################################
MAT.growth <- matrix(DF.growth[,'growth'], nrow = 6, ncol = 4);
colnames(MAT.growth) <- c('very.short','short','long','very.long');
MAT.growth;

num.of.groups <- ncol(MAT.growth);
num.of.observations <- nrow(MAT.growth) * ncol(MAT.growth);

colMeans(MAT.growth);
colMeans.MAT.growth <- colMeans(MAT.growth);

within.group.deviations <- t(apply(
	X      = MAT.growth,
	MARGIN = 1,
	FUN    = function(x) { return( x - colMeans.MAT.growth); }
	));
within.group.deviations;

within.group.squared.deviations <- within.group.deviations^2;
within.group.squared.deviations;

SS.within.group <- sum(within.group.squared.deviations);
SS.within.group;

colMeans.MAT.growth;

between.group.deviations <- colMeans.MAT.growth - mean(MAT.growth);
between.group.deviations;

between.group.squared.deviations <- between.group.deviations^2;
between.group.squared.deviations;

SS.between.group <- nrow(MAT.growth) * sum(between.group.squared.deviations);
SS.between.group;

F.statistic <- (SS.between.group/(num.of.groups-1)) / (SS.within.group/(num.of.observations-num.of.groups));
F.statistic;

p.value <- pf(q = F.statistic, df1 = num.of.groups-1, df2 = num.of.observations-num.of.groups, lower.tail = FALSE);
p.value;

### Conclusion #####################################################################################
# The large p-value of 0.2550719 suggests that there is no significant evidence in the data that
# photoperiod does not affect growth.

