
filterRegroup <- function(DF.input = NULL) {

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.output <- DF.input;
	DF.output <- DF.output[DF.output[['Amount']]>0,];

	is.4000s  <- (3999.9999 < DF.output[,'AccountCode'] & DF.output[,'AccountCode'] < 5000);
	DF.output <- DF.output[is.4000s,];

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.output[,'depositItem.group']    <- character(length = nrow(DF.output));
	DF.output[,'char.AccountName']     <- as.character(DF.output[,'AccountName']);
	DF.output[,'char.ContactTypeMain'] <- as.character(DF.output[,'ContactTypeMain']);

	   majorAccountCodes <- c(4001,4002,4005,4013);
	is.majorAccountCodes <- DF.output[,'AccountCode'] %in% majorAccountCodes;

	DF.output[ is.majorAccountCodes,'depositItem.group'] <- DF.output[ is.majorAccountCodes,'char.AccountName'];
	DF.output[!is.majorAccountCodes,'depositItem.group'] <- DF.output[!is.majorAccountCodes,'char.ContactTypeMain'];

	DF.output[,'depositItem.group'] <- as.factor(DF.output[,'depositItem.group']);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.output <- DF.output[,setdiff(colnames(DF.output),c('char.AccountName','char.ContactTypeMain'))];

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(DF.output);

	}

