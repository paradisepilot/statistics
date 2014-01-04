
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.delim(
	file = paste0(data.directory,'/table-07-05-embryonic-anthers.csv'),
	sep  = '\t'
	);
DF.data[,'storage'] <- as.factor(DF.data[,'storage']);
DF.data[,'num.otherwise.anthers'] <- DF.data[,'num.prepared.anthers'] - DF.data[,'num.embryonic.anthers'];
str(DF.data);
DF.data;

####################################################################################################
model1.glm <- glm(
	formula = cbind(num.embryonic.anthers,num.otherwise.anthers) ~ storage * log(centrifuge),
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(model1.glm);

model2.glm <- glm(
	formula = cbind(num.embryonic.anthers,num.otherwise.anthers) ~ storage + log(centrifuge),
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(model2.glm);

model3.glm <- glm(
	formula = cbind(num.embryonic.anthers,num.otherwise.anthers) ~ 1 + log(centrifuge),
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(model3.glm);

####################################################################################################
# comparing:
# (*) fitting two parallel lines with distinct intercepts, one for each storage condition
# (*) fitting two lines with distinct intercepts and distinct slopes, one for each storage condition
anova(model2.glm,model1.glm);

# comparing (effect on storage on response, after adjusting for centrifuge):
# (*) fitting one line through all data points
# (*) fitting two parallel lines with distinct intercepts, one for each storage condition
anova(model3.glm,model2.glm);

####################################################################################################

q();

