
require(R6);

myCART  <- R6Class(
    classname = "myCART",

    public = list(

        formula = NULL,
        data    = NULL,

        response           = NULL,
        predictors         = NULL,
        predictors_factor  = NULL,
        predictors_numeric = NULL,

        syntheticID = NULL,
        nodes       = NULL,

        initialize = function(formula, data) {

            self$formula <- as.formula(formula);
            self$data    <- data;

            temp <- all.vars(self$formula);
            self$response   <- temp[1];
            self$predictors <- temp[2];
            if (identical(".",self$predictors)) {
                self$predictors <- setdiff(colnames(self$data),c(self$response));
                }

            for (temp.colname in self$predictors) {
                if (is.character(self$data[,temp.colname])) {
                    self$data[,temp.colname] <- as.factor(self$data[,temp.colname]);
                    }
                }

            self$predictors_factor  <- self$predictors[sapply(X=data[1,self$predictors],FUN=is.factor )]
            self$predictors_numeric <- self$predictors[sapply(X=data[1,self$predictors],FUN=is.numeric)]

            # add custom row ID:
            self$syntheticID <- paste0(sample(x=letters,size=10,replace=TRUE),collapse="");
            self$data[,self$syntheticID] <- seq(1,nrow(self$data));

            remove(temp);

            },

        grow = function() {

            self$nodes <- list();
            lastNodeID <- 0;

            workQueue <- list(
                private$node$new(
                    parentID = -1,
                    nodeID   = lastNodeID,
                    depth    = 0,
                    rowIDs   = self$data[,self$syntheticID]
                    )
                );

            while (0 < length(workQueue)) {

                cat( "\n### ~~~~~~~~~~ ###" );
                cat( paste0("\nlength(workQueue): ",length(workQueue),"\n") );
                # print( workQueue );

                currentNode <- private$pop(workQueue, envir = environment());

                currentNodeID          <- currentNode$nodeID;
                currentParentID        <- currentNode$parentID;
                currentDepth           <- currentNode$depth;
                currentRowIDs          <- currentNode$rowIDs;
                current_birthCriterion <- currentNode$birthCriterion;

                cat("\ncurrentNode:");
                print( currentNode );

                if (private$stoppingCriterionSatisfied(currentRowIDs)) {
                    self$nodes <- private$push(
                        list = self$nodes,
                        x    = private$node$new(
                            nodeID         = currentNodeID,
                            parentID       = currentParentID,
                            depth          = currentDepth,
                            rowIDs         = currentRowIDs,
                            birthCriterion = current_birthCriterion
                            )
                        );
                    }
                else {

                    cat("\ncurrentRowIDs:\n");
                    print( currentRowIDs    );

                    bestSplit <- private$get_best_split(currentRowIDs = currentRowIDs);
                    cat("\nbestSplit:\n");
                    print( bestSplit );

                    satisfied <- self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$syntheticID][
                        bestSplit$comparison(
                            self$data[self$data[,self$syntheticID] %in% currentRowIDs,bestSplit$varname],
                            bestSplit$threshold
                            )
                        ];
                    notSatisfied <- sort(setdiff(currentRowIDs,satisfied));

                    cat("\nsatisfied:\n");
                    print( satisfied    );

                    cat("\nnonSatisfied:\n");
                    print( notSatisfied    );

                    lastNodeID       <- lastNodeID + 1;
                    satisfiedChildID <- lastNodeID;
                    workQueue        <- private$push(
                        list = workQueue,
                        x    = private$node$new(
                            parentID = currentNodeID,
                            nodeID   = lastNodeID,
                            depth    = currentDepth + 1,
                            rowIDs   = satisfied,
                            birthCriterion = private$birthCriterion$new(
                                varname    = bestSplit$varname,
                                threshold  = bestSplit$threshold,
                                comparison = ifelse(bestSplit$varname %in% self$predictors_numeric,"<","=")
                                ),
                            )
                        );

                    lastNodeID          <- lastNodeID + 1;
                    nonSatisfiedChildID <- lastNodeID;
                    workQueue           <- private$push(
                        list = workQueue,
                        x    = private$node$new(
                            parentID = currentNodeID,
                            nodeID   = lastNodeID,
                            depth    = currentDepth + 1,
                            rowIDs   = notSatisfied,
                            birthCriterion = private$birthCriterion$new(
                                varname    = bestSplit$varname,
                                threshold  = bestSplit$threshold,
                                comparison = ifelse(bestSplit$varname %in% self$predictors_numeric,">=","!=")
                                )
                            )
                        );

                    self$nodes <- private$push(
                        list = self$nodes,
                        x = private$node$new(
                            nodeID   = currentNodeID,
                            parentID = currentParentID,
                            depth    = currentDepth,
                            rowIDs   = currentRowIDs,
                            splitCriterion = bestSplit,
                            birthCriterion = current_birthCriterion,
                            satisfiedChildID    =    satisfiedChildID,
                            nonSatisfiedChildID = nonSatisfiedChildID
                            )
                        );
                    #cat( paste0("\ncurrentNodeID: ",currentNodeID) );
                    }
                } 

            # private$order_nodes();
            return( NULL );

            },

        predict = function() {
            return( NULL );
            },

        print = function() {
            if ( 0 == length(self$nodes) ) {
                cat("\nlist of nodes is empty.\n")
                }
            else {
                for ( i in seq(1,length(self$nodes)) ) {
                    self$nodes[[i]]$print_node();
                    }
                cat("\n");
                }
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
        stoppingCriterionSatisfied = function(currentRowIDs = NULL) {
            deduplicatedOutcomes <- unique(self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$response]);
            return( 1 == length(deduplicatedOutcomes) );
            },
        get_best_split = function(currentRowIDs) {
            uniqueVarValuePairs_factor  <- list();
            uniqueVarValuePairs_numeric <- list();
            if (length(self$predictors_factor) > 0) {
                uniqueVarValuePairs_factor <- private$get_var_value_pairs(
                    x = lapply(
                        X = as.list(private$get_non_constant_columns(
                            DF.input       = self$data,
                            currentRowIDs  = currentRowIDs,
                            input.colnames = self$predictors_factor
                            )),
                        MARGIN = 2,
                        FUN    = function(x) { return( private$get_midpoints(x) ); }
                        ),
                    comparison = private$is_equal_to
                    );
                }
            if (length(self$predictors_numeric) > 0) {
                uniqueVarValuePairs_numeric <- private$get_var_value_pairs(
                    x = lapply(
                        X = as.list(private$get_non_constant_columns(
                            DF.input       = self$data,
                            currentRowIDs  = currentRowIDs,
                            input.colnames = self$predictors_numeric
                            )),
                        FUN = function(x) { return( private$get_midpoints(x) ); }
                        ),
                    comparison = private$is_less_than
                    );
                }
            uniqueVarValuePairs <- c(uniqueVarValuePairs_factor,uniqueVarValuePairs_numeric);
            impurities <- lapply(
                X   = uniqueVarValuePairs,
                FUN = function(x) {
                    satisfied <- self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$syntheticID][
                        x$comparison(
                            self$data[self$data[,self$syntheticID] %in% currentRowIDs,x$varname],
                            x$threshold
                            )
                        ];
                    notSatisfied <- sort(setdiff(currentRowIDs,satisfied));
                    p1 <- length(   satisfied) / length(currentRowIDs);
                    p2 <- length(notSatisfied) / length(currentRowIDs);
                    g1 <- private$impurity(self$data[self$data[,self$syntheticID] %in%    satisfied,self$response]);
                    g2 <- private$impurity(self$data[self$data[,self$syntheticID] %in% notSatisfied,self$response]);
                    return( p1 * g1 + p2 * g2 );
                    }
                );
            output <- uniqueVarValuePairs[[ which.min(impurities) ]];
            return( output );
            },
        get_non_constant_columns = function(DF.input = NULL, currentRowIDs = NULL, input.colnames = NULL) {
            DF.output           <- DF.input[DF.input[,self$syntheticID] %in% currentRowIDs,input.colnames];
            colnames(DF.output) <- input.colnames;
            nUniqueValues       <- apply(X = DF.output, MARGIN = 2, FUN = function(x) { return(length(unique(x))) } );
            DF.output           <- DF.output[,nUniqueValues > 1];
            return( DF.output );
            },
        get_midpoints = function(x) {
            if (is.numeric(x)) {
                y <- sort(unique(x));
                return( apply(X=data.frame(c1=y[2:length(y)],c2=y[1:(length(y)-1)]),MARGIN=1,FUN=mean) );
                }
            else if (is.factor(x)) {
                return( levels(x) );
                }
            else {
                return( sort(unique(x)) );
                }
            },
        get_var_value_pairs = function(x = NULL, comparison = NULL) {
            names_x  <- names(x);
            templist <- list();
            for (i in seq(1,length(names_x))) {
                for (j in seq(1,length(x[[i]]))) {
                    templist <- private$push(
                        list = templist,
                        x    = private$splitCriterion$new(
                            varname    = names_x[i],
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
        impurity = function(x){
            # Gini impurity
            p <- as.numeric(table(x) / length(x));
            return( sum(p * (1 - p)) );
            },
        splitCriterion = R6Class(
            classname  = "splitCriterion",
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
        birthCriterion = R6Class(
            classname  = "birthCriterion",
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
        order_nodes = function() {
            if (length(self$nodes) > 0) {
                nodeIDs <- as.integer(lapply(X = self$nodes, FUN = function(x) { return( x$nodeID ); } ))
                self$nodes <- self$nodes[order(nodeIDs)];
                return( NULL );
                }
            },
        node = R6Class(
            classname = "node",

            public = list(

                nodeID   = NULL,
                parentID = NULL,
                depth    = NULL,
                rowIDs   = NULL,

                splitCriterion = NULL,
                birthCriterion = NULL,

                satisfiedChildID    = NULL,
                nonSatisfiedChildID = NULL,

                initialize = function(
                    nodeID    = NULL,
                    parentID  = NULL,
                    depth     = NULL,
                    rowIDs    = NULL,

                    splitCriterion = NULL,
                    birthCriterion = NULL,

                    satisfiedChildID    = NULL,
                    nonSatisfiedChildID = NULL
                    ) {
                        self$nodeID   <- nodeID;
                        self$parentID <- parentID;
                        self$depth    <- depth;
                        self$rowIDs   <- rowIDs;

                        self$splitCriterion <- splitCriterion;
                        self$birthCriterion <- birthCriterion;

                        self$satisfiedChildID    <- satisfiedChildID;
                        self$nonSatisfiedChildID <- nonSatisfiedChildID;
                    },

                print_node = function() {
                    cat("\n");
                    cat(paste0(rep('  ',self$depth),collapse="") );
                    cat(paste0("(",self$nodeID,") "));
                    if (0 == self$nodeID) {
                        cat("[root]");
                        }
                    else {
                        cat(paste0("[",
                            self$birthCriterion$varname,   " ",
                            self$birthCriterion$comparison," ",
                            self$birthCriterion$threshold,
                            "]"));
                        }
                    }
                )

            )

        )

    );

