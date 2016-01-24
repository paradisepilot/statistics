
cleanPostalCodes <- function(postal.codes = NULL) {
	cleaned.postal.codes <- as.character(sapply(
		X   = toupper(postal.codes),
		FUN = clean.single.postal.code
		));
	return(cleaned.postal.codes);
	}

cleanDates <- function(dates = NULL) {
	cleaned.dates <- dates;
	cleaned.dates[cleaned.dates == ""] <- NA;
	return(as.Date(cleaned.dates));
	}

cleanContactTypeLabels <- function(input.factor = NULL) {
	
	temp.levels <- c(levels(input.factor),"Unknown Contact Type","Unmatched ContactID");
	temp.labels <- temp.levels;

	temp.labels <- gsub(
		x           = temp.labels,
		pattern     = "Corporate or Small Business",
		replacement = "Corporate/Small Business"
		);

	temp.labels <- gsub(
		x           = temp.labels,
		pattern     = "Foundation",
		replacement = "Foundation"
		);

	temp.labels <- gsub(
		x           = temp.labels,
		pattern     = "Government \\(mun,prov,fed\\)",
		replacement = "Government"
		);

	temp.labels <- gsub(
		x           = temp.labels,
		pattern     = "NPOs \\(club,school,association\\) NOT REGISTERED",
		replacement = "NPO"
		);

	temp.labels <- gsub(
		x           = temp.labels,
		pattern     = "Personal-Individual",
		replacement = "Personal/Individual"
		);

	temp.labels <- gsub(
		x           = temp.labels,
		pattern     = "Registered Charity \\(MUST have #\\)",
		replacement = "Registered Charity"
		);

	output.factor <- factor(
		x      = input.factor,
		levels = temp.levels,
		labels = temp.labels
		);

	return(output.factor);

	}

getContactTypePalette <- function() {

	require(RColorBrewer);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contact.types <- c(
		"***D4G EDIT*** No PK",
		"Corporate/Small Business",
		"Foundation",
		"Government",
		"Interest/Other",
		"NPO",
		"Personal/Individual",
		"Registered Charity",
		"Unknown Contact Type",
		"Unmatched ContactID"
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	contact.colours <- c(
		'grey',   # ***D4G EDIT*** No PK
		'red',    # corporate/small business
		'brown',  # foundation
		'green',  # government
		'cyan',   # Interest/Other
		'purple', # NPO
		'black',  # individual
		'blue',   # registered charity
		'gold',   # unknown contact type
		'pink'    # unmatched ContactID
		);

	#temp.colours <- brewer.pal(9,"Set1")[c(9,1:8)];
	#contact.colours <- c(
	#	temp.colours[1:4],
	#	"white",
	#	temp.colours[5:9]
	#	);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.colourScheme <- data.frame(
		ContactTypeMain   = contact.types,
		ContactTypeColour = contact.colours,
		stringsAsFactors = FALSE
		);
	
	DF.colourScheme[['ContactTypeColour']] <- as.character(DF.colourScheme[['ContactTypeColour']]);

	output.palette <- as.character(DF.colourScheme[['ContactTypeColour']]);
	names(output.palette) <- as.character(DF.colourScheme[['ContactTypeMain']]);

	return(output.palette);

	}

##################################################
clean.single.postal.code <- function(postal.code = NULL) {
	if (grepl(pattern = "[0-9]{9}", x = postal.code)) {
		return(paste0(substr(x=postal.code,start=1,stop=5),'-',substr(x=postal.code,start=6,stop=9)));
		} else {
		return(postal.code);
		}
	}

