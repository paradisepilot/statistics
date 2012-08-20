
### Using predefined functions lm() and anova() ####################################################
DF.doughnut <- data.frame(
	fat.absorbed = c(
					 164,172,168,177,156,195,
					 178,191,197,182,185,177,
					 175,193,178,171,163,176,
					 155,166,149,164,170,168
					 ),
	fat.type     = c(rep("Fat1",6),rep("Fat2",6),rep("Fat3",6),rep("Fat4",6))
	);
str(DF.doughnut);
DF.doughnut

LM.doughnut <- lm(
	formula = fat.absorbed ~ fat.type,
	data    = DF.doughnut
	);

pdf("exercise-2-3_LM-doughnut.pdf");
plot(LM.doughnut);
dev.off();

summary(LM.doughnut);

anova(LM.doughnut);

### Computing from first principle #################################################################
MAT.doughnut <- matrix(DF.doughnut[,'fat.absorbed'], nrow = 6, ncol = 4);
colnames(MAT.doughnut) <- paste("Fat", 1:4, sep = "");
MAT.doughnut;

num.of.groups <- ncol(MAT.doughnut);
num.of.observations <- nrow(MAT.doughnut) * ncol(MAT.doughnut);

colMeans(MAT.doughnut);
colMeans.MAT.doughnut <- colMeans(MAT.doughnut);

within.group.deviations <- t(apply(
	X      = MAT.doughnut,
	MARGIN = 1,
	FUN    = function(x) { return( x - colMeans.MAT.doughnut); }
	));
within.group.deviations;

within.group.squared.deviations <- within.group.deviations^2;
within.group.squared.deviations;

SS.within.group <- sum(within.group.squared.deviations);
SS.within.group;

colMeans.MAT.doughnut;

between.group.deviations <- colMeans.MAT.doughnut - mean(MAT.doughnut);
between.group.deviations;

between.group.squared.deviations <- between.group.deviations^2;
between.group.squared.deviations;

SS.between.group <- nrow(MAT.doughnut) * sum(between.group.squared.deviations);
SS.between.group;

F.statistic <- (SS.between.group/(num.of.groups-1)) / (SS.within.group/(num.of.observations-num.of.groups));
F.statistic;

p.value <- pf(q = F.statistic, df1 = num.of.groups-1, df2 = num.of.observations-num.of.groups, lower.tail = FALSE);
p.value;

### Conclusion #####################################################################################
# The p-value of 0.006875948 obtained above is the probability of obtaining a value of the test
# statistic (F-statistic) as extreme as or more extreme than the actual observed value, given that
# the null hyposthesis (reduced model, or the single-mean model) is true.
#
# If we use a 0.05 level significance threshold, then the observed data are declared to contain
# significant evidence against the null hypothesis.
#
# Based on the observed data and a significance threhold of 0.05, we therefore conclude that, the
# amount of fat absorbed appears to depend on the type of fat used.

