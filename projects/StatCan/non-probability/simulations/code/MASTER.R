
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
 output.directory <- normalizePath(command.arguments[2]);

cat(paste0("##### Sys.time(): ",Sys.time(),"\n"));
start.proc.time <- proc.time();

setwd(output.directory);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(R6);
library(RColorBrewer);
library(rpart);
library(rpart.plot);
library(survey);

source(paste0(code.directory,'/doSimulations.R'));
source(paste0(code.directory,'/getCalibrationEstimate.R'));
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

apply(
    X = my.population[,c("y","x1","x2")],
    MARGIN = 2,
    FUN = function(x) { sum(x) }
    )

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

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#set.seed(2);
#LIST.samples <- getSamples(
#    DF.population  = my.population,
#    prob.selection = 0.1
#    );
#
#print( str(LIST.samples) );
#
#population.totals <- c(
#    "(Intercept)" = nrow(my.population),
#    x1            = sum(my.population[,"x1"]),
#    x2            = sum(my.population[,"x2"])
#    );
#
#print( population.totals );
#
#getCalibrationEstimate(
#    DF.input          = LIST.samples[['non.probability.sample']],
#    population.totals = population.totals
#    );

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

