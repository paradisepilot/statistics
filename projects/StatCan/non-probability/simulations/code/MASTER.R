
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
 output.directory <- normalizePath(command.arguments[2]);

cat(paste0("##### Sys.time(): ",Sys.time(),"\n"));
start.proc.time <- proc.time();

setwd(output.directory);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(rpart);
library(rpart.plot);
library(RColorBrewer);
library(R6);

source(paste0(code.directory,'/doSimulations.R'));
source(paste0(code.directory,'/getPopulation.R'));
source(paste0(code.directory,'/getSamples.R'));
source(paste0(code.directory,'/myCART.R'));
source(paste0(code.directory,'/pnpCART.R'));
source(paste0(code.directory,'/postVisualization.R'));
source(paste0(code.directory,'/visualizePopulation.R'));
source(paste0(code.directory,'/visualizePropensity.R'));
source(paste0(code.directory,'/visualizeSimulations.R'));

###################################################
###################################################
#set.seed(7654321);
set.seed(1234567);

my.population <- getPopulation(N = 10000);
print( str(    my.population) );
print( summary(my.population) );
#print( head(my.population,n=20) );

Y_total <- sum(my.population[,"y"]);
print( Y_total );

visualizePopulation(population = my.population);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FILE.results   <- "results-simulations.csv";
n.iterations   <- 200;
prob.selection <- 0.1;

DF.results <- doSimulations(
    FILE.results   = FILE.results,
    n.iterations   = n.iterations,
    DF.population  = my.population,
    prob.selection = prob.selection
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#visualizeSimulations(
#    DF.input         = DF.results,
#    vline_xintercept = Y_total
#    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
postVisualization(
    FILE.input       = FILE.results,
    vline_xintercept = Y_total
    );

###################################################
###################################################
# print warning messages to log
cat("\n##### warnings()\n")
print(warnings());

# print session info to log
cat("\n##### sessionInfo()\n")
print( sessionInfo() );

# print system time to log
cat(paste0("\n##### Sys.time(): ",Sys.time(),"\n"));

# print elapsed time to log
stop.proc.time <- proc.time();
cat("\n##### start.proc.time() - stop.proc.time()\n");
print( stop.proc.time - start.proc.time );

quit();

###################################################
###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
LIST.samples <- getSamples(
    DF.population  = my.population,
    prob.selection = 0.1
    );

print( str(    LIST.samples[['non.probability.sample']]) );
print( summary(LIST.samples[['non.probability.sample']]) );
print( head(   LIST.samples[['non.probability.sample']],n=20) );

print( str(    LIST.samples[['probability.sample']]) );
print( summary(LIST.samples[['probability.sample']]) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
pnpTree.RData <- "myPNPTree.RData";

if ( file.exists(pnpTree.RData) ) {
    load(file = pnpTree.RData);
} else {
    pnpTree <- pnpCART$new(
        predictors = c("x1","x2"),
        np.data    = LIST.samples[['non.probability.sample']],
        p.data     = LIST.samples[['probability.sample']],
        weight     = "weight"
        );
    pnpTree$grow();
    save(pnpTree, file = pnpTree.RData);
    }

print( str(pnpTree) );

pnpTree$print(
    FUN.format = function(x) {return( round(x,digits=3) )} 
    );

DF.npdata_with_propensity <- pnpTree$get_npdata_with_propensity();
colnames(DF.npdata_with_propensity) <- gsub(
    x           = colnames(DF.npdata_with_propensity),
    pattern     = "propensity",
    replacement = "p_hat"
    );
DF.npdata_with_propensity <- merge(
    x  = DF.npdata_with_propensity,
    y  = my.population[,c("ID","propensity")],
    by = "ID"
    );
DF.npdata_with_propensity <- DF.npdata_with_propensity[order(DF.npdata_with_propensity[,"ID"]),];
print( DF.npdata_with_propensity, digits = 3 );

print(
    cor(
        x = DF.npdata_with_propensity[,"p_hat"],
        y = DF.npdata_with_propensity[,"propensity"]
        )
    );

Y_hat <- sum(
    DF.npdata_with_propensity[,"y"] / DF.npdata_with_propensity[,"propensity"]
    );

print( Y_total );
print( Y_hat   );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
visualizePropensity(
    DF.input = DF.npdata_with_propensity
    );

###################################################
###################################################
# print warning messages to log
cat("\n##### warnings()\n")
print(warnings());

# print session info to log
cat("\n##### sessionInfo()\n")
print( sessionInfo() );

# print system time to log
cat(paste0("\n##### Sys.time(): ",Sys.time(),"\n"));

# print elapsed time to log
stop.proc.time <- proc.time();
cat("\n##### start.proc.time() - stop.proc.time()\n");
print( stop.proc.time - start.proc.time );

quit();

