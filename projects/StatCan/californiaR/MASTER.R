
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

source(file.path(dir.code,"addAttributes.R"))
source(file.path(dir.code,"examineData.R"))
source(file.path(dir.code,"preprocessData.R"))
source(file.path(dir.code,"splitTrainTest.R"))
source(file.path(dir.code,"visualizeData.R"))

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# load data
DF.housing <- read.csv(
    file   = file.path(dir.data,"housing.csv"),
    header = TRUE
    );

# examine full data set
examineData(DF.input = DF.housing);
visualizeData(DF.input = DF.housing);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
LIST.trainTest <- splitTrainTest(DF.input = DF.housing);

print("str(LIST.trainTest)");
print( str(LIST.trainTest) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
preprocessedTrainSet = preprocessData(
    DF.input =  LIST.trainTest[["trainSet"]]
    )

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
trainSetAugmented <- addAttributes(
    DF.input = LIST.trainTest[["trainSet"]]
    )

myPreprocessor <- preProcess(
    x      = trainSetAugmented,
    method = c("medianImpute","center","scale"),
    );

preprocessedTrainSet1 <- predict(
    object  = myPreprocessor,
    newdata = trainSetAugmented
    );

preprocessedTrainSet1 <- data.frame(predict(
    dummyVars(formula = ~ ., data=preprocessedTrainSet1),
    newdata=preprocessedTrainSet1
    )); 

preprocessedTrainSet1[,"median_house_value"] <- LIST.trainTest[["trainSet"]][,"median_house_value"];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
print("str(preprocessedTrainSet)");
print( str(preprocessedTrainSet) );

print("str(preprocessedTrainSet1)");
print( str(preprocessedTrainSet1) );

print("head(preprocessedTrainSet)");
print( head(preprocessedTrainSet) );

print("head(preprocessedTrainSet1)");
print( head(preprocessedTrainSet1) );

print("summary(abs(preprocessedTrainSet - preprocessedTrainSet1)/preprocessedTrainSet)");
print( summary(abs(preprocessedTrainSet - preprocessedTrainSet1)) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

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

