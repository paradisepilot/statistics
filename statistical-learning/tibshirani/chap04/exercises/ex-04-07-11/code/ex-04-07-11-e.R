
ex.04.07.11.e <- function(DF.training = NULL, DF.testing = NULL) {

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

	results.qda <- t(sapply(
		X   = dummy,
		FUN = function(x) {
			return(run.qda(DF.training = DF.training, DF.testing = DF.testing, input.formula = x))
			}
		));

	print("results.qda");
	print( results.qda );

	}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
run.qda <- function(
	DF.training   = NULL,
	DF.testing    = NULL,
	input.formula = NULL
	) {

	FIT <- qda(
		formula = as.formula(input.formula),
		data    = DF.training
		);

	temp <- as.data.frame(cbind(
		DF.testing,
		predicted = predict(object=FIT, newdata=DF.testing, type="response")[['class']]
		));

	temp <- xtabs(data = temp[,c('mpg01','predicted')], formula = ~ mpg01 + predicted);

	return( as.data.frame(get.performance.metrics(x = temp)) );

	}

