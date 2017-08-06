
# absolute path to custom R library
myLibPath <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library";

# add custom library using .libPaths()
libPaths.original <- .libPaths();
libPaths.new <- c(myLibPath,libPaths.original);
.libPaths(libPaths.new);

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
require(caret);
require(randomForest);

source(file.path(dir.code,"attributeAdder.R"))
source(file.path(dir.code,"cvLM.R"))
source(file.path(dir.code,"cvRandomForest.R"))
source(file.path(dir.code,"cvRegressionTree.R"))
source(file.path(dir.code,"examineData.R"))
source(file.path(dir.code,"regressionLinear.R"))
source(file.path(dir.code,"regressionTree.R"))
source(file.path(dir.code,"splitTrainTest.R"))
source(file.path(dir.code,"train-predict-evaluate.R"))
source(file.path(dir.code,"visualizeData.R"))

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(1234567);

# load data
DF.housing <- read.csv(
    file   = file.path(dir.data,"housing.csv"),
    header = TRUE
    );

# examine full data set
# examineData(DF.input = DF.housing);
# visualizeData(DF.input = DF.housing);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
LIST.trainTest <- splitTrainTest(DF.input = DF.housing);

print("str(LIST.trainTest)");
print( str(LIST.trainTest) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
train.predict.evaluate(
    DF.train       = LIST.trainTest[["trainSet"]],
    DF.test        = LIST.trainTest[["testSet"]],
    attributeAdder = attributeAdder,
    methodName     = "lm",
    trainFunction  = lm.train
    );

train.predict.evaluate(
    DF.train       = LIST.trainTest[["trainSet"]],
    DF.test        = LIST.trainTest[["testSet"]],
    attributeAdder = attributeAdder,
    methodName     = "cvLM",
    trainFunction  = cvLM.train
    );

train.predict.evaluate(
    DF.train       = LIST.trainTest[["trainSet"]],
    DF.test        = LIST.trainTest[["testSet"]],
    attributeAdder = attributeAdder,
    methodName     = "regressionTree",
    trainFunction  = regressionTree.train
    );

train.predict.evaluate(
    DF.train       = LIST.trainTest[["trainSet"]],
    DF.test        = LIST.trainTest[["testSet"]],
    attributeAdder = attributeAdder,
    methodName     = "cvRegressionTree",
    trainFunction  = cvRegressionTree.train
    );

train.predict.evaluate(
    DF.train       = LIST.trainTest[["trainSet"]],
    DF.test        = LIST.trainTest[["testSet"]],
    attributeAdder = attributeAdder,
    methodName     = "cvRandomForest",
    trainFunction  = cvRandomForest.train
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

