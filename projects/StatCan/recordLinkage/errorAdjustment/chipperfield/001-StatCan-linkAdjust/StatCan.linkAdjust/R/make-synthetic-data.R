
make.synthetic.data <- function(
	nobs,
	beta
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

	DF.output <- cbind(
		response.vector,
		X,
		prY1
		);
	colnames(DF.output) <- c("y",colnames(X),"prY1");

	return(DF.output);

	}

