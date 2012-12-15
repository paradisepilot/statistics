
add.contour <- function(ggplot.obj = NULL, f = NULL, limits = NULL, data = NULL, grid.size = 1e-2, ...) {

	require(ggplot2);
	require(scales);

	x.min <- limits[1];
	x.max <- limits[2];
	y.min <- limits[3];
	y.max <- limits[4];

	x.gridpts <- x.min + (x.max - x.min) * seq(0,1,grid.size);
	y.gridpts <- y.min + (y.max - y.min) * seq(0,1,grid.size);

	DF.temp <- expand.grid(x = x.gridpts, y = y.gridpts);
	DF.temp <- cbind(
		DF.temp,
		z = apply(
			X      = as.matrix(DF.temp),
			MARGIN = 1,
			FUN    = function(p) {return(f(parameters = p, data = data));}
			)
		);

	ggplot.obj <- ggplot.obj + stat_contour(data = DF.temp, aes(x = x, y = y, z = z), ...);

	return(ggplot.obj);

	}

