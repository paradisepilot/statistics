
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
 output.directory <- normalizePath(command.arguments[2]);
pkgs.desired.FILE <- normalizePath(command.arguments[3]);

setwd(output.directory);

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
default.libPaths <- setdiff(gsub(x=.libPaths(),pattern="^/Users/.+",replacement=""),c(""));
.libPaths(default.libPaths);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# copy the file of desired packages to output directory
file.copy(
    from = pkgs.desired.FILE,
    to   = "."
    );

# read list of desired R packages
pkgs.desired <- read.table(
    file = pkgs.desired.FILE,
    header = FALSE,
    stringsAsFactors = FALSE
    )[,1];

# exclude packages already installed
pkgs.desired <- setdiff(
    pkgs.desired,
    as.character(installed.packages()[,"Package"])
    );

write.table(
    file      = "Rpackages-desired-minus-preinstalled.txt",
    x         = data.frame(package = sort(pkgs.desired)),
    quote     = FALSE,
    row.names = FALSE,
    col.names = FALSE
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# get URL of an active CRAN mirror
CRANmirrors   <- getCRANmirrors();
CRANmirrors   <- CRANmirrors[CRANmirrors[,"OK"]==1,];
caCRANmirrors <- CRANmirrors[CRANmirrors[,"CountryCode"]=="ca",c("Name","CountryCode","OK","URL")];
if (nrow(caCRANmirrors) > 0) {
	myRepoURL <- caCRANmirrors[nrow(caCRANmirrors),"URL"];
	} else if (nrow(CRANmirrors) > 0) {
	myRepoURL <- CRANmirrors[1,"URL"];
	} else {
	q();
	}

print(paste("\n##### myRepoURL",myRepoURL,sep=" = "));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# assemble full path for R library to be built
current.version <- paste0(R.Version()["major"],".",R.Version()["minor"]);
myLibrary <- file.path(".","library",current.version,"library");
if(!dir.exists(myLibrary)) { dir.create(path = myLibrary, recursive = TRUE); }

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
print("\n##### installation of BiocManager starts ...");
install.packages(
    pkgs         = c("BiocManager"),
    lib          = myLibrary,
    repos        = myRepoURL,
    dependencies = TRUE # c("Depends", "Imports", "LinkingTo", "Suggests")
    );
print("\n##### installation of BiocManager complete ...");

library(
    package        = "BiocManager",
    character.only = TRUE,
    lib.loc        = myLibrary
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
print("\n##### installation of Bioconductor packages starts ...");
BiocManager::install(
    pkgs         = c("BiocVersion","BiocStyle","graph","Rgraphviz","ComplexHeatmap"),
    lib          = myLibrary,
    dependencies = TRUE
    );
print("\n##### installation of Bioconductor packages complete ...");

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
# install desired R packages to
# user-specified library
print("\n##### installation of packages starts ...");
install.packages(
    pkgs         = pkgs.desired,
    lib          = myLibrary,
    repos        = myRepoURL,
    dependencies = TRUE # c("Depends", "Imports", "LinkingTo", "Suggests")
    );
print("\n##### installation of packages complete ...");

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.colnames <- c("Package","Version","License","License_restricts_use","NeedsCompilation","Built");
DF.installed.packages <- as.data.frame(installed.packages(lib = myLibrary)[,my.colnames]);

write.table(
    file      = "Rpackages-newlyInstalled.txt",
    x         = DF.installed.packages,
    sep       = "\t",
    quote     = FALSE,
    row.names = FALSE,
    col.names = TRUE
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
pkgs.notInstalled <- setdiff(
    pkgs.desired,
    as.character(installed.packages(lib = myLibrary)[,"Package"])
    );

write.table(
    file      = "Rpackages-notInstalled.txt",
    x         = data.frame(package.notInstalled = sort(pkgs.notInstalled)),
    quote     = FALSE,
    row.names = FALSE,
    col.names = TRUE
    );

###################################################
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
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
