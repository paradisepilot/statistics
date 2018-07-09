
bugs.chains <- function(input.mcmc.list) {

	num.of.chains     <- length(input.mcmc.list);
	num.of.parameters <- ncol(input.mcmc.list[[1]]);
	chain.length      <- nrow(input.mcmc.list[[1]]);

	MATRIX.output <- matrix(nrow = chain.length * num.of.chains, ncol = num.of.parameters);
	colnames(MATRIX.output) <- colnames(input.mcmc.list[[1]])

	for (i in 1:num.of.chains) {
		row.indexes <- seq(1+(i-1)*chain.length,i*chain.length,1);
		MATRIX.output[row.indexes,] <- input.mcmc.list[[i]];
		}

	return(MATRIX.output);

	}

