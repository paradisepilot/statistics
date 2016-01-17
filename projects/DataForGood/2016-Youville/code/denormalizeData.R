
denormalizeData <- function(
	table.directory = NULL,
	 tmp.directory  = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.contacts <- get.denormalized.contacts(
		table.directory = table.directory
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	depositItems <- read.csv(file=paste0(table.directory,"/DepositItems.txt"),sep='|');

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

##################################################
get.denormalized.contacts <- function(table.directory = NULL) {

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
	cities <- read.csv(
		file = paste0(table.directory,"/Cities.txt"),
		sep  = '|',
		stringsAsFactors = FALSE
		);

	denormalized.contacts <- left_join(
		x  = denormalized.contacts,
		y  = cities,
		by = "CityID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	provinces <- read.csv(
		file = paste0(table.directory,"/Provinces.txt"),
		sep  = '|',
		stringsAsFactors = FALSE
		);

	colnames(provinces) <- gsub(
		x           = colnames(provinces), 
		pattern     = "Country",
		replacement = "Country(Province)"
		);


	denormalized.contacts <- left_join(
		x  = denormalized.contacts,
		y  = provinces,
		by = "ProvID"
		);

	print('str(denormalized.contacts)');
	print( str(denormalized.contacts) );

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(denormalized.contacts);

	}

