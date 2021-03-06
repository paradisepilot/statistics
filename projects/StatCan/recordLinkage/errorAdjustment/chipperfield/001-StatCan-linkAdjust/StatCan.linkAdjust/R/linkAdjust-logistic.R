
linkAdjust.logistic <- function(
	data,
	response,
	predictors,
	review,
	match,
	tolerance = 1e-5,
	max.iter  = 1000
	) {

	DF.data <- .attach.Pxystar(
		data       = as.data.frame(data),
		response   = response,
		predictors = predictors,
		match      = match
		);

	beta.im1 <- .initialize.beta(
		data       = DF.data,
		response   = response,
		predictors = predictors,
		review     = review,
		match      = match
		);

	results.expectation <- .step.expectation(
		beta       = beta.im1,
		data       = DF.data,
		response   = response,
		predictors = predictors,
		review     = review,
		match      = match
		);

	results.maximization <- .step.maximization(
		beta0      = beta.im1,
		data       = results.expectation,
		response   = "y.expected",
		predictors = predictors
		);

	beta.i <- results.maximization[['estimate']];

	i <- 1;
	not.converged <- TRUE;
	while (i < max.iter & not.converged) {

		beta.im1 <- beta.i;

		results.expectation <- .step.expectation(
			beta       = beta.im1,
			data       = DF.data,
			response   = response,
			predictors = predictors,
			review     = review,
			match      = match
			);

		results.maximization <- .step.maximization(
			beta0      = beta.im1,
			data       = results.expectation,
			response   = "y.expected",
			predictors = predictors
			);

		i      <- i + 1;
		beta.i <- results.maximization[['estimate']];
		not.converged <- ( sqrt(sum((beta.i - beta.im1)^2)) > tolerance );

		}

	parameter.estimates <- results.maximization[['estimate']];
	attributes(parameter.estimates) <- list(names=c('Intercept',predictors));

	list.output <- list(
		estimates   = parameter.estimates,
		nIterations = i,
		converged   = (!not.converged),
		input       = list(
			data       = data,
			response   = response,
			predictors = predictors,
			review     = review,
			match      = match,
			tolerance  = tolerance,
			max.iter   = max.iter
			)
		);

	return( list.output );

	}

########

.attach.Pxystar <- function(
	data,
	response,
	predictors,
	match
	) {

	require(dplyr);

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

	selected.indices <- (DF.output[,review] == FALSE);
	DF.output[selected.indices,"y.expected"] <-
		DF.output[selected.indices,"Pxystar"] * DF.output[selected.indices,response]
		+ (1 - DF.output[selected.indices,"Pxystar"]) * DF.output[selected.indices,"pi.temp"];

	return(DF.output);

	}

.initialize.beta <- function(
	data,
	response,
	predictors,
	match,
	review
	) {

	selected.indices <- (data[,review] == TRUE) & (data[,match] == TRUE);

	temp.formula = paste0(response," ~ ",paste(predictors,collapse=" + "));
	temp.formula = as.formula(temp.formula);

	results.glm <- glm(
		formula = temp.formula,
		data    = as.data.frame(data[selected.indices,c(response,predictors)]),
		family  = binomial(link="logit")
		);

	return( coefficients(results.glm) );

	}

.step.maximization <- function(
	beta0,
	data,
	response,
	predictors,
	tolerance = 1e-6,
	max.iter  = 1000
	) {

	require(stats);

	y <- as.numeric(data[,response]);
	X <- as.matrix(cbind(rep(1,nrow(data)),data[,predictors]));

	logL <- function(beta) {

		XB       <- X %*% beta;
		PiB      <- 1/(1+exp(-XB));
		DB       <- PiB*(1-PiB);
		logL.out <- sum( - apply(X=XB,MARGIN=2,FUN=function(u){u*y}) + log(1+exp(XB)) );

		attr(logL.out,"gradient") <- t(X) %*% (PiB - y);
		attr(logL.out,"hessian")  <- t(X) %*% apply(X=X,MARGIN=2,FUN=function(u){u*DB});

		return(logL.out);

		}

	results.nlm <- nlm(
		f = logL,
		p = beta0
		); 

	return(results.nlm);

	}

