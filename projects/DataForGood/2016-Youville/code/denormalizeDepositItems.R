
denormalizeDepositItems <- function(
	table.directory = NULL,
	 tmp.directory  = NULL,
	DF.geocodes     = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.contacts <- get.contacts(
		table.directory = table.directory,
		DF.geocodes     = DF.geocodes
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
		table.directory = table.directory,
		DF.geocodes     = DF.geocodes
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.depositItems <- get.depositItems(
		table.directory = table.directory
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
		denormalized.depositItems = denormalized.depositItems,
		deposits                  = deposits,
		contacts                  = denormalized.contacts,
		accounts                  = accounts
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(LIST.output);

	}

