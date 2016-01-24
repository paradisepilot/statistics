
plotDonationMap <- function(
	FILE.ggplot      = NULL,
	plot.title       = NULL,
	background.ggmap = NULL,
	DF.input         = NULL,
	contact.types    = levels(DF.donationReceipts[['ContactTypeMain']]),
	column.Longitude = NULL,
	column.Latitude  = NULL,
	column.Amount    = NULL,
	input.palette    = NULL,
	input.alpha      = 0.3,
	resolution       = 300
	) {

	require(dplyr);
	require(ggmap);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.temp <- DF.input[,c(
		column.Longitude,
		column.Latitude,
		column.Amount,
		'ContactTypeMain'
		)];

	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Longitude,
		replacement = "Longitude"
		);
	
	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Latitude,
		replacement = "Latitude"
		);
	
	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Amount,
		replacement = "Amount"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.temp <- na.omit(DF.temp);
	DF.temp <- filter(DF.temp,Amount > 0);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggmap <- ggmap(ggmap = background.ggmap, extent="device");
	my.ggmap <- my.ggmap + ggtitle(plot.title);

	my.ggmap <- my.ggmap + scale_colour_manual(
		name   = "Contact Type (Main)",
		values = input.palette
		);

	my.ggmap <- my.ggmap + scale_size(
		name   = "Contact\nDonation Amount\n(summed over time)"
		#, breaks = (1e4) * seq(0,10,2)
		);

	is.selected <- DF.temp[['ContactTypeMain']] %in% contact.types;
	DF.temp     <- na.omit(DF.temp[is.selected,]);

	my.ggmap <- my.ggmap + geom_point(
		data   = DF.temp,
		alpha  = input.alpha,
		mapping = aes(
			x     = Longitude,
			y     = Latitude,
			size  = Amount,
			color = ContactTypeMain
			)
		);

	my.ggmap <- my.ggmap + theme(
		title             = element_text(size = 25, face = "bold"),
		legend.position   = "right",
		legend.title      = element_text(size = 16, face = "bold"),
		legend.text       = element_text(size = 16, face = "bold")
		);

	ggsave(file = FILE.ggplot, plot = my.ggmap, dpi = resolution, height = 8, width = 12, units = 'in');

	}

############################################################
plotRetention <- function(
	FILE.ggplot   = NULL,
	plot.title    = NULL,
	DF.input      = NULL,
	contact.types = levels(DF.input[['ContactTypeMain']]),
	column.Date   = NULL,
	column.Amount = NULL,
	start.date    = "1996-07-01",
	end.date      = "2015-12-31",
	xlab.label    = "First Date",
	ylab.label    = "Most Recent Date",
	input.palette = NULL,
	input.alpha   = 0.2,
	resolution    = 300
	) {

	require(dplyr);
	require(ggmap);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.temp <- DF.input[,c('ContactID',column.Date,column.Amount,'ContactTypeMain')];

	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Date,
		replacement = "Date"
		);
	
	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Amount,
		replacement = "Amount"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.temp <- na.omit(DF.temp);
	DF.temp <- filter(DF.temp,Amount > 0);

	DF.temp[['ContactID']] <- as.character(DF.temp[['ContactID']]);
	DF.temp[is.na(DF.temp[['ContactID']]),'ContactID'] <- "No ContactID";
	DF.temp <- na.omit(DF.temp);

	by.ContactID <- group_by(DF.temp,ContactID,ContactTypeMain);
	DF.temp <- mutate(by.ContactID,
		minDate     = min(Date),
		maxDate     = max(Date),
		totalAmount = sum(Amount)
		);
	DF.temp <- unique(select(DF.temp,-Date,-Amount));

	is.onetimer <- as.logical(DF.temp[,'minDate'] == DF.temp[,'maxDate']);
	DF.temp[is.onetimer,'maxDate'] <- DF.temp[is.onetimer,'maxDate'] - sample(
		x=500:2000,size=sum(is.onetimer),replace=TRUE
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL) + theme_bw() + coord_fixed(ratio=1);
	my.ggplot <- my.ggplot + ggtitle(plot.title);
	my.ggplot <- my.ggplot + scale_colour_manual(
		name   = "Contact Type (Main)",
		values = input.palette
		);

	my.ggplot <- my.ggplot + scale_size(
		name   = "Contact\nDonation Amount\n(summed over time)"
		#, breaks = (1e6) * seq(0,20,10), range  = c(0,6)
		);

	is.selected <- DF.temp[['ContactTypeMain']] %in% contact.types;
	DF.temp     <- na.omit(DF.temp[is.selected,]);

	my.ggplot <- my.ggplot + geom_point(
		data    = DF.temp,
		mapping = aes(
			x     = minDate,
			y     = maxDate,
			size  = totalAmount,
			color = ContactTypeMain
			),
		alpha = input.alpha
		);

	my.ggplot <- my.ggplot + geom_abline(intercept = 0, slope = 1, size = 1, linetype = 2, colour = "gray");

	my.ggplot <- my.ggplot + scale_x_date(
		date_labels        = "%b %Y",
		limits             = c(as.Date(start.date),as.Date(end.date)),
		date_breaks        = "1 year"
		);
	my.ggplot <- my.ggplot + scale_y_date(
		date_labels        = "%b %Y",
		limits             = c(as.Date(start.date),as.Date(end.date)),
		date_breaks        = "1 year"
		);

	my.ggplot <- my.ggplot + xlab(xlab.label);
	my.ggplot <- my.ggplot + ylab(ylab.label);

	my.ggplot <- my.ggplot + theme(
		title             = element_text(size = 25, face = "bold"),
		axis.title        = element_text(size = 22, face = "bold"),
		axis.text.x       = element_text(size = 10, angle = 90),
		axis.text.y       = element_text(size = 10),
		panel.grid.major  = element_line(size = 0.5),
		panel.grid.minor  = element_line(size = 1.0),
		legend.position   = "right",
		legend.title      = element_text(size = 16, face = "bold"),
		legend.text       = element_text(size = 16, face = "bold")
		);

	ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = resolution, height = 8, width = 12, units = 'in');

	}

############################################################
plotCumulativeDonations <- function(
	FILE.ggplot   = NULL,
	plot.title    = NULL,
	DF.input      = NULL,
	contact.types = levels(DF.input[['ContactTypeMain']]),
	column.Date   = NULL,
	column.Amount = NULL,
	start.date    = "1996-07-01",
	end.date      = "2015-12-31",
	input.palette = NULL,
	resolution    = 300
	) {

	require(dplyr);
	require(ggmap);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.temp <- DF.input[,c(column.Date,column.Amount,'ContactTypeMain')];

	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Date,
		replacement = "Date"
		);
	
	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Amount,
		replacement = "Amount"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.temp <- na.omit(DF.temp);
	DF.temp <- filter(DF.temp,Amount > 0);

	DF.temp <- arrange(DF.temp,ContactTypeMain,Date);
	by.ContactTypeMain <- group_by(DF.temp,ContactTypeMain);
	DF.temp <- mutate(by.ContactTypeMain, cumulAmount = cumsum(Amount));

	DF.temp <- as.data.frame(DF.temp);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL);
	my.ggplot <- my.ggplot + ggtitle(plot.title);
	my.ggplot <- my.ggplot + theme_bw();
	my.ggplot <- my.ggplot + scale_colour_manual(
		name   = "Contact Type (Main)",
		values = input.palette
		);

	is.selected <- DF.temp[['ContactTypeMain']] %in% contact.types;
	DF.temp     <- na.omit(DF.temp[is.selected,]);

	my.ggplot <- my.ggplot + geom_line(
		data    = DF.temp,
		mapping = aes(
			x     = Date,
			y     = cumulAmount,
			color = ContactTypeMain
			),
		size = 0.75
		);

	my.ggplot <- my.ggplot + scale_x_date(
		date_labels        = "%b %Y",
		limits             = c(as.Date(start.date),as.Date(end.date)),
		date_breaks        = "1 year"
		);
	my.ggplot <- my.ggplot + xlab("");
	#my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2e6));
	my.ggplot <- my.ggplot + ylab("cumulative Amount");

	my.ggplot <- my.ggplot + theme(
		title            = element_text(size = 25,  face = "bold"),
		axis.title       = element_text(size = 25,  face = "bold"),
		axis.text.x      = element_text(size = 15, angle = 90),
		axis.text.y      = element_text(size = 15),
		panel.grid.major = element_line(size = 0.5),
		panel.grid.minor = element_line(size = 1.0),
		legend.position  = "bottom",
		legend.title     = element_blank(),
		legend.text      = element_text(size = 18, face = "bold")
		);

	ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	}

############################################################
plotAmountByDate <- function(
	FILE.ggplot   = NULL,
	plot.title    = NULL,
	DF.input      = NULL,
	contact.types = levels(DF.donationReceipts[['ContactTypeMain']]),
	column.Date   = NULL,
	column.Amount = NULL,
	start.date    = "1996-07-01",
	end.date      = "2015-12-31",
	input.palette = NULL,
	input.alpha   = 0.2,
	resolution    = 300
	) {

	require(dplyr);
	require(ggmap);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	#DF.temp <- DF.input[,c(
	#        'DonationReceiptDate',
	#        'DonationReceiptDonationAmount',
	#        'ContactTypeMain'
	#        )];

	DF.temp <- DF.input[,c(column.Date,column.Amount,'ContactTypeMain')];

	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Date,
		replacement = "Date"
		);
	
	colnames(DF.temp) <- gsub(
		x           = colnames(DF.temp),
		pattern     = column.Amount,
		replacement = "Amount"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.temp <- filter(DF.temp,Amount > 0);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	my.ggplot <- ggplot(data = NULL); 
	my.ggplot <- my.ggplot + ggtitle(plot.title);
	my.ggplot <- my.ggplot + theme_bw(); 
	my.ggplot <- my.ggplot + scale_colour_manual(
		name   = "Contact Type (Main)",
		values = input.palette
		);

	is.selected <- DF.temp[['ContactTypeMain']] %in% contact.types;
	DF.temp     <- na.omit(DF.temp[is.selected,]);

	my.ggplot <- my.ggplot + geom_point(
		data    = DF.temp,
		mapping = aes(
			x     = Date,
			y     = log10(Amount),
			color = ContactTypeMain
			),
		alpha = input.alpha
		);

	my.ggplot <- my.ggplot + scale_x_date(
		date_labels        = "%b %Y",
		limits             = c(as.Date(start.date),as.Date(end.date)),
		date_breaks        = "1 year"
		);

	temp.breaks <- seq(0,7.5,1);
	my.ggplot <- my.ggplot + scale_y_continuous(
		limits = c(min(temp.breaks),max(temp.breaks)),
		breaks = temp.breaks,
		labels = 10 ^ temp.breaks
		);

	my.ggplot <- my.ggplot + xlab("");
	my.ggplot <- my.ggplot + ylab("log10(Amount)");

	my.ggplot <- my.ggplot + theme(
		title            = element_text(size = 35,  face = "bold"),
		axis.title       = element_text(size = 25,  face = "bold"),
		axis.text.x      = element_text(size = 15, angle = 90),
		axis.text.y      = element_text(size = 15),
		panel.grid.major = element_line(size = 0.5),
		panel.grid.minor = element_line(size = 1.0),
		legend.position  = "bottom",
		legend.title     = element_blank(),
		legend.text      = element_text(size = 18, face = "bold")
		);

	ggsave(file = FILE.ggplot, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

	}

