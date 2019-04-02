
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

source(paste0(code.directory,'/doOneSimulation.R'));
source(paste0(code.directory,'/doSimulations.R'));
source(paste0(code.directory,'/getCalibrationEstimate.R'));
source(paste0(code.directory,'/getChenLiWuEstimate.R'));
source(paste0(code.directory,'/getPopulation.R'));
source(paste0(code.directory,'/getSamples.R'));
source(paste0(code.directory,'/myCART.R'));
source(paste0(code.directory,'/pnpCART.R'));
source(paste0(code.directory,'/visualizePopulation.R'));
source(paste0(code.directory,'/visualizePropensity.R'));
source(paste0(code.directory,'/visualizeSimulations.R'));

###################################################
###################################################
my.seed         <- 1234567;
population.size <- 10000;
alpha0          <- 0.25;
n.iterations    <- 200;
prob.selection  <- 0.1;

#population.size <- 1000;
#n.iterations    <-    3;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
population.flags <- c("01","02","03");
for (population.flag in population.flags) {

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n\n### population flag: ",population.flag,"\n"));

    my.population <- getPopulation(
        seed            = my.seed,
        N               = population.size,
        alpha0          = alpha0,
        population.flag = population.flag
        );

    cat("\nstr(my.population):\n");
    print( str(my.population)   );

    cat("\nsummary(my.population):\n");
    print( summary(my.population)   );

    Y_total <- sum(my.population[,"y"]);
    cat("\nY_total\n");
    print( Y_total   );

    cat("\npopulation totals of y, x1, x2:\n");
    print(apply(
        X = my.population[,c("y","x1","x2")],
        MARGIN = 2,
        FUN = function(x) { sum(x) }
        ));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    visualizePopulation(
        population.flag = population.flag,
        population      = my.population
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    doOneSimulation(
        population.flag = population.flag,
        DF.population   = my.population,
        prob.selection  = prob.selection
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    FILE.results <- paste0("simulation-results-",population.flag,".csv");

    DF.results <- doSimulations(
        FILE.results   = FILE.results,
        n.iterations   = n.iterations,
        DF.population  = my.population,
        prob.selection = prob.selection
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    visualizeSimulations(
        population.flag  = population.flag,
        FILE.input       = FILE.results,
        vline_xintercept = Y_total
        );

    }

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

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

