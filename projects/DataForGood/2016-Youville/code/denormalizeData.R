
denormalizeData <- function(
	table.directory = NULL,
	 tmp.directory  = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	depositItems <- read.csv(file=paste0(table.directory,"/DepositItems.txt"),sep='|');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contacts     <- read.csv(file=paste0(table.directory,"/Contacts.txt"),    sep='|');
	contacts[['PostalCode']] <- as.character(contacts[['PostalCode']]);
	postal.codes <- unique(contacts[['PostalCode']]);
	print('postal.codes');
	print( postal.codes[1:10] );

	DF.geocodes <- get.geocodes(
		locations     = postal.codes[1:10],
		tmp.directory = tmp.directory
		);
	print('DF.geocodes');
	print( DF.geocodes );

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

	return(LIST.output);

	}

