
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

	payment.type.CDs <- get.paymentTypeCDs(
		table.directory = table.directory
		);

	depts <- get.depts(
		table.directory = table.directory
		);

	donation.receipts <- get.donationReceipts(
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

	colnames(denormalized.depositItems) <- gsub(
		x           = colnames(denormalized.depositItems),
		pattern     = "D4G__DonationReceiptNum",
		replacement = "DonationReceiptID"
		);

	denormalized.depositItems[['estate_donation']] <- as.logical(
		denormalized.depositItems[['estate_donation']]
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = accounts,
		by = "AccountCode"
		);

	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = denormalized.contacts,
		by = "ContactID"
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
	print("str(denormalized.depositItems)");
	print( str(denormalized.depositItems) );
	print("str(donation.receipts)");
	print( str(donation.receipts) );

	denormalized.depositItems <- left_join(
		x  = denormalized.depositItems,
		y  = donation.receipts,
		by = "DonationReceiptID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	retained.columns <- setdiff(
		colnames(denormalized.depositItems),
		c("ReceiptID")
		);

	denormalized.depositItems <- denormalized.depositItems[,retained.columns];

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

