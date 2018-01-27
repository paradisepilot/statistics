
# absolute path to custom R library
#myLibPath <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library";

# add custom library using .libPaths()
#libPaths.original <- .libPaths();
#libPaths.new <- c(myLibPath,libPaths.original);
#.libPaths(libPaths.new);

# get directory of this script, i.e. MASTER.R
dir.MASTER <- getSrcDirectory(function(x) {x});

# define path to the code directory
dir.code   <- file.path(dir.MASTER,"code");

# define path to the data directory
dir.data   <- file.path(dir.MASTER,"data");

# define path to the output directory
dir.output <- file.path(dir.MASTER,paste0("output.",Sys.info()[["login"]]));

# create output directory if it does not yet exist
if (!dir.exists(dir.output)) { dir.create(path=dir.output,recursive=FALSE); }
setwd(dir.output);

# save replica of MASTER.R and code directory to output directory
path.MASTER <- file.path(dir.MASTER,getSrcFilename(function(x) {x}));
file.copy(from = dir.code,    to = dir.output, recursive = TRUE);
file.copy(from = path.MASTER, to = dir.output);

# redirect R output and R messages to file
fh.output  <- file("log.output",  open = "wt");
fh.message <- file("log.message", open = "wt");
sink(file = fh.message, type = "message");
sink(file = fh.output,  type = "output" );

# print system time to log file
print("");
print(paste0("##### Sys.time(): ",Sys.time()));
start.proc.time <- proc.time();

###################################################
require(rpart);
require(rpart.plot);
require(RColorBrewer);

source(file.path(dir.code,"visualizeData.R"))
source(file.path(dir.code,"plot-results-rpart.R"))
source(file.path(dir.code,"plot-regression-surface.R"))

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(1234567);

data(iris);
DF.iris <- iris;
remove(iris);

#DF.iris[,"Petal.Length"] <- iris[,"Petal.Width" ];
#DF.iris[,"Petal.Width"]  <- iris[,"Petal.Length"];

print(str(iris));
print(str(DF.iris));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
palette.iris <- brewer.pal(3,"Set1")[c(3,2,1)]; # c("green","blue","red");
names(palette.iris) <- c("setosa","versicolor","virginica");

palette.iris.light        <- c("#99ff99","#99ccff","#ffad99");
names(palette.iris.light) <- c("setosa","versicolor","virginica");

visualizeData(
    DF.input     = DF.iris,
    palette.iris = palette.iris
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.rpart <- rpart(
    formula = Species ~ Petal.Length + Petal.Width,
    data    = DF.iris
    );

plot.results.rpart(
    results.rpart = results.rpart,
    palette.iris  = palette.iris.light #palette.iris
    );

plot.regression.surface(
    results.rpart = results.rpart
    );

###################################################
# print warning messages to log
print("###################################################");
print("##### warnings()")
print(warnings());

# print session info to log
print("");
print("##### sessionInfo()")
print(sessionInfo());

# print system time to log
print("");
print(paste0("##### Sys.time(): ",Sys.time()));

# print elapsed time to log
stop.proc.time <- proc.time();
print("");
print("##### start.proc.time() - stop.proc.time()");
print( stop.proc.time - start.proc.time );

# close output and message files
sink(type = "output" );
sink(type = "message");
closeAllConnections();
