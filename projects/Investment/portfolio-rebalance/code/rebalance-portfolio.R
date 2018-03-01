
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
command.arguments <- commandArgs(trailingOnly = TRUE);

dir.code   <- normalizePath(command.arguments[1]);
dir.output <- normalizePath(command.arguments[2]);

csv.portfolio <- normalizePath(command.arguments[3]);

setwd(dir.output);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
fh.output  <- file("log.output",  open = "wt");
fh.message <- file("log.message", open = "wt");

sink(file = fh.message, type = "message");
sink(file = fh.output,  type = "output" );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
print("\n##### Sys.time()");
Sys.time();

start.proc.time <- proc.time();

###################################################
source(file.path(dir.code,"compute-adjustments.R"))
source(file.path(dir.code,"get-adjustment-matrix.R"))
source(file.path(dir.code,"get-portfolio-adjustment.R"))

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.existing.portfolio <- read.table(
    file         = csv.portfolio,
	dec          = ".",
	header       = TRUE,
	row.names    = "investment",
	sep          = "\t",
	comment.char = "#",
    stringsAsFactors = FALSE
	);
DF.existing.portfolio;
str(DF.existing.portfolio);

new.contribution.rrsp <-  7031 +  4315.52;
new.contribution.tfsa <- 16500 + 26348.31;
DF.adjustments <- compute.adjustments(
    existing.portfolio    = DF.existing.portfolio,
    new.contribution.rrsp = new.contribution.rrsp,
    new.contribution.tfsa = new.contribution.tfsa
    );

write.table(
    x         = DF.adjustments,
    file      = "adjustments.csv",
    sep       = "\t",
    quote     = FALSE,
    row.names = FALSE
    );

###################################################
print("\n##### warnings()")
warnings();

print("\n##### sessionInfo()")
sessionInfo();

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
print("\n##### Sys.time()");
Sys.time();

stop.proc.time <- proc.time();
print("\n##### start.proc.time() - stop.proc.time()");
stop.proc.time - start.proc.time;

sink(type = "output" );
sink(type = "message");
closeAllConnections();
