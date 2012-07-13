### script-name.R ##################################################################################
# 
#
#

### NOTES ##########################################################################################

library(lattice);
library(nlme);
data(Oxboys);

str(Oxboys);
# Oxboys;

##### Chapter 1, Exercise 2 ########################################################################
### (a)
pdf("../output/exercise-1-2a_plot_Oxboys.pdf");
plot(Oxboys);
dev.off();


### (b)
pdf("../output/exercise-1-2b_bwplot_residuals_lm.pdf");
oxboys.lm <- lm(formula = height ~ age, data = Oxboys);
bwplot(Subject ~ resid(oxboys.lm), data = Oxboys);
dev.off();


### (c)
oxboys.lmList <- lmList(height ~ age, data = Oxboys);
pdf("../output/exercise-1-2c_Oxboys_lmList.pdf");
plot(oxboys.lmList,Subject ~ resid(.));
dev.off();

summary(oxboys.lm);

summary(oxboys.lmList);

