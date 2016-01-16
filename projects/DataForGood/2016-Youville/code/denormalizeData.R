
denormalizeData <- function(
	table.directory = NULL,
	 tmp.directory  = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	depositItems <- read.csv(file=paste0(table.directory,"/DepositItems.txt"),sep='|');

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contacts <- read.csv(file=paste0(table.directory,"/Contacts.txt"),sep='|');

	contacts[['DoNotContact']]    <- as.logical( contacts[['DoNotContact']]    );
	contacts[['DoNotMail']]       <- as.logical( contacts[['DoNotMail']]       );
	contacts[['BadEmailAddress']] <- as.logical( contacts[['BadEmailAddress']] );
	contacts[['BadAddress']]      <- as.logical( contacts[['BadAddress']]      );

	contacts[['DateOriginallyCreated']] <- cleanDates(
		dates = as.character(contacts[['DateOriginallyCreated']])
		);

	contacts[['PostalCode']] <- cleanPostalCodes(
		postal.codes = as.character(contacts[['PostalCode']])
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	### get (longitude,latitude) for postal/zip codes
	postal.codes <- unique(contacts[['PostalCode']]);
	DF.geocodes <- get.geocodes(
		locations     = postal.codes[1101:1200],
		tmp.directory = tmp.directory
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	colnames(DF.geocodes) <- gsub(
		x           = colnames(DF.geocodes), 
		pattern     = "location",
		replacement = "PostalCode"
		);

	denormalized.contacts <- left_join(
		x  = contacts,
		y  = DF.geocodes,
		by = "PostalCode"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.depositItems <- left_join(
		x  = depositItems,
		y  = denormalized.contacts,
		by = "ContactID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	LIST.output <- list(
		depositItems = denormalized.depositItems,
		contacts     = denormalized.contacts
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(LIST.output);

	}

