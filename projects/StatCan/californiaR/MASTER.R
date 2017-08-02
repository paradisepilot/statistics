
# absolute path to custom R library
myLibPath <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-07-24.05/library/3.4.1/library";

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
source(file.path(dir.code,"examineData.R"))

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
require(tm);
require(wordcloud);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# load data
DF.housing <- read.csv(
    file   = file.path(dir.data,"housing.csv"),
    header = TRUE
    );

print("str(DF.housing)");
print( str(DF.housing) );

# examine full data set
examineData(DF.input = DF.housing);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
quit(save="no");

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
dir.data <- file.path(dir.MASTER,"data");
docs <- Corpus(DirSource(dir.data));
docs <- tm_map(docs, removePunctuation);
docs <- tm_map(docs, removeWords, stopwords("english"));
docs <- tm_map(docs, stripWhitespace);
docs <- tm_map(docs, stemDocument);

print("summary(docs)");
print( summary(docs) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
dtm  <- DocumentTermMatrix(docs);
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE);

set.seed(123);
png(filename="my-word-cloud.png",height=6,width=6,units="in",res=1000);
wordcloud(names(freq), freq, min.freq=50, colors=brewer.pal(6,"Dark2"));
dev.off();

###################################################
# print warning messages to log
print("");
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

