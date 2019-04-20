
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
 output.directory <- normalizePath(command.arguments[2]);

cat(paste0("##### Sys.time(): ",Sys.time(),"\n"));
start.proc.time <- proc.time();

setwd(output.directory);

# print system time to log file
print("");
print(paste0("##### Sys.time(): ",Sys.time()));
start.proc.time <- proc.time();

###################################################
require(rpart);
require(rpart.plot);
require(RColorBrewer);

source(file.path(code.directory,"visualizeData.R"))
source(file.path(code.directory,"plot-results-rpart.R"))
source(file.path(code.directory,"plot-regression-surface.R"))

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(1234567);

data(iris);
DF.iris <- iris;
remove(iris);

cat("\nstr(DF.iris)\n");
print( str(DF.iris)   );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.iris[,"Species"] <- as.character(DF.iris[,"Species"]);
DF.iris["setosa"     == DF.iris[,"Species"],"Species"] <- "selected";
DF.iris["virginica"  == DF.iris[,"Species"],"Species"] <- "selected";
DF.iris["versicolor" == DF.iris[,"Species"],"Species"] <- "not selected";

colnames(DF.iris) <- gsub(
    x           = colnames(DF.iris),
    pattern     = "Species",
    replacement = "Self.Selected"
    );

DF.iris[,"Self.Selected"] <- factor(
    x      = DF.iris[,"Self.Selected"],
    levels = c("selected","not selected")
    );

colnames(DF.iris) <- gsub(
    x           = colnames(DF.iris),
    pattern     = "Petal.Width",
    replacement = "x1"
    );

colnames(DF.iris) <- gsub(
    x           = colnames(DF.iris),
    pattern     = "Petal.Length",
    replacement = "x2"
    );

DF.iris <- DF.iris[,c("Self.Selected","x1","x2","Sepal.Length","Sepal.Width")];

DF.iris[1.0 == DF.iris[,"x1"],"x1"] <- 0.7;
DF.iris[0.5 == DF.iris[,"x1"],"x1"] <- 0.8;
DF.iris[0.6 == DF.iris[,"x1"],"x1"] <- 0.9;

cat("\nstr(DF.iris)\n");
print( str(DF.iris)   );

cat("\nDF.iris\n");
print( DF.iris   );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
palette.iris <- brewer.pal(3,"Set2")[c(2,1)]; # c("orange","green");
names(palette.iris) <- c("selected","not selected");

palette.iris.light        <- c("bisque","aquamarine1");
names(palette.iris.light) <- c("selected","not selected");

visualizeData(
    DF.input     = DF.iris,
    palette.iris = palette.iris
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.rpart <- rpart(
    formula = Self.Selected ~ x1 + x2,
    data    = DF.iris
    );

plot.results.rpart(
    results.rpart = results.rpart,
    palette.iris  = palette.iris.light #palette.iris
    );

#plot.regression.surface(
#    results.rpart = results.rpart
#    );

###################################################
# print warning messages to log
cat("\n###################################################");
cat("\n##### warnings():\n");
print(warnings());

# print session info to log
cat("\n");
cat("\n##### sessionInfo():\n");
print(sessionInfo());

# print system time to log
cat("\n");
cat(paste0("\n##### Sys.time(): ",Sys.time()));

# print elapsed time to log
stop.proc.time <- proc.time();
cat("\n");
cat("\n##### start.proc.time() - stop.proc.time():\n");
print( stop.proc.time - start.proc.time );

