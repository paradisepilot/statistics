
# absolute path to custom R library
# myLibPath <- "/Users/woodenbeauty/Work/gittmp/paradisepilot/statistics/projects/miniCRAN/run_installpackages/output.BACKUP.2017-08-05.01/library/3.4.1/library";

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
cat(paste0("\n\n##### Sys.time(): ",Sys.time(),"\n"));
start.proc.time <- proc.time();

###################################################
require(rmarkdown);
require(revealjs);

source(file.path(dir.code,"createTemplates.R"))
source(file.path(dir.code,"synthesizeData.R"))
source(file.path(dir.code,"getParticipantScores.R"))
source(file.path(dir.code,"getDivisionScores.R"))
source(file.path(dir.code,"getSectionScores.R"))

file.copy(from = file.path(dir.code,"ds-pac-2018.Rmd"), to = dir.output);
file.copy(from = file.path(dir.code,"my-style.css"),    to = dir.output);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(1234567);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#createTemplates(FILE.sections = file.path(dir.data,"sections.xlsx"));

synthesizeData( FILE.sections = file.path(dir.data,"sections.xlsx"));

dir.synthesized.microdata <- file.path(dir.output,"pac2018-microdata-synthesized");

#DF.participant <- getScoresSingleParticipant(
#    file.participant = file.path(dir.synthesized.microdata,"DMEE-BSMD","NH","pac2018_DMEE-BSMD_NH_1.csv"),
#    max.date  = as.Date("2018-06-10"),
#    max.score = 1500
#    );

DF.participantScores <- getParticipantScores(
    microdata.directory = dir.synthesized.microdata,
    max.date            = as.Date("2018-06-10"),
    max.score           = 1500,
    FILE.output         = "weekly-scores-participant.csv"
    );

DF.divisionScores <- getDivisionScores(
    DF.participantScores = DF.participantScores,
    FILE.output          = "weekly-scores-division.csv"
    );

DF.sectionScores <- getSectionScores(
    DF.participantScores = DF.participantScores,
    FILE.output          = "weekly-scores-section.csv"
    );

###################################################
# print warning messages to log
cat("\n\n###################################################");
cat("\n\n##### warnings():\n")
print(warnings());

# print session info to log
cat("\n##### sessionInfo():\n")
print(sessionInfo());

# print system time to log
cat(paste0("\n##### Sys.time(): ",Sys.time(),"\n"));

# print elapsed time to log
stop.proc.time <- proc.time();
cat("\n##### start.proc.time() - stop.proc.time():\n");
print( stop.proc.time - start.proc.time );
cat("\n")

# close output and message files
sink(type = "output" );
sink(type = "message");
closeAllConnections();
