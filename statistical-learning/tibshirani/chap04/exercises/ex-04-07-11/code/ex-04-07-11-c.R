
ex.04.07.11.c <- function(DF.training = NULL, DF.testing = NULL) {

	FIT.lda <- lda(
		formula = mpg01 ~ weight,
		data    = DF.training
		);

	temp <- as.data.frame(cbind(
		DF.testing,
		predicted = predict(object=FIT.lda, newdata=DF.testing, type="response")[['class']]
		));
	print("str(temp)");
	print( str(temp) );

	temp <- xtabs(data = temp[,c('mpg01','predicted')], formula = ~ mpg01 + predicted);

	print("get.performance.metrics(x = temp)");
	print( get.performance.metrics(x = temp) );

	}
