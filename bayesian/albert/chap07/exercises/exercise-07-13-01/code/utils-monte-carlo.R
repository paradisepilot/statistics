
compute.normalizing.constant <- function(log.pre.density = NULL, pre.density.parameters, grid.parameters = NULL) {

	###  set up grid used to compute normalizing constant (i.e. integral) for pre-density
	theta.grid <- generate.grid(
		xlimits            = grid.parameters[['xlimits']],
		ylimits            = grid.parameters[['ylimits']],
		relative.grid.size = grid.parameters[['relative.grid.size']]
		);

	### compute pre-density
	pre.densities <- exp(log.pre.density(
		model.parameters = theta.grid, prior.and.data = pre.density.parameters
		));

	###  compute value of area element
	x.length <- abs(diff(grid.parameters[['xlimits']]));
	y.length <- abs(diff(grid.parameters[['ylimits']]));
	area.element <- x.length * y.length * grid.parameters[['relative.grid.size']]^2;

	###  compute normalizing constant (i.e.) for pre-density
	normalizing.constant <- area.element * sum(pre.densities);

	return(normalizing.constant);

	}

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

generate.grid <- function(xlimits = NULL, ylimits = NULL, relative.grid.size = NULL) {
	x.min   <-  xlimits[1];
	x.max   <-  xlimits[2];
	y.min   <-  ylimits[1];
	y.max   <-  ylimits[2];
	x.grid  <- x.min + (x.max - x.min) * seq(0,1,relative.grid.size);
	y.grid  <- y.min + (y.max - y.min) * seq(0,1,relative.grid.size);
	xy.grid <- expand.grid(x = x.grid, y = y.grid);
	return(xy.grid);
	}

target.pdf <- function(log.pre.density = NULL, theta = NULL, pre.density.parameters = NULL, grid.parameters = NULL) {

	###  compute normalizing constant (i.e.) for pre-density
	normalizing.constant <- compute.normalizing.constant(
		log.pre.density        = log.pre.density,
		pre.density.parameters = pre.density.parameters,
		grid.parameters        = grid.parameters
		);

	###  compute output value (i.e. posterior density)
	log.density <- log.pre.density(theta = theta, parameters = pre.density.parameters);
	density     <- exp(log.density) / normalizing.constant;

	return(density);

	}

perform.SIR <- function(log.pre.density = NULL, target.pdf = NULL, pre.density.parameters = NULL, grid.parameters = NULL, proposal.pdf = NULL, rproposal = NULL, proposal.parameters = NULL, proposal.sample.size = NULL, SIR.sample.size = NULL) {

        proposal.sample <- rproposal(
		sample.size = proposal.sample.size,
		parameters  = proposal.parameters
		);

        target.density   <- target.pdf(
		log.pre.density        = log.pre.density,
		theta                  = proposal.sample,
		pre.density.parameters = pre.density.parameters,
		grid.parameters        = grid.parameters
		);

        proposal.density <- proposal.pdf(
		x          = proposal.sample,
		parameters = proposal.parameters
		);

        SIR.density <- target.density / proposal.density;
        SIR.density <- SIR.density / sum(SIR.density);

        row.index.sample <- sample(
                size    = SIR.sample.size,
                x       = 1:nrow(proposal.sample),
                prob    = SIR.density,
                replace = TRUE
                );

        SIR.sample <- proposal.sample[row.index.sample,];

        return(SIR.sample);

        }

