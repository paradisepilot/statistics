
ex.04.07.11.g <- function(DF.training = NULL, DF.testing = NULL) {

	dummy <- c(1,2,4,8,16);
	results.knn <- t(sapply(
		X   = dummy,
		FUN = function(x) {
			return(run.knn(DF.training = DF.training, DF.testing = DF.testing, nNeighbours = x))
			}
		));
	row.names(results.knn) <- dummy;

	print("results.knn");
	print( results.knn );

	}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
run.knn <- function(
	DF.training = NULL,
	DF.testing  = NULL,
	nNeighbours = NULL
	) {

	#predictors <- c("cylinders","displacement","horsepower","weight","acceleration","year","origin");
	predictors <- c("cylinders","displacement","horsepower","weight");

	FIT <- knn(
		train = DF.training[,predictors],
		cl    = DF.training[,"mpg01"],
		test  = DF.testing[,predictors],
		k     = nNeighbours
		);

	temp <- as.data.frame(cbind(
		DF.testing,
		predicted = as.integer(as.character(FIT))
		));

	temp <- xtabs(data = temp[,c('mpg01','predicted')], formula = ~ mpg01 + predicted);

	return( as.data.frame(get.performance.metrics(x = temp)) );

	}

