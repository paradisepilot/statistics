
get.geocodes <- function(
	locations     = NULL,
	tmp.directory = "tmp"
	) {

	require(ggmap);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	### define location of file of geocodes
	FILE.geocodes <- paste0(tmp.directory,"/geocodes.txt");

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	### read in file of previously downloaded
	### geocodes if it exists into a data frame,
	### otherwise initialize the data frame.
	if (file.exists(FILE.geocodes)) {
		DF.geocodes <- read.csv(file=FILE.geocodes,sep="\t");
		} else {
		DF.geocodes <- data.frame(
			location = character(length=0),
			lon      = numeric(  length=0),
			lat      = numeric(  length=0),
			stringsAsFactors = FALSE
			);
		}

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	new.locations <- setdiff(
		setdiff(unique(locations),c("")),
		DF.geocodes[,'location']
		);

	if (length(new.locations) > 0) {
		new.geocodes <- data.frame(
			location = as.character(new.locations),
			geocode(location = new.locations),
			stringsAsFactors = FALSE
			);
		DF.geocodes <- rbind(
			DF.geocodes,
			new.geocodes
			);
		}

	write.table(
		file      = FILE.geocodes,
		x         = DF.geocodes,
		row.names = FALSE,
		sep       = '\t',
		quote     = FALSE
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(DF.geocodes);

	}

