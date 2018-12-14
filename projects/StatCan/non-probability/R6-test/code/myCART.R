
require(R6);

myCART  <- R6Class(
    classname = "myCART",

    public = list(

        formula = NULL,
        data    = NULL,

        response           = NULL,
        predictors_factor  = NULL,
        predictors_numeric = NULL,

        nodes = list(),

        initialize = function(formula, data) {

            self$formula <- as.formula(formula);
            self$data    <- data;

            temp <- all.vars(self$formula);
            self$response      <- temp[1];
            colname_predictors <- temp[2];
            if (identical(".",colname_predictors)) {
                colname_predictors <- setdiff(colnames(self$data),c(self$response));
                }

            self$predictors_factor  <- colname_predictors[sapply(X=data[1,colname_predictors],FUN=is.factor )]
            self$predictors_numeric <- colname_predictors[sapply(X=data[1,colname_predictors],FUN=is.numeric)]

            cat("\nself$formula:\n")
            print( self$formula    )

            cat("\nstr(self$formula):\n")
            print( str(self$formula)    )

            cat("\nself$response\n");
            print( self$response   );

            cat("\nself$predictors_factor\n");
            print( self$predictors_factor   );

            cat("\nself$predictors_numeric\n");
            print( self$predictors_numeric   );

            remove(temp);

            },

        grow = function() {

            nodes      <- list();
            lastNodeID <- 0;

            workQueue <- list(
                private$node$new(parentID = -1, nodeID = lastNodeID, rowIndexes = seq(1,nrow(self$data)))
                );

            cat("\nworkQueue (initial)\n");
            print( workQueue );

            while (0 < length(workQueue)) {

                currentNode       <- private$pop(workQueue, envir = environment());
                cat("\nworkQueue (while)\n");
                print( workQueue );

                currentNodeID     <- currentNode$nodeID;
                currentParentID   <- currentNode$parentID;
                currentRowIndexes <- currentNode$rowIndexes;

                deduplicatedOutcomes <- unique(self$data[currentNode$rowIndexes,self$response]);
                cat("\ndeduplicatedOutcomes\n");
                print( deduplicatedOutcomes   );
                
                if (1 == length(deduplicatedOutcomes)) {
                    nodes <- private$push(
                        list = nodes,
                        x    = private$node$new(
                            nodeID     = currentNodeID,
                            parentID   = currentParentID,
                            rowIndexes = currentRowIndexes
                            )
                        );
                    }
                else {
                    bestSplit <- private$get_best_split(currentRowIndexes = currentRowIndexes);
                    cat("\nbestSplit:\n");
                    print( bestSplit );

                    satisfied    <- which(
                        bestSplit$comparison(self$data[currentRowIndexes,bestSplit$varname],bestSplit$threshold)
                        );
                    notSatisfied <- sort(setdiff(currentRowIndexes,satisfied));

                    lastNodeID       <- lastNodeID + 1;
                    satisfiedChildID <- lastNodeID;
                    workQueue        <- private$push(
                        list = workQueue,
                        x    = private$node$new(
                            parentID   = currentNodeID,
                            nodeID     = lastNodeID,
                            rowIndexes = satisfied
                            )
                        );

                    lastNodeID          <- lastNodeID + 1;
                    nonSatisfiedChildId <- lastNodeID;
                    workQueue           <- private$push(
                        list = workQueue,
                        x    = private$node$new(
                            parentID   = currentNodeID,
                            nodeID     = lastNodeID,
                            rowIndexes = notSatisfied
                            )
                        );

                    nodes <- private$push(
                        list = nodes,
                        x = private$node$new(
                            nodeID     = currentNodeID,
                            parentID   = currentParentID,
                            rowIndexes = currentRowIndexes,
                            criterion  = bestSplit
                            )
                        );
                    }
                } 

            print( "ZZZ" );
            return( NULL );

            },

        predict = function() {
            return( NULL );
            }

        ),

    private = list(
        pop = function(list, i = length(list), envir = NULL) {
            stopifnot(inherits(list, "list"))
            if (0 == length(list)) { return(NULL); }
            result <- list[[i]];
            assign(x = deparse(substitute(list)), value = list[-i], envir = envir);
            return( result );
            },
        push = function(list, x, i = length(list)) {
            stopifnot(inherits(list, "list"));
            return( c(list,list(x)) );
            },
        get_best_split = function(currentRowIndexes) {
            if (length(self$predictors_factor) > 0) {
                uniqueVarValuePairs_factor <- private$get_var_value_pairs(
                    x = apply(
                        X      = self$data[currentRowIndexes,self$predictors_factor],
                        MARGIN = 2,
                        FUN    = function(x) { return( sort(unique(x)) ); }
                        ),
                    comparison = private$is_equal_to
                    );
                #cat("\nuniqueVarValuePairs_factor\n")
                #print( uniqueVarValuePairs_factor   );
                }
            else {
                uniqueVarValuePairs_factor  <- list();
                };
            if (length(self$predictors_numeric) > 0) {
                uniqueVarValuePairs_numeric <- private$get_var_value_pairs(
                    x = apply(
                        X      = self$data[currentRowIndexes,self$predictors_numeric],
                        MARGIN = 2,
                        FUN    = function(x) { return( private$get_midpoints(sort(unique(x))) ); }
                        ),
                    comparison = private$is_less_than
                    );
                cat("\nuniqueVarValuePairs_numeric\n")
                print( uniqueVarValuePairs_numeric   );
                }
            else {
                uniqueVarValuePairs_numeric <- list();
                }
            uniqueVarValuePairs <- c(uniqueVarValuePairs_factor,uniqueVarValuePairs_numeric);
            temp <- lapply(
                X   = uniqueVarValuePairs,
                FUN = function(x) {
                    satisfied    <- which(x$comparison(self$data[currentRowIndexes,x$varname],x$threshold));
                    notSatisfied <- sort(setdiff(currentRowIndexes,satisfied));
                    p1 <- length(   satisfied) / length(currentRowIndexes);
                    p2 <- length(notSatisfied) / length(currentRowIndexes);
                    g1 <- private$gini_impurity(self$data[   satisfied,self$response]);
                    g2 <- private$gini_impurity(self$data[notSatisfied,self$response]);
                    return( p1 * g1 + p2 * g2 );
                    }
                );
            cat("\ntemp\n")
            print( temp   );
            return( uniqueVarValuePairs[[ which.min(temp) ]] );
            },
        get_midpoints = function(x) {
            if (is.character(x)) {
                return(x);
                }
            else {
                return( apply(X=data.frame(c1=x[2:length(x)],c2=x[1:(length(x)-1)]),MARGIN=1,FUN=mean) );
                }
            },
        get_var_value_pairs = function(x = NULL, comparison = NULL) {
            templist <- list();
            for (i in seq(1,length(x))) {
                for (j in seq(1,length(x[[i]]))) {
                    templist <- private$push(
                        list = templist,
                        x    = private$criterion$new(
                            varname    = names(x)[i],
                            threshold  = x[[i]][j],
                            comparison = comparison
                            )
                        );
                    }
                }
            return( templist );
            },
        is_less_than = function(x,y) {
            return(x < y)
            },
        is_equal_to = function(x,y) {
            return(x == y)
            },
        gini_impurity = function(x){
            p <- as.numeric(table(x) / length(x));
            return( sum(p * (1 - p)) );
            },
        criterion = R6Class(
            classname  = "criterion",
            public = list(
                varname    = NULL,
                threshold  = NULL,
                comparison = NULL,
                initialize = function(varname = NULL, threshold = NULL, comparison = NULL) {
                    self$varname    = varname;
                    self$threshold  = threshold;
                    self$comparison = comparison;
                    }
                )
            ),
        node = R6Class(
            classname = "node",

            public = list(

                nodeID     = NULL,
                rowIndexes = NULL,
                parentID   = NULL,
                criterion  = NULL,

                satisfiedChildID    = NULL,
                nonSatisfiedChildID = NULL,

                initialize = function(
                    nodeID          = NULL,
                    rowIndexes      = NULL,
                    parentID        = NULL,
                    criterion       = NULL,
                    satisfiedChildID    = NULL,
                    nonSatisfiedChildID = NULL
                    ) {
                        self$nodeID     <- nodeID;
                        self$rowIndexes <- rowIndexes;
                        self$parentID   <- parentID;
                        self$criterion  <- criterion;

                        self$satisfiedChildID    <- satisfiedChildID;
                        self$nonSatisfiedChildID <- nonSatisfiedChildID;
                    }
                )
            )

        )

    );

