
command.arguments <- commandArgs(trailingOnly = TRUE);
unicef.data.directories <- normalizePath(command.arguments[1]);
code.directory          <- normalizePath(command.arguments[2]);
output.directory        <- normalizePath(command.arguments[3]);
tmp.directory           <- normalizePath(command.arguments[4]);

####################################################################################################
library(foreign);
source(paste0(code.directory,'/spss-to-csv.R'));

####################################################################################################
DF.unicef <- read.table(
	file   = unicef.data.directories,
	header = TRUE,
	sep    = "\t",
	quote  = "",
	stringsAsFactors = FALSE
	);
DF.unicef[,'country'] <- tolower(DF.unicef[,'country']);
DF.unicef[,'country'] <- gsub(x = DF.unicef[,'country'], pattern = "\\.", replacement = "-");
DF.unicef;

####################################################################################################
setwd(output.directory);

for (i in 1:nrow(DF.unicef)) {

	paste0(rep("#",50),collapse = "");

	temp.country   <- DF.unicef[i,'country'];
	temp.directory <- DF.unicef[i,'directory'];

	print( paste0("country: ",temp.country) );

	temp.sub.directory <- list.dirs(path = temp.directory,recursive = FALSE);
	temp.files         <- list.files(path = temp.sub.directory, pattern = "\\.sav$");

	for (temp.file in temp.files) {
		temp.csv <- gsub(x = temp.file, pattern = "sav$", replacement = "csv");
		temp.csv <- paste0(temp.country,'-',temp.csv);
		DF.temp  <- read.spss(file = paste0(temp.sub.directory,"/",temp.file), to.data.frame = TRUE);
		write.table(file = temp.csv, x = DF.temp, sep = "\t", quote = FALSE, row.names = FALSE);
		}
     
	}

####################################################################################################

q();

