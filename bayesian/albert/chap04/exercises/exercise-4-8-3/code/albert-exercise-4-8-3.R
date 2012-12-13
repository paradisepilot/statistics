
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### 4.8.3(a) #######################################################################################
#
#     g(pN,pS|Data)
#  =  g(pN,pS) * g(Data|pN,pS)
#  =~ 1        * (pN ^ yN) * (1 - pN)^(nN - yN) * (pS ^ yS) * (1 - pS) ^ (nS - yS)
#  =  (pN ^ yN) * (1 - pN)^(nN - yN) * (pS ^ yS) * (1 - pS) ^ (nS - yS)
#  =  pN^(yN+1-1)) * (1 - pN)^(nN - yN + 1 - 1) * pS^(yS+1-1) * (1 - pS) ^ (nS - yS + 1 - 1)
#
#  Next, recall that the probability density of a beta distribution is given by:
#
#  f_{Beta}(x; alpha, beta) =~ x ^ (alpha - 1) * (1-x) ^ (beta - 1)
#
#  Hence, we see that
#    (a)  pN and pS are posteriorly independent,
#    (b)  pN ~ Beta(yN + 1, nN - yN + 1), and
#    (c)  pS ~ Beta(yS + 1, nS - yS + 1), and
#

### 4.8.3(b) #######################################################################################
y.N <-   1601;
z.N <- 162527;
y.S <-    510;
z.S <- 412368;

n.N <- y.N + z.N;
n.S <- y.S + z.S;

sample.size <- 1e+5;
pN.sample   <- rbeta(n = sample.size, shape1 = y.N + 1, shape2 = z.N + 1);
pS.sample   <- rbeta(n = sample.size, shape1 = y.S + 1, shape2 = z.S + 1);

relative.risk.sample <- pN.sample / pS.sample;

### 4.8.3(c) #######################################################################################
png("Fig1_histogram-relative-risk.png");
qplot(x = relative.risk.sample, geom = "histogram", binwidth = 0.01);
dev.off();

quantile(x = relative.risk.sample, probs = c(0.025, 0.5, 0.975));

### 4.8.3(d) #######################################################################################
pN.minus.pS.sample <- pN.sample - pS.sample;

png("Fig2_histogram-pN-minus-pS.png");
qplot(x = pN.minus.pS.sample, geom = "histogram", binwidth = 1e-5);
dev.off();

### 4.8.3(e) #######################################################################################
mean(pN.minus.pS.sample > 0);

####################################################################################################
####################################################################################################
png("Fig3_pN-pS-posterior-distributions.png");
DF.pN <- data.frame(
	proportion = pN.sample,
	safety     = factor(rep('None',length(pN.sample)),levels=c('Seat belt','None'))
	);
DF.pS <- data.frame(
	proportion = pS.sample,
	safety     = factor(rep('Seat belt',length(pN.sample)),levels=c('Seat belt','None'))
	);
DF.temp <- rbind(DF.pN,DF.pS);
qplot(data = DF.temp, x = proportion, colour = safety, geom = "density");
dev.off();

####################################################################################################
contingency.table <- matrix(
	c(y.N,y.S,z.N,z.S),
	nrow     = 2,
	dimnames = list(c("none", "seat.belt"),c("fatal", "non-fatal"))
	);
contingency.table;

fisher.test(contingency.table);

