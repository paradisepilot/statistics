
compute.adjustments <- function(
    existing.portfolio    = NULL,
    new.contribution.rrsp = 0,
    new.contribution.tfsa = 0
    ) {
    
    new.contribution   <- new.contribution.rrsp + new.contribution.tfsa;
    target.total.value <- new.contribution + sum(existing.portfolio$market.value);
    print("target.total.value");
    print( target.total.value );
    
    names.of.target.investments <- rownames(existing.portfolio);
    target.num.of.investments   <- nrow(existing.portfolio);

    target.weights = existing.portfolio$target.proportion / sum(existing.portfolio$target.proportion);
    target.weights = as.data.frame(
        target.weights,
        row.names = names.of.target.investments
        );

    portfolio.adjustment <- get.portfolio.adjustment(
        existing.portfolio       = existing.portfolio,
        target.portfolio.weights = target.weights,
        target.portfolio.value   = target.total.value
        );

    target.market.values <- portfolio.adjustment$target.portfolio.value * portfolio.adjustment$target.portfolio.weights;
    colnames(target.market.values) <- "target.market.value";

    adjustments      <- as.matrix(portfolio.adjustment$adjustment.data.frame) %*% portfolio.adjustment$extended.original.portfolio$market.value;
    adjusted.values  <- portfolio.adjustment$extended.original.portfolio$market.value + adjustments;
    existing.values  <- portfolio.adjustment$extended.original.portfolio$market.value;
    inception.values <- portfolio.adjustment$extended.original.portfolio$book.value;
    fold             <- existing.values / inception.values;

    DF.adjustments <- cbind(
        adjustments,
        target.market.values,
        adjusted.values,
        existing.values,
        inception.values,
        fold
        );

    DF.adjustments <- cbind(
        investment = rownames(DF.adjustments),
        DF.adjustments
        );

    #sum(target.market.values);
    #sum(existing.values);
    #sum(inception.values);
    #sum(existing.values) / sum(inception.values);
    #sum(target.market.values) - sum(existing.values);
    #sum(adjustments);

	return(DF.adjustments);

    }
