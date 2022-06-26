
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);

print( data.directory );
print( code.directory );
print( output.directory );

print( format(Sys.time(),"%Y-%m-%d %T %Z") );

start.proc.time <- proc.time();

# set working directory to output directory
setwd( output.directory );

##################################################
require(ggplot2);
require(RColorBrewer);

# source supporting R code
code.files <- c(
    "do-OPLS.R",
    "do-PCA.R",
    "generate-data.R",
    "initializePlot.R",
    "visualize-data.R"
    );

for ( code.file in code.files ) {
    source(file.path(code.directory,code.file));
    }

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.seed <- 7654321;
set.seed(my.seed);

is.macOS  <- grepl(x = sessionInfo()[['platform']], pattern = 'apple', ignore.case = TRUE);
n.cores   <- ifelse(test = is.macOS, yes = 2, no = parallel::detectCores() - 1);
cat(paste0("\n# n.cores = ",n.cores,"\n"));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.data <- generate.data(
    theta    = (3 * pi / 8),
    h.offset = 2.75
    );

cat("\nstr(DF.data)\n");
print( str(DF.data)   );

cat("\nsummary(DF.data)\n");
print( summary(DF.data)   );

cat("\ntable(DF.data[,c('y','colour')])\n");
print( table(DF.data[,c('y','colour')])   );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.OPLS <- do.OPLS(
    DF.input = DF.data
    );

cat("\nresults.OPLS\n");
print( results.OPLS   );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.PCA <- do.PCA(
    DF.input = DF.data
    );

cat("\nresults.PCA\n");
print( results.PCA   );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
visualize.data(
    DF.input        = DF.data,
    results.OPLS    = results.OPLS,
    results.PCA     = results.PCA,
    textsize.title  = 35,
    textsize.axis   = 35,
    PNG.OPLS.vs.PCA = "plot-OPLS-vs-PCA.png",
    PNG.PCA         = "plot-PCA.png"
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

##################################################
print( warnings() );

print( getOption('repos') );

print( .libPaths() );

print( sessionInfo() );

print( format(Sys.time(),"%Y-%m-%d %T %Z") );

stop.proc.time <- proc.time();
print( stop.proc.time - start.proc.time );
