
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(ggmap);
library(RColorBrewer);

source(paste0(code.directory,'/denormalizeDepositItems.R'));
source(paste0(code.directory,'/denormalizeDonationReceipts.R'));
source(paste0(code.directory,'/doPrimaryForeignKeyDiagnostics.R'));
source(paste0(code.directory,'/getGeocodes.R'));
source(paste0(code.directory,'/getYouvilleData.R'));
source(paste0(code.directory,'/plottingFunctions.R'));
source(paste0(code.directory,'/utils.R'));

setwd(output.directory);

###################################################
resolution <- 300;

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FILE.geocodes <- paste0(table.directory,'/geocodes.txt');
DF.geocodes <- read.csv(
	file = FILE.geocodes,
	sep  = "\t",
	stringsAsFactors = FALSE
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
denormalized.donationReceipts <- denormalizeDonationReceipts(
	table.directory = table.directory,
	  tmp.directory =   tmp.directory,
	DF.geocodes     = DF.geocodes
	);

denormalized.depositItems <- denormalizeDepositItems(
	table.directory = table.directory,
	  tmp.directory =   tmp.directory,
	DF.geocodes     = DF.geocodes
	);

str(denormalized.donationReceipts);
str(denormalized.depositItems);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
palette.Youville <- getContactTypePalette();

DF.donationReceipts <- denormalized.donationReceipts[['denormalized.donationReceipts']];
DF.depositItems     <- denormalized.depositItems[['denormalized.depositItems']];

summary(DF.donationReceipts);
summary(DF.depositItems);

write.table(
	x         = DF.donationReceipts,
	file      = "denormalized-donationReceipts.csv",
	sep       = "|",
	quote     = TRUE,
	row.names = FALSE
	);

write.table(
	x         = DF.depositItems,
	file      = "denormalized-depositItems.csv",
	sep       = "|",
	quote     = TRUE,
	row.names = FALSE
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
zoom <- 12;
load(paste0(table.directory,"/ggmap-ottawa-zoom",zoom,".RData"));
str(ggmap.ottawa);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotDonationMap(
	FILE.ggplot      = "plot-donationReceipts-map-ALL.png",
	plot.title       = "Donation Receipts",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.donationReceipts,
	column.Longitude = 'DonationReceiptLongitude',
	column.Latitude  = 'DonationReceiptLatitude',
	column.Amount    = 'DonationReceiptDonationAmount',
	input.palette    = palette.Youville,
	input.alpha      = 0.2
	);

plotDonationMap(
	FILE.ggplot      = "plot-donationReceipts-map-individual.png",
	plot.title       = "Donation Receipts",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.donationReceipts,
	contact.types    = c("Personal/Individual"),
	column.Longitude = 'DonationReceiptLongitude',
	column.Latitude  = 'DonationReceiptLatitude',
	column.Amount    = 'DonationReceiptDonationAmount',
	input.palette    = palette.Youville,
	input.alpha      = 0.2
	);

plotDonationMap(
	FILE.ggplot      = "plot-donationReceipts-map-businessCharity.png",
	plot.title       = "Donation Receipts",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.donationReceipts,
	contact.types    = c("Corporate/Small Business","Registered Charity"),
	column.Longitude = 'DonationReceiptLongitude',
	column.Latitude  = 'DonationReceiptLatitude',
	column.Amount    = 'DonationReceiptDonationAmount',
	input.palette    = palette.Youville,
	input.alpha      = 0.3
	);

plotDonationMap(
	FILE.ggplot      = "plot-donationReceipts-map-unmatchedContactID.png",
	plot.title       = "Donation Receipts",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.donationReceipts,
	contact.types    = c("Unmatched ContactID"),
	column.Longitude = 'DonationReceiptLongitude',
	column.Latitude  = 'DonationReceiptLatitude',
	column.Amount    = 'DonationReceiptDonationAmount',
	input.palette    = brewer.pal(5,"Set1")[1],
	input.alpha      = 0.5
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotDonationMap(
	FILE.ggplot      = "plot-depositItems-map-ALL.png",
	plot.title       = "Deposit Items",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.depositItems,
	column.Longitude = "ContactLongitude",
	column.Latitude  = "ContactLatitude",
	column.Amount    = "Amount",
	input.palette    = palette.Youville,
	input.alpha      = 0.1
	);

plotDonationMap(
	FILE.ggplot      = "plot-depositItems-map-government.png",
	plot.title       = "Deposit Items",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.depositItems,
	contact.types    = c("Government"),
	column.Longitude = "ContactLongitude",
	column.Latitude  = "ContactLatitude",
	column.Amount    = "Amount",
	input.palette    = brewer.pal(5,"Set1")[1],
	input.alpha      = 1.0
	);

plotDonationMap(
	FILE.ggplot      = "plot-depositItems-map-individual.png",
	plot.title       = "Deposit Items",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.depositItems,
	contact.types    = c("Personal/Individual"),
	column.Longitude = "ContactLongitude",
	column.Latitude  = "ContactLatitude",
	column.Amount    = "Amount",
	input.palette    = palette.Youville,
	input.alpha      = 0.1
	);

plotDonationMap(
	FILE.ggplot      = "plot-depositItems-map-nonGovernmentIndividual.png",
	plot.title       = "Deposit Items",
	background.ggmap = ggmap.ottawa,
	DF.input         = DF.depositItems,
	contact.types    = setdiff(
		levels(DF.depositItems[['ContactTypeMain']]),
		c("Personal/Individual","Government")
		),
	column.Longitude = "ContactLongitude",
	column.Latitude  = "ContactLatitude",
	column.Amount    = "Amount",
	input.palette    = palette.Youville,
	input.alpha      = 0.2
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotRetention(
	FILE.ggplot   = 'plot-donationReceipts-retention-ALL.png',
	plot.title    = "Contacts (Donation Receipts)",
	DF.input      = DF.donationReceipts,
	column.Date   = "DonationReceiptDate",
	column.Amount = "DonationReceiptDonationAmount",
	xlab.label    = "First Donation Receipt Date",
	ylab.label    = "Most Recent Donation Receipt Date",
	input.palette = palette.Youville
	);

plotRetention(
	FILE.ggplot   = 'plot-donationReceipts-retention-unmatchedContactID.png',
	plot.title    = "Contacts (Donation Receipts)",
	DF.input      = DF.donationReceipts,
	contact.types = c("Unmatched ContactID"),
	column.Date   = "DonationReceiptDate",
	column.Amount = "DonationReceiptDonationAmount",
	xlab.label    = "First Donation Receipt Date",
	ylab.label    = "Most Recent Donation Receipt Date",
	input.palette = palette.Youville,
	input.alpha   = 1.0
	);

plotRetention(
	FILE.ggplot   = 'plot-donationReceipts-retention-individual.png',
	plot.title    = "Contacts (Donation Receipts)",
	DF.input      = DF.donationReceipts,
	contact.types = c("Personal/Individual"),
	column.Date   = "DonationReceiptDate",
	column.Amount = "DonationReceiptDonationAmount",
	xlab.label    = "First Donation Receipt Date",
	ylab.label    = "Most Recent Donation Receipt Date",
	input.palette = palette.Youville,
	input.alpha   = 0.2
	);

plotRetention(
	FILE.ggplot   = 'plot-donationReceipts-retention-businessCharity.png',
	plot.title    = "Contacts (Donation Receipts)",
	DF.input      = DF.donationReceipts,
	contact.types = c("Corporate/Small Business","Registered Charity"),
	column.Date   = "DonationReceiptDate",
	column.Amount = "DonationReceiptDonationAmount",
	xlab.label    = "First Donation Receipt Date",
	ylab.label    = "Most Recent Donation Receipt Date",
	input.palette = palette.Youville
	);

plotRetention(
	FILE.ggplot   = 'plot-donationReceipts-retention-others.png',
	plot.title    = "Contacts (Donation Receipts)",
	DF.input      = DF.donationReceipts,
	contact.types = setdiff(
		levels(DF.donationReceipts[,'ContactTypeMain']),
		c("Unmatched ContactID","Personal/Individual","Corporate/Small Business","Registered Charity")
		),
	column.Date   = "DonationReceiptDate",
	column.Amount = "DonationReceiptDonationAmount",
	xlab.label    = "First Donation Receipt Date",
	ylab.label    = "Most Recent Donation Receipt Date",
	input.palette = palette.Youville,
	input.alpha   = 0.5
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotRetention(
	FILE.ggplot   = 'plot-depositItems-retention-ALL.png',
	plot.title    = "Contacts (Deposit Items)",
	DF.input      = DF.depositItems,
	column.Date   = "DepositDate",
	column.Amount = "Amount",
	xlab.label    = "First Deposit Date",
	ylab.label    = "Most Recent Deposit Date",
	input.palette = palette.Youville
	);

plotRetention(
	FILE.ggplot   = 'plot-depositItems-retention-nonGovernmentIndividual.png',
	plot.title    = "Contacts (Deposit Items)",
	DF.input      = DF.depositItems,
	column.Date   = "DepositDate",
	column.Amount = "Amount",
	contact.types = setdiff(
		levels(DF.depositItems[,'ContactTypeMain']),
		c("Personal/Individual","Government")
		),
	xlab.label    = "First Deposit Date",
	ylab.label    = "Most Recent Deposit Date",
	input.palette = palette.Youville
	);

plotRetention(
	FILE.ggplot   = 'plot-depositItems-retention-individual.png',
	plot.title    = "Contacts (Deposit Items)",
	DF.input      = DF.depositItems,
	column.Date   = "DepositDate",
	column.Amount = "Amount",
	contact.types = c("Personal/Individual"),
	xlab.label    = "First Deposit Date",
	ylab.label    = "Most Recent Deposit Date",
	input.palette = palette.Youville
	);

plotRetention(
	FILE.ggplot   = 'plot-depositItems-retention-government.png',
	plot.title    = "Contacts (Deposit Items)",
	DF.input      = DF.depositItems,
	column.Date   = "DepositDate",
	column.Amount = "Amount",
	contact.types = c("Government"),
	xlab.label    = "First Deposit Date",
	ylab.label    = "Most Recent Deposit Date",
	input.palette = brewer.pal(5,"Set1")[1],
	input.alpha   = 1.0
	);

plotRetention(
	FILE.ggplot   = 'plot-depositItems-retention-businessCharity.png',
	plot.title    = "Contacts (Deposit Items)",
	DF.input      = DF.depositItems,
	column.Date   = "DepositDate",
	column.Amount = "Amount",
	contact.types = c("Corporate/Small Business","Registered Charity"),
	xlab.label    = "First Deposit Date",
	ylab.label    = "Most Recent Deposit Date",
	input.palette = palette.Youville
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotCumulativeDonations(
	FILE.ggplot   = 'plot-donationReceipts-cumulativeDontations.png',
	plot.title    = "Donation Receipts",
	DF.input      = DF.donationReceipts,
	column.Date   = 'DonationReceiptDate',
	column.Amount = 'DonationReceiptDonationAmount',
	input.palette = palette.Youville
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotCumulativeDonations(
	FILE.ggplot   = 'plot-depositItems-cumulativeDontations.png',
	plot.title    = "Deposit Items",
	DF.input      = DF.depositItems,
	column.Date   = 'DepositDate',
	column.Amount = 'Amount',
	input.palette = palette.Youville
	);

plotCumulativeDonations(
	FILE.ggplot   = 'plot-depositItems-cumulativeDontations-nonGov.png',
	plot.title    = "Deposit Items",
	DF.input      = DF.depositItems,
	contact.types = setdiff(
		levels(DF.depositItems[,'ContactTypeMain']),
		c("Government")
		),
	column.Date   = 'DepositDate',
	column.Amount = 'Amount',
	input.palette = palette.Youville
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotAmountByDate(
	FILE.ggplot   = "plot-donationReceipts-amountByDate-ALL.png",
	plot.title    = "Donation Receipts",
	DF.input      = DF.donationReceipts,
	column.Date   = 'DonationReceiptDate',
	column.Amount = 'DonationReceiptDonationAmount',
	input.palette = palette.Youville
	);

plotAmountByDate(
	FILE.ggplot   = "plot-donationReceipts-amountByDate-individual.png",
	plot.title    = "Donation Receipts",
	DF.input      = DF.donationReceipts,
	contact.types = c("Unmatched ContactID","Personal/Individual"),
	column.Date   = 'DonationReceiptDate',
	column.Amount = 'DonationReceiptDonationAmount',
	input.palette = palette.Youville
	);

plotAmountByDate(
	FILE.ggplot   = "plot-donationReceipts-amountByDate-businessCharity.png",
	plot.title    = "Donation Receipts",
	DF.input      = DF.donationReceipts,
	contact.types = c("Corporate/Small Business","Registered Charity"),
	column.Date   = 'DonationReceiptDate',
	column.Amount = 'DonationReceiptDonationAmount',
	input.palette = palette.Youville
	);

plotAmountByDate(
	FILE.ggplot   = "plot-donationReceipts-amountByDate-others.png",
	plot.title    = "Donation Receipts",
	DF.input      = DF.donationReceipts,
	contact.types = setdiff(
		levels(DF.donationReceipts[,'ContactTypeMain']),
		c("Unmatched ContactID","Personal/Individual","Corporate/Small Business","Registered Charity")
		),
	column.Date   = 'DonationReceiptDate',
	column.Amount = 'DonationReceiptDonationAmount',
	input.palette = palette.Youville,
	input.alpha   = 0.5
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
plotAmountByDate(
	FILE.ggplot   = "plot-depositItems-amountByDate-ALL.png",
	plot.title    = "Deposit Items",
	DF.input      = DF.depositItems,
	column.Date   = 'DepositDate',
	column.Amount = 'Amount',
	input.palette = palette.Youville,
	input.alpha   = 0.2
	);

plotAmountByDate(
	FILE.ggplot   = "plot-depositItems-amountByDate-individual.png",
	plot.title    = "Deposit Items",
	DF.input      = DF.depositItems,
	contact.types = c("Personal/Individual"),
	column.Date   = 'DepositDate',
	column.Amount = 'Amount',
	input.palette = palette.Youville
	);

plotAmountByDate(
	FILE.ggplot   = "plot-depositItems-amountByDate-businessCharity.png",
	plot.title    = "Deposit Items",
	DF.input      = DF.depositItems,
	contact.types = c("Corporate/Small Business","Registered Charity"),
	column.Date   = 'DepositDate',
	column.Amount = 'Amount',
	input.palette = palette.Youville
	);

plotAmountByDate(
	FILE.ggplot   = "plot-depositItems-amountByDate-government.png",
	plot.title    = "Deposit Items",
	DF.input      = DF.depositItems,
	contact.types = c("Government"),
	column.Date   = 'DepositDate',
	column.Amount = 'Amount',
	input.palette = brewer.pal(5,"Set1")[1],
	input.alpha   = 0.2
	);

plotAmountByDate(
	FILE.ggplot   = "plot-depositItems-amountByDate-others.png",
	plot.title    = "Deposit Items",
	DF.input      = DF.depositItems,
	contact.types = setdiff(
		levels(DF.depositItems[['ContactTypeMain']]),
		c("Personal/Individual","Government","Corporate/Small Business","Registered Charity")
		),
	column.Date   = 'DepositDate',
	column.Amount = 'Amount',
	input.palette = palette.Youville
	);

###################################################

q();

