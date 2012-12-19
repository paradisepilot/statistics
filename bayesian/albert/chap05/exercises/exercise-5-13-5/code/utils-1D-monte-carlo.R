
compute.normalizing.constant <- function(log.pre.density = NULL, pre.density.parameters, grid.parameters = NULL) {

	###  set up grid used to compute normalizing constant (i.e. integral) for pre-density
	theta.grid <- generate.grid(
		xlimits            = grid.parameters[['xlimits']],
		relative.grid.size = grid.parameters[['relative.grid.size']]
		);

	### compute pre-density
	pre.densities <- exp(log.pre.density(
		theta = theta.grid, parameters = pre.density.parameters
		));

	###  compute value of area element
	x.length <- abs(diff(grid.parameters[['xlimits']]));
	length.element <- x.length * grid.parameters[['relative.grid.size']];

	###  compute normalizing constant (i.e.) for pre-density
	normalizing.constant <- length.element * sum(pre.densities);

	return(normalizing.constant);

	}

generate.bootstrap.sample <- function(sample.size = NULL, logf = NULL, xlimits = NULL, parameters = NULL) {

	grid.points   <- runif(n = sample.size, min = xlimits[1], max = xlimits[2]);
	log.posterior <- logf(theta = grid.points, parameters = parameters);

	index.sample <- sample(
		size    = sample.size,
		x       = 1:length(grid.points),
		prob    = exp(log.posterior),
		replace = TRUE
		);

	output.vector <- grid.points[index.sample];

	return(output.vector);

	}

generate.grid <- function(xlimits = NULL, relative.grid.size = NULL) {
	x.min   <-  xlimits[1];
	x.max   <-  xlimits[2];
	x.grid  <- x.min + (x.max - x.min) * seq(0,1,relative.grid.size);
	return(x.grid);
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
	is.within.grid  <- grid.parameters[['xlimits']][1] < proposal.sample & proposal.sample < grid.parameters[['xlimits']][2];
	proposal.sample <- proposal.sample[is.within.grid];

        target.density   <- as.numeric(target.pdf(
		log.pre.density        = log.pre.density,
		theta                  = proposal.sample,
		pre.density.parameters = pre.density.parameters,
		grid.parameters        = grid.parameters
		));
	print("summary(target.density)")
	print( summary(target.density) )

        proposal.density <- as.numeric(proposal.pdf(
		x          = proposal.sample,
		parameters = proposal.parameters
		));
	print("summary(proposal.density)")
	print( summary(proposal.density) )

        SIR.density <- target.density / proposal.density;
        SIR.density <- SIR.density / sum(SIR.density);

        row.index.sample <- sample(
                size    = SIR.sample.size,
                x       = 1:length(proposal.sample),
                prob    = SIR.density,
                replace = TRUE
                );

        SIR.sample <- proposal.sample[row.index.sample];

        return(SIR.sample);

        }

