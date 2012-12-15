
my.simcontour <- function(logf = NULL, limits = NULL, data = NULL, m = NULL) {

	grid.points <- data.frame(
		x = runif(n = m, min = limits[1], max = limits[2]),
		y = runif(n = m, min = limits[3], max = limits[4])
		); 

	log.posterior <- apply(
		X      = grid.points,
		MARGIN = 1,
		FUN    = function(v) {return(logf(parameters = v, data = data));}
		);

	posterior <- exp(log.posterior);
	posterior <- posterior / sum(posterior);

	row.sample <- sample(size = m, x = 1:nrow(grid.points), prob = posterior, replace = TRUE);
	DF.temp <- grid.points[row.sample,];
	LIST.output <- list(x = DF.temp[,1], y = DF.temp[,2]);

	return(LIST.output);

	}

