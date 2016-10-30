
make.synthetic.data <- function(
	nobs,
	beta,
	errorRate,
	reviewFraction
	) {

	npredictors <- length(beta) - 1;

	X <- rbinom(
		n    = nobs * npredictors,
		size = 1,
		prob = 0.5
		);

	X <- matrix(data = X, nrow = nobs, byrow = TRUE);
	X <- cbind(rep(1,times=nobs),X);
	colnames(X) <- paste0("x",seq(0,npredictors));

	prY1.numerator <- exp(X %*% beta);
	prY1 <- prY1.numerator / (1 + prY1.numerator);
	response.vector <- rbinom(n = nobs, size = 1, prob = prY1);

	# match.vector  <- rbinom(n = nobs, size = 1, prob = 1 - errorRate);
	match.vector  <- sample(
		x       = c(TRUE,FALSE),
		size    = nobs,
		replace = TRUE,
		prob    = c(1-errorRate,errorRate)
		);

	# review.vector <- rbinom(n = nobs, size = 1, prob = reviewFraction);
	review.vector <- sample(
		x       = c(TRUE,FALSE),
		size    = nobs,
		replace = TRUE,
		prob    = c(reviewFraction,1-reviewFraction)
		);

	tempID <- seq(1,nobs);
	DF.output <- cbind(
		tempID,
		match.vector,
		tempID,
		response.vector,
		response.vector,
		X,
		review.vector,
		match.vector,
		prY1
		);
	colnames(DF.output) <- c(
		"ID",
		"true.match",
		"IDstar",
		"y.true",
		"y.observed",
		colnames(X),
		"review",
		"match",
		"prY1"
		);

	DF.matches    <- DF.output[DF.output[,"match"] == TRUE,];
	DF.nonmatches <- DF.output[DF.output[,"match"] == FALSE,];

	nrow.nonmatches <- nrow(DF.nonmatches);
	permuted.indices <- sample(
		x       = 1:nrow.nonmatches,
		size    = nrow.nonmatches,
		replace = FALSE
		);

	DF.nonmatches[,c("IDstar","y.observed")] <- DF.nonmatches[permuted.indices,c("IDstar","y.observed")]

	DF.output <- rbind(DF.matches,DF.nonmatches);
	DF.output <- DF.output[order(DF.output[,"ID"]),];

	DF.output[DF.output[,"review"] == FALSE,"match"] <- NA;

	return(DF.output);

	}

