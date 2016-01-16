
denormalizeData <- function(
	table.directory = NULL,
	 tmp.directory  = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	depositItems <- read.csv(file=paste0(table.directory,"/DepositItems.txt"),sep='|');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contacts <- read.csv(file=paste0(table.directory,"/Contacts.txt"),sep='|');
	contacts[['PostalCode']] <- as.character(contacts[['PostalCode']]);

	postal.codes <- cleanPostalCodes( postal.codes = unique(contacts[['PostalCode']]) );

	DF.geocodes <- get.geocodes(
		locations     = postal.codes[1101:1200],
		tmp.directory = tmp.directory
		);
	print('DF.geocodes');
	print( DF.geocodes );

	temp <- cleanPostalCodes(postal.codes = postal.codes);
	temp <- data.frame(x=temp,y=rep(".",length(temp)),stringsAsFactors=FALSE);
	print('temp[1101:1200,]');
	print( temp[1101:1200,] );

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	temp <- left_join(
		x  = depositItems,
		y  = contacts,
		by = "ContactID"
		);

	print('str(temp)');
	str(temp);

	LIST.output <- list(
		depositItems = depositItems,
		contacts     = contacts
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(LIST.output);

	}

