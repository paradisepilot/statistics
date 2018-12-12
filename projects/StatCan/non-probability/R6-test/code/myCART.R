
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

                currentNode       <- private$pop(workQueue,env=environment());
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
        pop = function(list, i = length(list), envir) {
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
        get_best_split = function() {
            #temp1 <- rnorm(5);
            #temp1 <- sort(temp1);
            #apply(X=data.frame(c1=temp1[2:length(temp1)],c2=temp1[1:(length(temp1)-1)]),MARGIN=1,FUN=mean)
            return( NULL );
            }
        )

    );

