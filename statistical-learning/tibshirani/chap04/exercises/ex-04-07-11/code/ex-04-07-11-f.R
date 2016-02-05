
ex.04.07.11.f <- function(DF.training = NULL, DF.testing = NULL) {

	dummy <- paste0(
		"mpg01 ~ ",
		c(
			"acceleration",
			"cylinders",
			"displacement",
			"horsepower",
			"origin",
			"weight",
			"year",
			"cylinders + displacement",
			"weight + horsepower",
			"weight + displacement",
			"weight + cylinders",
			"weight + origin",
			"weight + year",
			"weight + cylinders + origin"
			)
		);

	results.logistic <- t(sapply(
		X   = dummy,
		FUN = function(x) {
			return(run.logistic(DF.training = DF.training, DF.testing = DF.testing, input.formula = x))
			}
		));

	print("results.logistic");
	print( results.logistic );

	}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
run.logistic <- function(
	DF.training   = NULL,
	DF.testing    = NULL,
	input.formula = NULL
	) {

	FIT <- glm(
		formula = as.formula(input.formula),
		data    = DF.training,
		family  = binomial
		);

	temp <- as.data.frame(cbind(
		DF.testing,
		predicted = as.numeric( predict(object=FIT, newdata=DF.testing, type="response") > 0.5 )
		));

	print("str(temp)");
	print( str(temp) );

	temp <- xtabs(data = temp[,c('mpg01','predicted')], formula = ~ mpg01 + predicted);

	return( as.data.frame(get.performance.metrics(x = temp)) );

	}

