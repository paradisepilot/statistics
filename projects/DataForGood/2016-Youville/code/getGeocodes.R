
get.geocodes <- function(
	locations     = NULL,
	FILE.geocodes = "geocodes.txt"
	) {

	require(ggmap);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	### read in file of previously downloaded
	### geocodes if it exists into a data frame,
	### otherwise initialize the data frame.
	if (file.exists(FILE.geocodes)) {
		DF.geocodes <- read.csv(
			file = FILE.geocodes,
			sep  = "\t",
			stringsAsFactors = FALSE
			);
		} else {
		DF.geocodes <- data.frame(
			location = character(length=0),
			lon      = numeric(  length=0),
			lat      = numeric(  length=0),
			stringsAsFactors = FALSE
			);
		}

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.geocodes[,'location'] <- toupper(DF.geocodes[,'location']);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	locations <- cleanPostalCodes(postal.codes = locations);

	new.locations <- setdiff(
		setdiff(unique(toupper(locations)),c("",NA)),
		DF.geocodes[,'location']
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
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
		write.table(
			file      = FILE.geocodes,
			x         = DF.geocodes,
			row.names = FALSE,
			sep       = '\t',
			quote     = FALSE
			);
		}

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(DF.geocodes);

	}

