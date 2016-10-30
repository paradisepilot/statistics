
linkAdjust.logistic <- function(
	data,
	response,
	predictors,
	review,
	match
	) {


	selected.indices <- (data[,"review"] == 1) & (data[,"match"] == 1);
	print("data");
	print( data[selected.indices,] );

	return(data);

	}

