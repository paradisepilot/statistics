
getSamples <- function(DF.population = NULL, prob.selection = 0.1) {

    # ~~~~~~~~~~ #
    is.selected <- sample(
        x       = c(TRUE,FALSE),
        size    = nrow(DF.population),
        replace = TRUE,
        prob    = c(prob.selection,1-prob.selection)
        );

    DF.probability <- DF.population[is.selected,c("x1","x2")];
    DF.probability[,"weight"] <- 1 / prob.selection;

    # ~~~~~~~~~~ #
    DF.non.probability <- DF.population;
    DF.non.probability[,"self.select"] <- sapply(
        X   = DF.non.probability[,"propensity"],
        FUN = function(x) { sample(x=c(0,1),size=1,prob=c(1-x,x)) }
        );

    DF.non.probability <- DF.non.probability[1 == DF.non.probability[,"self.select"],c("ID","y","x1","x2")]

    # ~~~~~~~~~~ #
    LIST.output <- list(
            probability.sample = DF.probability,
        non.probability.sample = DF.non.probability
        );

    return(LIST.output);

    }

