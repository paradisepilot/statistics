
cleanPostalCodes <- function(postal.codes = NULL) {

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	cleaned.postal.codes <- as.character(sapply(
		X   = postal.codes,
		FUN = clean.single.postal.code
		));

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(cleaned.postal.codes);

	}

##################################################
clean.single.postal.code <- function(postal.code = NULL) {

	if (grepl(pattern = "[0-9]{9}", x = postal.code)) {
		return(paste0(substr(x=postal.code,start=1,stop=5),'-',substr(x=postal.code,start=6,stop=9)));
		} else {
		return(postal.code);
		}

	}

