
doPrimaryForeignKeyDiagnostics <- function(
	table.directory = NULL,
	 tmp.directory  = NULL
	) {

	require(dplyr);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	denormalized.contacts <- get.denormalized.contacts(table.directory = table.directory);
	deposits              <- get.deposits(table.directory = table.directory);
	accounts              <- get.accounts(table.directory = table.directory);
	payment.type.CDs      <- get.paymentTypeCDs(table.directory = table.directory);
	depts                 <- get.depts(table.directory = table.directory);
	donation.receipts     <- get.donationReceipts(table.directory = table.directory);
	contact.types         <- get.contact.types(table.directory = table.directory);

	deposit.items <- read.csv(
		file = paste0(table.directory,"/DepositItems.txt"),
		sep  = '|',
		stringsAsFactors = FALSE
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	print('str(deposit.items)');
	print( str(deposit.items) );
	print('str(donation.receipts)');
	print( str(donation.receipts) );

	print("Checking for presence duplications in deposit.items[['DepositItem']]:");
	print( length(deposit.items[['DepositItem']]) - length(unique(deposit.items[['DepositItem']])) );

	temp <- sort(deposit.items[,'DepositItem']);
	temp <- temp[duplicated(temp)];
	print("temp");
	print( temp );
	print( str(temp) );

	print("filter(deposit.items, 8325 < DepositItem & DepositItem < 8339)");
	print( filter(deposit.items, 8325 < DepositItem & DepositItem < 8339) );

	symmetric.diff(
		x.label = "deposit.items[['D4G__DonationReceiptNum']]",
		x       =  deposit.items[['D4G__DonationReceiptNum']],
		y.label = "donation.receipts[['DonationReceiptID']]",
		y       =  donation.receipts[['DonationReceiptID']]
		);

	}

##################################################

symmetric.diff <- function(
	x = NULL, x.label = NULL,
	y = NULL, y.label = NULL
	) {
	unique.x <- unique(x);
	unique.y <- unique(y);
	print(paste0("Verifying: ",x.label," = ",y.label));
	print(list(
		x.label         = x.label,
		y.label         = y.label,
		length.unique.x = length(unique.x),
		length.unique.y = length(unique.y),
		x.minus.y       = setdiff(unique.x,unique.y),
		y.minus.x       = setdiff(unique.y,unique.x)
		));
	}

