
my.gtrends <- function(
	query,
	geo, 
	cat, 
	ch, 
	res = "week",
	start_date = as.Date("2004-01-01"),
	end_date = as.Date(Sys.time()),
	...
	) {

	require(RCurl);
	require(gtrendsR);

	if (missing(geo)) geo <- "";
	if (missing(cat)) cat <- "0";
	if (missing(ch))  ch  <- .getDefaultConnection();

	stopifnot(
		is.character(query),
		is.vector(query),
		all(res %in% c("week", "day")),
		length(res) == 1,
		length(query) <= 5
		);
  
	if(is.null(ch)) {
		stop("You are not signed in. Please log in using gconnect().", call. = FALSE);
		}
  
	## Verify the dates
	start_date <- as.Date(start_date, "%Y-%m-%d");
	end_date <- as.Date(end_date, "%Y-%m-%d");
  
	if (is.na(start_date)) {
		stop("start_date is not a valide date. Please use yyyy-mm-dd format.", call. = FALSE);
		} 
  
	if (is.na(end_date)) {
		stop("end_date is not a valide date. Please use yyyy-mm-dd format.", call. = FALSE);
		} 
  
	# date verification
	stopifnot(
		start_date < end_date, 
		start_date >= as.Date("2004-01-01"), # cant be earlier than 2004
		end_date   <= as.Date(Sys.time())    # cant be more than current date
		) 
  
	# if resolution is day then maximum date difference must be less than 3 months
	nmonth <- length(seq(from = start_date, to = end_date, by = "month"));
  
	if(res == "day" & nmonth > 3){
		stop("Maximum of 3 months allowed with daily resolution.", call. = FALSE);
		}
  
	query <- paste(query, collapse = ",");
  
	## Change encoding to utf-8
	query <- iconv(query, "latin1", "utf-8", sub = "byte");
  
	if (inherits(ch, "CURLHandle") != TRUE) {
		stop("'ch' arguments has to be result from 'gconnect()'.", call. = FALSE);
		}
  
	data(countries, envir = environment());
  
	countries[,1] <- as.character(countries[,1]);
	countries[,2] <- as.character(countries[,2]);
	countries[which(countries[,"COUNTRY"] == "Namibia"),"CODE"] <- "NA";
  
	if (geo != "" && !geo %in% countries[, "CODE"]) {
		stop("Country code not valid. Please use 'data(countries)' to retreive valid codes.", call. = FALSE);
		}
  
	authenticatePage2 <- getURL("http://www.google.com", curl = ch);
  
	trendsURL <- "http://www.google.com/trends/trendsReport?";

	res <- paste(nmonth, "m", sep = "");
  
	pp <- list(
		cat     = cat,
		q       = query, 
		cmpt    = "q",
		content = 1, 
		export  = 1,
		date    = paste(format(start_date, "%m/%Y"), res),
		geo     = geo
		);
  
	# http://www.google.com/trends/trendsReport?&q=%2Cfoo%2Cbar%2Cbaz%2Cfoo&cmpt=q&content=1&export=1&date=1%2F2015%202m
  
	resultsText <- getForm(trendsURL, .params = pp, curl = ch);
  
	if (any(grep("QUOTA", resultsText))) {
		stop("Reached Google Trends quota limit! Please try again later.");
		}

	queryparams <- c(
		query = query, 
		cat   = cat, 
		geo   = geo, 
		time  = format(Sys.time())
		);
  
	res <- gtrendsR:::.processResults(resultsText, queryparams);

	class(res) <- c("gtrends", "list");
    
	res;

	}

