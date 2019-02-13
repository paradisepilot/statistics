
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
source(paste0(code.directory,'/getPopulation.R'));
source(paste0(code.directory,'/getSamples.R'));
source(paste0(code.directory,'/pnpCART.R'));

###################################################
###################################################

my.population <- getPopulation(N = 100);

cat("\nsummary(my.population)");
print( summary(my.population) );

cat("\nmy.population");
print( my.population );

LIST.samples <- getSamples(
    DF.population  = my.population,
    prob.selection = 0.1
    );

cat("\nLIST.samples");
print( LIST.samples );

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
data(iris);
print( str(    iris) );
print( summary(iris) );
print( head(   iris) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.iris <- iris;
DF.iris[,"factor.Petal.Length"] <- character(nrow(DF.iris))

myQuantiles <- quantile(
    x     = DF.iris[,"Petal.Length"],
    probs = c(1,2,3)/3
    );

is.short  <- ifelse(DF.iris[,"Petal.Length"] <  myQuantiles[1],TRUE,FALSE);
is.long   <- ifelse(DF.iris[,"Petal.Length"] >= myQuantiles[3],TRUE,FALSE);
is.medium <- !( is.short | is.long );

DF.iris[is.short, "factor.Petal.Length"] <- "short";
DF.iris[is.medium,"factor.Petal.Length"] <- "medium";
DF.iris[is.long,  "factor.Petal.Length"] <- "long";

DF.iris[,"factor.Petal.Length"] <- factor(
    x      = DF.iris[,"factor.Petal.Length"],
    levels = c("short","medium","long")
    );

DF.iris <- DF.iris[,setdiff(colnames(DF.iris),"Petal.Length")];
colnames(DF.iris) <- gsub(
    x           = colnames(DF.iris),
    pattern     = "factor.Petal.Length",
    replacement = "Petal.Length"
    );

DF.iris <- DF.iris[,colnames(iris)];

iris <- DF.iris;
remove(DF.iris);

print( str(    iris) );
print( summary(iris) );
print( head(   iris) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
myTree <- pnpCART$new(
    formula = Species ~ .,
    data    = iris
    );
#print( str(myTree) );

myTree$grow();
#cat("\nmyTree$nodes\n" );
#print( myTree$nodes    );

myTree$print(
    FUN.format = function(x) {return( round(x,digits=3) )} 
    );

myPruningSequence <- myTree$get_pruning_sequence();
print( length(myPruningSequence) );
print( myPruningSequence );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.rpart <- rpart(
    formula = Species ~ .,
    data    = iris,
    control = list(
        minsplit  = 1,
        minbucket = 1,
        cp        = 0
        )
    );

cat("\nresults.rpart\n");
print( results.rpart   );
printcp( x = results.rpart, digits = 3 );

palette.iris <- brewer.pal(3,"Set1")[c(3,2,1)]; # c("green","blue","red");
names(palette.iris) <- c("setosa","versicolor","virginica");

palette.iris.light        <- c("#99ff99","#99ccff","#ffad99");
names(palette.iris.light) <- c("setosa","versicolor","virginica");

FILE.ggplot <- "plot-rpart.png";
png(filename = FILE.ggplot, height = 30, width = 30, units = "in", res = 300);
prp(
    x           = results.rpart,
    extra       = 101,
    cex         = 3.5, # 3.5,
    legend.cex  = 3.5,
    box.palette = as.list(palette.iris.light)
    );
dev.off();

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

