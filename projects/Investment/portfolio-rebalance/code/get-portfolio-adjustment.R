
get.portfolio.adjustment <- function(
        existing.portfolio = NULL,
        target.portfolio.weights = NULL,
        target.portfolio.value = NULL
        ) {

	all.investment.names <- union(rownames(existing.portfolio),rownames(target.portfolio.weights));

	names.investments.to.remove <- setdiff(all.investment.names,rownames(target.portfolio.weights));
	target.weights.investments.to.remove <- as.data.frame(
		matrix(0,nrow=length(names.investments.to.remove),ncol=length(colnames(target.portfolio.weights))),
		row.names = names.investments.to.remove
		);
	colnames(target.weights.investments.to.remove) <- colnames(target.portfolio.weights);
	target.weights.investments.to.remove;

	all.target.weights <- rbind(target.portfolio.weights,target.weights.investments.to.remove);

	all.target.weights <- as.data.frame(
		all.target.weights[all.investment.names,],
		row.names = all.investment.names
		);
	colnames(all.target.weights) <- colnames(target.portfolio.weights)
	all.target.weights;

	names.investments.to.add <- setdiff(all.investment.names,rownames(existing.portfolio));
	investments.to.add <- as.data.frame(
		matrix(0,nrow=length(names.investments.to.add),ncol=length(colnames(existing.portfolio))),
		row.names = names.investments.to.add
		);
	colnames(investments.to.add) <- colnames(existing.portfolio);
	investments.to.add;
	extended.original.portfolio <- rbind(
		existing.portfolio,
		investments.to.add
		);
	extended.original.portfolio;

	y <- (target.portfolio.value*all.target.weights)$target.weights; y;
	x <- extended.original.portfolio$market.value;

	A <- get.adjustment.matrix(original = x, target = y); A;

	adjustment.DF <- as.data.frame(A);
	rownames(adjustment.DF) <- all.investment.names;
	colnames(adjustment.DF) <- all.investment.names;

	to.return <- list(
		target.portfolio.value = target.portfolio.value,
        	target.portfolio.weights = all.target.weights,
		extended.original.portfolio = extended.original.portfolio,
		adjustment.data.frame = adjustment.DF
		);

	return(to.return);

	}

