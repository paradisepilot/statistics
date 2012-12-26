
generate.bootstrap.sample <- function(sample.size = NULL, log.pre.density = NULL, parameter.limits = NULL, pre.density.parameters = NULL) {

	grid.points <- matrix(nrow = sample.size, ncol = nrow(parameter.limits));
	colnames(grid.points) <- rownames(parameter.limits);

	for (parameter.name in rownames(parameter.limits)) {
		grid.points[,parameter.name] <- runif(
			n   = sample.size,
			min = parameter.limits[parameter.name,'min'],
			max = parameter.limits[parameter.name,'max']
			);
		}

	log.posterior <- log.pre.density(
		model.parameters = grid.points,
		prior.and.data   = pre.density.parameters
		);

	row.resample <- sample(
		size    = sample.size,
		x       = 1:nrow(grid.points),
		prob    = exp(log.posterior),
		replace = TRUE
		);

	output <- grid.points[row.resample,];

	return(output);

	}

