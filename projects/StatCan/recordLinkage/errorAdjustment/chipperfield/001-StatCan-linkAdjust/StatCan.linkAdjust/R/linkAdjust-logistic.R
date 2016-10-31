
linkAdjust.logistic <- function(
	data,
	response,
	predictors,
	review,
	match,
	tolerence = 1e-5,
	max.iter  = 1000
	) {

	DF.data <- .augment.Pxystar(
		data       = as.data.frame(data),
		response   = response,
		predictors = predictors
		);

	print("DF.data[1:100,]");
	print( DF.data[1:100,] );

	return(DF.data);

	beta.im1 <- .initialize.beta(
		data       = DF.data,
		response   = response,
		predictors = predictors
		);

	print("beta.im1");
	print( beta.im1 );

	results.expectation <- .step.expectation(
		beta       = beta.im1,
		data       = DF.data,
		response   = response,
		predictors = predictors,
		review     = review,
		match      = match
		);

	print("str(results.expectation)");
	print( str(results.expectation) );

#	i <- 1;
#	while (i < max.iter & norm(beta.im1-beta.i,type="F") > tolerance) {
#
#		}

	return(data);

	}

########

.augment.Pxystar <- function(
	data,
	response,
	predictors
	) {

	require(dplyr);

	print("head(data)");
	print( head(data) );

	DF.output <- cbind(
		data,
		xystar = apply(
			X      = data[,c(response,predictors)],
			FUN    = function(u) {paste0(u,collapse="")},
			MARGIN = 1
			)
		);

	DF.xystar <- DF.output %>%
		filter(review == TRUE) %>%
		group_by(xystar) %>%
		summarize(count.match=sum(match),count.total=n())
		;

	DF.xystar <- as.data.frame(DF.xystar);
	DF.xystar <- cbind(
		DF.xystar,
		Pxystar = DF.xystar[,"count.match"] / DF.xystar[,"count.total"]
		);
	rownames(DF.xystar) <- DF.xystar[,"xystar"];

	print("DF.xystar");
	print( DF.xystar );

	DF.output <- cbind(
		DF.output,
		Pxystar = DF.xystar[DF.output[,"xystar"],"Pxystar"]
		);

	return(DF.output);

	}

.step.expectation <- function(
	beta,
	data,
	response,
	predictors,
	review,
	match
	) {

	DF.output <- as.data.frame(data);
	DF.output <- cbind(
		DF.output,
		y.expected = DF.output[,response],
		pi.temp = 1 / (1+exp(as.matrix(cbind(rep(1,nrow(DF.output)),DF.output[,predictors])) %*% (-beta)))
		);

	selected.indices <- (DF.output[,review] == TRUE) & (DF.output[,match] == FALSE);
	DF.output[selected.indices,"y.expected"] <- DF.output[selected.indices,"pi.temp"];

	return(DF.output);

	}

.initialize.beta <- function(
	data,
	response,
	predictors
	) {

	selected.indices <- (data[,"review"] == TRUE) & (data[,"match"] == TRUE);

	temp.formula = paste0(response," ~ ",paste(predictors,collapse=" + "));
	temp.formula = as.formula(temp.formula);

	results.glm <- glm(
		formula = temp.formula,
		data   = as.data.frame(data[selected.indices,c(response,predictors)]),
		family = binomial(link="logit")
		);

	print("summary(results.glm)");
	print( summary(results.glm) );

	return( coefficients(results.glm) );

	}

.step.maximization <- function() {

	}

