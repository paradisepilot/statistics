
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
require(LearnBayes);
require(ggplot2);
require(scales);
require(coda);
#require(sn);

source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

### AUXILIAR FUNCTIONS #############################################################################
log.pre.density.exchangeable.prior <- function(model.parameters = NULL, hyperparameters = NULL) {
        
	alpha <- hyperparameters[['alpha']];
	a     <- hyperparameters[['a']];
	b     <- hyperparameters[['b']];

	output.value <- NULL;
	if (is.null(dim(model.parameters))) {

		lambda <- model.parameters;
		temp1  <- (alpha - 1) * log(prod(lambda));
		temp2  <- (2 * alpha + a) * log(alpha * sum(lambda) + b);

		output.value <- temp1 - temp2;

		} else {

		output.value <- numeric(nrow(model.parameters));
		for (i in 1:length(output.value)) {

			lambda <- model.parameters[i,];
			temp1  <- (alpha - 1) * log(prod(lambda));
			temp2  <- (2 * alpha + a) * log(alpha * sum(lambda) + b);

			output.value[i] <- temp1 - temp2;

			}

		}

	return(output.value);

        }

####################################################################################################
str(hearttransplants);
summary(hearttransplants);
# hearttransplants;

### Fig. 7.5, p.162 ################################################################################
grid.parameters <- list(
        xlimits            = c(0.001,5),
        ylimits            = c(0.001,5),
        relative.grid.size = 2^(-6)  # 2^(-8)
        );

model.parameters.grid <- generate.grid(
        xlimits            = grid.parameters[['xlimits']],
        ylimits            = grid.parameters[['ylimits']],
        relative.grid.size = grid.parameters[['relative.grid.size']]
        );
nrow.model.parameters.grid <- nrow(model.parameters.grid);

alphas <- c(5,20,80,400);

DF.contour <- as.data.frame(matrix(nrow=length(alphas)*nrow.model.parameters.grid,ncol=5));
colnames(DF.contour) <- c('lambda1','lambda2','log.pre.density','facet.x','facet.y');

for (i in 1:length(alphas)) {

	facet.x <- 1 +((i-1) %/% 2);
	facet.y <- 1 +((i-1) %%  2);

	current.row.indexes <- seq(
		1 + (i-1) * nrow.model.parameters.grid,
		i * nrow.model.parameters.grid,
		1
		);

	hyperparameters <- list(alpha = alphas[i], a = 10, b = 10);
	DF.contour[current.row.indexes,] <- as.data.frame(cbind(
	        model.parameters.grid,
	        log.pre.density = log.pre.density.exchangeable.prior(
	                model.parameters = model.parameters.grid,
	                hyperparameters  = hyperparameters
	                ),
		facet.x = rep(facet.x,nrow.model.parameters.grid),
		facet.y = rep(facet.y,nrow.model.parameters.grid)
	        ));

	}
summary(DF.contour);

png("Fig7-05.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + stat_contour(
	data     = DF.contour,
	mapping  = aes(x = lambda1, y = lambda2, z = log.pre.density),
	binwidth = 2.5
	);
my.ggplot <- my.ggplot + facet_grid(facet.x ~ facet.y);
my.ggplot <- my.ggplot + xlim(0,5) + ylim(0,5);
my.ggplot;
dev.off();

####################################################################################################

q();

