
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

print(paste("myRepoURL",myRepoURL,sep=" = "));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
packagesNeeded    <- c("miniCRAN","yaml","igraph");
installedPackages <- installed.packages();
packagesToInstall <- setdiff(packagesNeeded,installedPackages[,"Package"]);
if (length(packagesToInstall) > 0) {
	install.packages(pkgs = packagesToInstall, repos = myRepoURL);
	}

require(yaml);
require(miniCRAN);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
 output.directory <- normalizePath(command.arguments[2]);
pkgs.desired.FILE <- normalizePath(command.arguments[3]);

setwd(output.directory);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
pkgs.desired <- yaml.load_file(input = pkgs.desired.FILE);
pkgs.desired <- names(pkgs.desired);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
pkgs.dependencies <- pkgDep(
	pkg   = pkgs.desired,
	repos = myRepoURL
	);

pkgs.dependencies;
n_all <- attr(x = pkgs.dependencies, which = "pkgs")[["n_all"]];

setdiff(n_all,pkgs.dependencies);

write.table(
	file      = "Rpackages.txt",
	x         = data.frame(package = sort(pkgs.dependencies)),
	quote     = FALSE,
	row.names = FALSE,
	col.names = FALSE
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#makeRepo(
#	pkgs  = pkgs.dependencies,
#	path  = output.directory,
#	repos = myRepoURL
#	);

###################################################
sessionInfo();
q();

