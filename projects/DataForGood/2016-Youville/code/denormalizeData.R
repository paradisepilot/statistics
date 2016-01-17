
denormalizeData <- function(
	table.directory = NULL,
	 tmp.directory  = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.contacts <- get.denormalized.contacts(
		table.directory = table.directory
		);

	deposits <- get.deposits(
		table.directory = table.directory
		);

	accounts <- get.accounts(
		table.directory = table.directory
		);

	print('str(accounts)');
	print( str(accounts) );

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.depositItems <- read.csv(
		file = paste0(table.directory,"/DepositItems.txt"),
		sep  = '|'
		);

	colnames(denormalized.depositItems) <- gsub(
		x           = colnames(denormalized.depositItems),
		pattern     = "AccountNum",
		replacement = "AccountCode"
		);

	denormalized.depositItems[['estate_donation']] <- as.logical(
		denormalized.depositItems[['estate_donation']]
		);

	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = denormalized.contacts,
		by = "ContactID"
		);

	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = accounts,
		by = "AccountCode"
		);

	print('setdiff(deposits$DepositNum,denormalized.depositItems$DepositNum)');
	print( setdiff(deposits$DepositNum,denormalized.depositItems$DepositNum) );

	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = deposits,
		by = "DepositNum"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	LIST.output <- list(
		depositItems = denormalized.depositItems,
		deposits     = deposits,
		contacts     = denormalized.contacts
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(LIST.output);

	}

##################################################
get.accounts <- function(table.directory = NULL) {

	accounts <- read.table(
		file             = paste0(table.directory,"/ACCPAC_Accounts.txt"),
		quote            = "",
		comment.char     = "",
		header           = TRUE,
		sep              = '|',
		stringsAsFactors = FALSE
		);

	colnames(accounts) <- gsub(
		x           = colnames(accounts),
		pattern     = "AccountNumber",
		replacement = "AccountCode"
		);

	return(accounts);

	}

get.deposits <- function(table.directory = NULL) {

	deposits <- read.table(
		file             = paste0(table.directory,"/Deposits.txt"),
		quote            = "",
		comment.char     = "",
		header           = TRUE,
		sep              = '|',
		stringsAsFactors = FALSE
		);

	deposits <- deposits[,setdiff(colnames(deposits),'DepositNotes')];
	deposits[['DepositDate']] <- cleanDates(
		dates = as.character(deposits[['DepositDate']])
		);
	deposits[['Historical']] <- as.logical(deposits[['Historical']]);
	deposits[['DepositRptPrinted']] <- as.logical(deposits[['DepositRptPrinted']]);

	return(deposits);

	}

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
		locations     = postal.codes[1:2000],
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

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(denormalized.contacts);

	}

