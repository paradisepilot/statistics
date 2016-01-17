
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

	payment.type.CDs <- get.PaymentTypeCDs(
		table.directory = table.directory
		);

	depts <- get.Depts(
		table.directory = table.directory
		);

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

	colnames(denormalized.depositItems) <- gsub(
		x           = colnames(denormalized.depositItems),
		pattern     = "DeptNum",
		replacement = "DeptID"
		);

	denormalized.depositItems[['estate_donation']] <- as.logical(
		denormalized.depositItems[['estate_donation']]
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
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

	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = depts,
		by = "DeptID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.depositItems[['PaymentTypeCD']] <- as.character(
		x = denormalized.depositItems[['PaymentTypeCD']]
		);

	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = payment.type.CDs,
		by = "PaymentTypeCD"
		);

	denormalized.depositItems[['PaymentTypeCD']] <- as.factor(
		x = denormalized.depositItems[['PaymentTypeCD']]
		);

	colnames(denormalized.depositItems) <- gsub(
		x           = colnames(denormalized.depositItems),
		pattern     = "PaymentType",
		replacement = "DepositItemPaymentType"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	LIST.output <- list(
		depositItems = denormalized.depositItems,
		deposits     = deposits,
		contacts     = denormalized.contacts,
		accounts     = accounts
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(LIST.output);

	}

##################################################
get.Depts <- function(table.directory = NULL) {
	depts <- read.table(
		file             = paste0(table.directory,"/Dept.txt"),
		header           = TRUE,
		quote            = "",
		sep              = '|',
		stringsAsFactors = FALSE
		);
	depts[['ActiveField']] <- as.logical(
		x = depts[['ActiveField']]
		);
	depts[['DateCreated']] <- cleanDates(
		dates = as.character(depts[['DateCreated']])
		);
	depts[['DateDiscontinued']] <- cleanDates(
		dates = as.character(depts[['DateDiscontinued']])
		);
	colnames(depts) <- gsub(
		x           = colnames(depts),
		pattern     = "ActiveField",
		replacement = "DeptActiveField"
		);
	colnames(depts) <- gsub(
		x           = colnames(depts),
		pattern     = "Explanation.Info",
		replacement = "DeptExplanationInfo"
		);
	colnames(depts) <- gsub(
		x           = colnames(depts),
		pattern     = "DateCreated",
		replacement = "DeptDateCreated"
		);
	colnames(depts) <- gsub(
		x           = colnames(depts),
		pattern     = "DateDiscontinued",
		replacement = "DeptDateDiscontinued"
		);
	return(depts);
	}

get.PaymentTypeCDs <- function(table.directory = NULL) {
	payment.type.cds <- read.table(
		file             = paste0(table.directory,"/PaymentTypeCD.txt"),
		header           = TRUE,
		sep              = '|',
		stringsAsFactors = FALSE
		);
	colnames(payment.type.cds) <- gsub(
		x           = colnames(payment.type.cds),
		pattern     = "Payment.Type",
		replacement = "PaymentType"
		);
	return(payment.type.cds);
	}

get.contact.types <- function(table.directory = NULL) {

	contact.type.ID <- read.table(
		file   = paste0(table.directory,"/ContactTypeID.txt"),
		header = TRUE,
		sep    = '|'
		);

	contacts.to.type <- read.table(
		file   = paste0(table.directory,"/ContactsToType.txt"),
		header = TRUE,
		sep    = '|'
		);

	contact.types <- left_join(
		x  = contacts.to.type,
		y  = contact.type.ID,
		by = "ContactTypeID"
		);

	colnames(contact.types) <- gsub(
		x           = colnames(contact.types),
		pattern     = "note",
		replacement = "ContactTypeNote"
		);

	colnames(contact.types) <- gsub(
		x           = colnames(contact.types),
		pattern     = "type",
		replacement = "ContactTypeType"
		);

	return(contact.types);

	}

get.accounts <- function(table.directory = NULL) {

	accounts <- read.table(
		file         = paste0(table.directory,"/ACCPAC_Accounts.txt"),
		quote        = "",
		comment.char = "",
		header       = TRUE,
		sep          = '|'
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

	deposits[['Historical']]        <- as.logical(deposits[['Historical']]);
	deposits[['DepositRptPrinted']] <- as.logical(deposits[['DepositRptPrinted']]);

	deposits[['PreparedBy']] <- as.factor(deposits[['PreparedBy']]);

	deposits[['DepositDate']] <- cleanDates(
		dates = as.character(deposits[['DepositDate']])
		);

	colnames(deposits) <- gsub(
		x           = colnames(deposits), 
		pattern     = "Historical",
		replacement = "DepositHistorical"
		);

	colnames(deposits) <- gsub(
		x           = colnames(deposits), 
		pattern     = "ControlTotal",
		replacement = "DepositControlTotal"
		);

	colnames(deposits) <- gsub(
		x           = colnames(deposits), 
		pattern     = "PreparedBy",
		replacement = "DepositPreparedBy"
		);

	colnames(deposits) <- gsub(
		x           = colnames(deposits), 
		pattern     = "deposit_type_id",
		replacement = "DepositTypeID"
		);

	return(deposits);

	}

get.denormalized.contacts <- function(table.directory = NULL) {

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contacts <- read.table(
		file             = paste0(table.directory,"/Contacts.txt"),
		header           = TRUE,
		sep              = '|',
		stringsAsFactors = FALSE
		);

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

	colnames(contacts) <- gsub(
		x           = colnames(contacts), 
		pattern     = "DoNotContact",
		replacement = "ContactDoNotContact"
		);

	colnames(contacts) <- gsub(
		x           = colnames(contacts), 
		pattern     = "DoNotMail",
		replacement = "ContactDoNotMail"
		);

	colnames(contacts) <- gsub(
		x           = colnames(contacts), 
		pattern     = "BadEmailAddress",
		replacement = "ContactBadEmailAddress"
		);

	colnames(contacts) <- gsub(
		x           = colnames(contacts), 
		pattern     = "BadAddress",
		replacement = "ContactBadAddress"
		);

	colnames(contacts) <- gsub(
		x           = colnames(contacts), 
		pattern     = "PostalCode",
		replacement = "ContactPostalCode"
		);

	colnames(contacts) <- gsub(
		x           = colnames(contacts), 
		pattern     = "Country",
		replacement = "ContactCountry"
		);

	colnames(contacts) <- gsub(
		x           = colnames(contacts), 
		pattern     = "DateOriginallyCreated",
		replacement = "ContactDateOriginallyCreated"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contact.types <- get.contact.types(table.directory = table.directory);

	denormalized.contacts <- left_join(
		x  = contacts,
		y  = contact.types,
		by = "ContactID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	### get (longitude,latitude) for postal/zip codes
	postal.codes <- unique(contacts[['PostalCode']]);
	DF.geocodes <- get.geocodes(
		locations     = postal.codes[1:2653],
		tmp.directory = tmp.directory
		);

	colnames(DF.geocodes) <- gsub(
		x           = colnames(DF.geocodes), 
		pattern     = "location",
		replacement = "ContactPostalCode"
		);

	colnames(DF.geocodes) <- gsub(
		x           = colnames(DF.geocodes), 
		pattern     = "lon",
		replacement = "ContactLongitude"
		);

	colnames(DF.geocodes) <- gsub(
		x           = colnames(DF.geocodes), 
		pattern     = "lat",
		replacement = "ContactLatitude"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.contacts <- left_join(
		x  = denormalized.contacts,
		y  = DF.geocodes,
		by = "ContactPostalCode"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	cities <- read.csv(
		file = paste0(table.directory,"/Cities.txt"),
		sep  = '|',
		stringsAsFactors = FALSE
		);

	colnames(cities) <- paste0("Contact",colnames(cities));
	colnames(cities) <- gsub(
		x           = colnames(cities), 
		pattern     = "ContactCityID",
		replacement = "CityID"
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

	colnames(provinces) <- paste0("Contact",colnames(provinces));
	colnames(provinces) <- gsub(
		x           = colnames(provinces), 
		pattern     = "ContactProvID",
		replacement = "ProvID"
		);

	colnames(provinces) <- gsub(
		x           = colnames(provinces), 
		pattern     = "ContactCountry",
		replacement = "ContactProvinceCountry"
		);

	denormalized.contacts <- left_join(
		x  = denormalized.contacts,
		y  = provinces,
		by = "ProvID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contact.type.mains <- read.csv(
		file = paste0(table.directory,"/ContactTypeMain.txt"),
		sep  = '|'
		);

	denormalized.contacts <- left_join(
		x  = denormalized.contacts,
		y  = contact.type.mains,
		by = "ContactTypeMainID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	retained.columns <- setdiff(
		colnames(denormalized.contacts),
		c("CityID","ProvID","ContactTypeID","ContactTypeMainID")
		);

	denormalized.contacts <- denormalized.contacts[,retained.columns];

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(denormalized.contacts);

	}

