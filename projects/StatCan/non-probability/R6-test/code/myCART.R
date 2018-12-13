
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
                myNode$new(parentID = -1, nodeID = lastNodeID, rowIndexes = seq(1,nrow(self$data)))
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
                    nodes <- push(
                        list = nodes,
                        x    = myNode$new(
                            nodeID     = currentNodeID,
                            parentID   = currentParentID,
                            rowIndexes = currentRowIndexes
                            )
                        );
                    }
                else {
                    bestSplit <- private$get_best_split(currentRowIndexes = currentRowIndexes);
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
                uniqueVarValuePairs_factor <- apply(
                    X      = self$data[currentRowIndexes,self$predictors_factor],
                    MARGIN = 2,
                    FUN    = function(x) { return( sort(unique(x)) ); }
                    );
                cat("\nuniqueVarValuePairs_factor\n")
                print( uniqueVarValuePairs_factor   );
                };
            if (length(self$predictors_numeric) > 0) {
                uniqueVarValuePairs_numeric <- apply(
                    X      = self$data[currentRowIndexes,self$predictors_numeric],
                    MARGIN = 2,
                    FUN    = function(x) { return( private$get_midpoints(sort(unique(x))) ); }
                    );
                cat("\nuniqueVarValuePairs_numeric\n")
                print( uniqueVarValuePairs_numeric   );
                }
            return( NULL );
            },
        get_midpoints = function(x) {
            if (is.character(x)) {
                return(x);
                }
            else {
                return( apply(X=data.frame(c1=x[2:length(x)],c2=x[1:(length(x)-1)]),MARGIN=1,FUN=mean) );
                }
            }
        )

    );

