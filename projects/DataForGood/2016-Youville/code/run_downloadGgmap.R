
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(ggmap);

source(paste0(code.directory,'/denormalizeDepositItems.R'));
source(paste0(code.directory,'/denormalizeDonationReceipts.R'));
source(paste0(code.directory,'/doPrimaryForeignKeyDiagnostics.R'));
source(paste0(code.directory,'/getGeocodes.R'));
source(paste0(code.directory,'/getYouvilleData.R'));
source(paste0(code.directory,'/utils.R'));

setwd(output.directory);

###################################################
resolution <- 300;

for (z in c(5:20)) {

	print( paste0("zoom = ",z) ); 

	ggmap.ottawa <- get_map("ottawa", zoom = z);

	temp.filename <- paste0("ggmap-ottawa-zoom",z,".RData");
	save(list = c("ggmap.ottawa"), file = temp.filename);

	temp.filename <- paste0("gmap-ottawa-zoom",z,".png");
	my.ggmap <- ggmap(ggmap = ggmap.ottawa, extent="device");
	ggsave(file = temp.filename, plot = my.ggmap, dpi = resolution, height = 8, width = 8, units = 'in');

	}

###################################################

