
denormalizeDonationReceipts <- function(
	table.directory = NULL,
	 tmp.directory  = NULL,
	DF.geocodes     = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.contacts <- get.denormalized.contacts(
		table.directory = table.directory,
		DF.geocodes     = DF.geocodes
		);

	deposits <- get.deposits(
		table.directory = table.directory
		);

	payment.type.CDs <- get.paymentTypeCDs(
		table.directory = table.directory
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.donationReceipts <- get.donationReceipts(
		table.directory = table.directory
		);

	colnames(denormalized.donationReceipts) <- gsub(
		x           = colnames(denormalized.donationReceipts),
		pattern     = "DonationReceiptContactID",
		replacement = "ContactID"
		);

	colnames(denormalized.donationReceipts) <- gsub(
		x           = colnames(denormalized.donationReceipts),
		pattern     = "DonationReceiptDepositNum",
		replacement = "DepositNum"
		);

	colnames(denormalized.donationReceipts) <- gsub(
		x           = colnames(denormalized.donationReceipts),
		pattern     = "DonationReceiptPaymentTypeCD",
		replacement = "PaymentTypeCD"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.donationReceipts <- left_join(
		x  = denormalized.donationReceipts,
		y  = denormalized.contacts,
		by = "ContactID"
		);

	denormalized.donationReceipts <- left_join(
		x  = denormalized.donationReceipts,
		y  = deposits,
		by = "DepositNum"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.donationReceipts[['PaymentTypeCD']] <- as.character(
		x = denormalized.donationReceipts[['PaymentTypeCD']]
		);

	denormalized.donationReceipts <- left_join(
		x  = denormalized.donationReceipts,
		y  = payment.type.CDs,
		by = "PaymentTypeCD"
		);

	denormalized.donationReceipts[['PaymentTypeCD']] <- as.factor(
		x = denormalized.donationReceipts[['PaymentTypeCD']]
		);

	colnames(denormalized.donationReceipts) <- gsub(
		x           = colnames(denormalized.donationReceipts),
		pattern     = "PaymentType",
		replacement = "DepositItemPaymentType"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	LIST.output <- list(
		denormalized.donationReceipts = denormalized.donationReceipts,
		deposits                      = deposits,
		contacts                      = denormalized.contacts
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(LIST.output);

	}

