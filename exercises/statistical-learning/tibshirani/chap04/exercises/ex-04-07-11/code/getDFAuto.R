
get.DFauto <- function() {

	DF.auto <- cbind(
		Auto,
		mpg01 = as.numeric(Auto[['mpg']] > median(Auto[['mpg']]))
		);
	DF.auto[['year']] <- as.Date(paste0(1900+DF.auto[['year']],"-01-01"));
	DF.auto[['year']] <- DF.auto[['year']] + sample(x=seq(-50,50,1),size=nrow(Auto),replace=TRUE);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	temp <- as.character(DF.auto[['name']]);
	temp <- as.character(sapply(X=temp,FUN=function(x){return(strsplit(x," ")[[1]][1])}));

	DF.auto[['manufacturer']] <- as.character(sapply(
		X   = as.character(DF.auto[['name']]),
		FUN = function(x){return(strsplit(x," ")[[1]][1])}
		));

	DF.auto[['manufacturer']] <- gsub(
		x           = DF.auto[['manufacturer']],
		pattern     = "maxda",
		replacement = "mazda"
		);

	DF.auto[['manufacturer']] <- gsub(
		x           = DF.auto[['manufacturer']],
		pattern     = "toyouta",
		replacement = "toyota"
		);

	DF.auto[['manufacturer']] <- gsub(
		x           = DF.auto[['manufacturer']],
		pattern     = "vw",
		replacement = "volkswagen"
		);

	DF.auto[['manufacturer']] <- gsub(
		x           = DF.auto[['manufacturer']],
		pattern     = "vokswagen",
		replacement = "volkswagen"
		);

	DF.auto[['manufacturer']] <- as.factor(DF.auto[['manufacturer']]);

	return(DF.auto);

	}

