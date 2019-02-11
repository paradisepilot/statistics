
require(R6);
require(dplyr);

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
                self$predictors <- base::setdiff(colnames(self$data),c(self$response));
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

                #cat( "\n### ~~~~~~~~~~ ###" );
                #cat( paste0("\nlength(workQueue): ",length(workQueue),"\n") );
                #print( workQueue );

                currentNode <- private$pop(workQueue, envir = environment());

                currentNodeID          <- currentNode$nodeID;
                currentParentID        <- currentNode$parentID;
                currentDepth           <- currentNode$depth;
                currentRowIDs          <- currentNode$rowIDs;
                current_birthCriterion <- currentNode$birthCriterion;

                #cat("\ncurrentNode:");
                #print( currentNode );

                if (private$stoppingCriterionSatisfied(currentRowIDs)) {
                    self$nodes <- private$push(
                        list = self$nodes,
                        x    = private$node$new(
                            nodeID   = currentNodeID,
                            parentID = currentParentID,
                            depth    = currentDepth,
                            rowIDs   = currentRowIDs,
                            impurity = private$impurity(
                                self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$response]
                                ),
                            risk = private$risk(
                                self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$response]
                                ),
                            birthCriterion = current_birthCriterion
                            )
                        );
                    }
                else {

                    #cat("\ncurrentRowIDs:\n");
                    #print( currentRowIDs    );

                    bestSplit <- private$get_best_split(currentRowIDs = currentRowIDs);
                    #cat("\nbestSplit:\n");
                    #print( bestSplit );

                    satisfied <- self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$syntheticID][
                        bestSplit$comparison(
                            self$data[self$data[,self$syntheticID] %in% currentRowIDs,bestSplit$varname],
                            bestSplit$threshold
                            )
                        ];
                    notSatisfied <- base::sort(base::setdiff(currentRowIDs,satisfied));

                    #cat("\nsatisfied:\n");
                    #print( satisfied    );

                    #cat("\nnotSatisfied:\n");
                    #print( notSatisfied    );

                    # adding 2 here to make ordering of nodeID agree with the order of appearance in self$nodes
                    lastNodeID          <- lastNodeID + 2;
                    notSatisfiedChildID <- lastNodeID;
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

                    # subtracting 1 here to make ordering of nodeID agree with the order of appearance in self$nodes
                    lastNodeID       <- lastNodeID - 1;
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
                    # adding 1 here to make ordering of nodeID agree with the order of appearance in self$nodes
                    lastNodeID <- lastNodeID + 1;

                    self$nodes <- private$push(
                        list = self$nodes,
                        x = private$node$new(
                            nodeID   = currentNodeID,
                            parentID = currentParentID,
                            depth    = currentDepth,
                            rowIDs   = currentRowIDs,
                            impurity = private$impurity(
                                self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$response]
                                ),
                            risk = private$risk(
                                self$data[self$data[,self$syntheticID] %in% currentRowIDs,self$response]
                                ),
                            splitCriterion = bestSplit,
                            birthCriterion = current_birthCriterion,
                            satisfiedChildID    =    satisfiedChildID,
                            notSatisfiedChildID = notSatisfiedChildID
                            )
                        );
                    #cat( paste0("\ncurrentNodeID: ",currentNodeID) );
                    }
                } 

            # private$order_nodes();
            # return( NULL );

            },

        predict = function() {
            return( NULL );
            },

        print = function(
            FUN.format = function(x) { return(x) }
            ) {
            if ( 0 == length(self$nodes) ) {
                cat("\nlist of nodes is empty.\n")
                }
            else {
                for ( i in seq(1,length(self$nodes)) ) {
                    self$nodes[[i]]$print_node(FUN.format = FUN.format);
                    }
                cat("\n");
                }
            },

        get_pruning_sequence = function(nodes = self$nodes) {
            if ( 0 == length(nodes) ) {
                cat("\nThe supplied list of nodes is empty.\n")
                return( NULL );
                }

            DF.node_table <- private$nodes_to_table(nodes = nodes);

            alpha_subtree <- list(
                alpha                = 0,
                nodes_retained       = DF.node_table[,"nodeID"],
                nodes_pruned         = c(),
                nodes_removed        = c(),
                nodes_retained_table = DF.node_table
                );

            output_list <- list();
            nAlphas     <- 1;

            output_list[[nAlphas]] <- alpha_subtree;
            while (1 < base::length(alpha_subtree$nodes_retained)) {
                nAlphas       <- 1 + nAlphas;
                alpha_subtree <- private$get_alpha_subtree(DF.input = alpha_subtree$nodes_retained_table);
                output_list[[nAlphas]] <- alpha_subtree;
                }

            return( output_list );
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
        get_descendants = function(nodeIDs = NULL, nodeID = NULL) {
            nodes <- self$nodes[unlist(lapply(
                X   = self$nodes,
                FUN = function(x) { return( x$nodeID %in% nodeIDs) }
                ))];
            temp <- unlist(lapply(X = nodes, FUN = function(x) { return( nodeID == x$nodeID ) }));
            if (1 == sum(temp)) {
                targetNode  <- nodes[temp][[1]];
                descendants <- c();
                if (!is.null(targetNode$satisfiedChildID)) {
                    descendants <- c(
                        descendants,
                        targetNode$satisfiedChildID,
                        private$get_descendants(nodeIDs = nodeIDs, nodeID = targetNode$satisfiedChildID)
                        );
                    }
                if (!is.null(targetNode$notSatisfiedChildID)) {
                    descendants <- c(
                        descendants,
                        targetNode$notSatisfiedChildID,
                        private$get_descendants(nodeIDs = nodeIDs, nodeID = targetNode$notSatisfiedChildID)
                        );
                    }
                return( sort(descendants) );
            } else {
                return( c() );
                }
            },
        nodes_to_table = function(nodes = self$nodes) {
            if ( 0 == length(nodes) ) {
                cat("\nThe supplied list of nodes is empty.\n")
                return( NULL );
                }
            nrow.output <- length(nodes);
            DF.output <- data.frame(
                nodeID     = numeric(length = nrow.output),
                depth      = numeric(length = nrow.output),
                nRecords   = numeric(length = nrow.output),
                prop       = numeric(length = nrow.output),
                #impurity  = numeric(length = nrow.output),
                risk       = numeric(length = nrow.output),
                riskWgtd   = numeric(length = nrow.output),
                riskLeaves = numeric(length = nrow.output),
                nLeaves    = numeric(length = nrow.output),
                parentID   = numeric(length = nrow.output),
                   satisfiedChildID = numeric(length = nrow.output),
                notSatisfiedChildID = numeric(length = nrow.output)
                );
            totalNumRecords <- length(nodes[[1]]$rowIDs);
            for ( i in seq(1,nrow.output) ) {
                DF.output[i,'nodeID'  ]   <- nodes[[i]]$nodeID;
                DF.output[i,'depth'   ]   <- nodes[[i]]$depth;
                DF.output[i,'nRecords']   <- length(nodes[[i]]$rowIDs);
                DF.output[i,'prop'    ]   <- DF.output[i,'nRecords'] / totalNumRecords;
                #DF.output[i,'impurity']  <- nodes[[i]]$impurity;
                DF.output[i,'risk']       <- nodes[[i]]$risk;
                DF.output[i,'riskWgtd']   <- DF.output[i,'risk'] * DF.output[i,'prop'];
                DF.output[i,'riskLeaves'] <- 0;
                DF.output[i,'nLeaves']    <- 0;
                DF.output[i,'parentID']   <- nodes[[i]]$parentID;
                DF.output[i,'satisfiedChildID'] <- ifelse(
                    is.null(nodes[[i]]$satisfiedChildID),
                    NA,
                    nodes[[i]]$satisfiedChildID
                    );
                DF.output[i,'notSatisfiedChildID'] <- ifelse(
                    is.null(nodes[[i]]$notSatisfiedChildID),
                    NA,
                    nodes[[i]]$notSatisfiedChildID
                    );
                }

            return( DF.output );
            },
        get_alpha_subtree = function(DF.input = NULL) {

            hasNoChildren <- is.na(DF.input[,'satisfiedChildID']) & is.na(DF.input[,'notSatisfiedChildID']);
            DF.leaves <- DF.input[hasNoChildren,];
            DF.leaves <- DF.leaves %>%
                rename( riskWgtd_child = riskWgtd ) %>%
                rename( nLeaves_child  = nLeaves  ) %>%
                select( - c( riskLeaves , satisfiedChildID , notSatisfiedChildID ) ) %>%
                mutate( nLeaves_child = 1 )
                ;
            #cat("\nDF.leaves\n");
            #print( DF.leaves   );    

            retainedColumns <- c("nodeID","riskWgtd_child","nLeaves_child");
            DF.internalNodes <- DF.input[!hasNoChildren,] %>%
                left_join(DF.leaves[,retainedColumns], by = c(   "satisfiedChildID" = "nodeID")) %>%
                rename( riskWgtd_s  = riskWgtd_child ) %>%
                rename( nLeaves_s   = nLeaves_child  ) %>%

                left_join(DF.leaves[,retainedColumns], by = c("notSatisfiedChildID" = "nodeID")) %>%
                rename( riskWgtd_ns = riskWgtd_child ) %>%
                rename( nLeaves_ns  = nLeaves_child  ) %>%

                mutate( riskWgtd_s  = ifelse(is.na(riskWgtd_s ),0,riskWgtd_s ) ) %>%
                mutate( riskWgtd_ns = ifelse(is.na(riskWgtd_ns),0,riskWgtd_ns) ) %>%
                mutate( riskLeaves  = riskLeaves + riskWgtd_s + riskWgtd_ns )    %>%

                mutate( nLeaves_s   = ifelse(is.na(nLeaves_s  ),0,nLeaves_s  ) ) %>%
                mutate( nLeaves_ns  = ifelse(is.na(nLeaves_ns ),0,nLeaves_ns ) ) %>%
                mutate( nLeaves     = nLeaves + nLeaves_s + nLeaves_ns         ) %>%

                select( - c(riskWgtd_s,riskWgtd_ns,nLeaves_s,nLeaves_ns) )
                ;
            #cat("\nDF.internalNodes\n");
            #print( DF.internalNodes   );    

            retainedColumns <- c("nodeID","riskLeaves_child","nLeaves_child");
            for (temp.depth in seq(max(DF.internalNodes[,"depth"]),1,-1)) {
                DF.depth <- DF.internalNodes %>%
                    filter( depth == temp.depth ) %>%
                    rename( riskLeaves_child = riskLeaves ) %>%
                    rename( nLeaves_child    = nLeaves    ) %>%
                    select( - c( satisfiedChildID , notSatisfiedChildID ) )
                    ;
                #cat("\nDF.depth\n");
                #print( DF.depth   );
                DF.internalNodes <- DF.internalNodes %>%
                    left_join(DF.depth[,retainedColumns], by = c(   "satisfiedChildID" = "nodeID")) %>%
                    rename( riskLeaves_s  = riskLeaves_child ) %>%
                    rename( nLeaves_s     = nLeaves_child    ) %>%

                    left_join(DF.depth[,retainedColumns], by = c("notSatisfiedChildID" = "nodeID")) %>%
                    rename( riskLeaves_ns = riskLeaves_child ) %>%
                    rename( nLeaves_ns    = nLeaves_child    ) %>%

                    mutate( riskLeaves_s  = ifelse(is.na(riskLeaves_s ),0,riskLeaves_s ) ) %>%
                    mutate( riskLeaves_ns = ifelse(is.na(riskLeaves_ns),0,riskLeaves_ns) ) %>%
                    mutate( riskLeaves    = riskLeaves + riskLeaves_s + riskLeaves_ns    ) %>%

                    mutate( nLeaves_s     = ifelse(is.na(nLeaves_s    ),0,nLeaves_s    ) ) %>%
                    mutate( nLeaves_ns    = ifelse(is.na(nLeaves_ns   ),0,nLeaves_ns   ) ) %>%
                    mutate( nLeaves       = nLeaves + nLeaves_s + nLeaves_ns             ) %>%

                    select( - c(riskLeaves_s,riskLeaves_ns,nLeaves_s,nLeaves_ns) )
                    ;
                #cat("\nDF.internalNodes\n");
                #print( DF.internalNodes   );
                }
            DF.internalNodes <- DF.internalNodes %>%
                mutate( alpha = (risk - riskLeaves) / (nLeaves - 1) );
            #cat("\nDF.internalNodes\n");
            #print( DF.internalNodes   );

            min.alpha    <- min(DF.internalNodes[,'alpha']);
            nodesToPrune <- DF.internalNodes[DF.internalNodes[,'alpha'] == min.alpha,'nodeID'];
            #cat("\nnodesToPrune:\n");
            #print( nodesToPrune    );

            nodesToRemove <- c();
            for (tempNodeID in nodesToPrune) {
                nodesToRemove <- base::unique(c(
                    nodesToRemove,
                    private$get_descendants(nodeIDs = DF.input[,'nodeID'], nodeID = tempNodeID)
                    ));
                }
            nodesToRemove <- base::intersect( base::sort(nodesToRemove) , DF.input[,'nodeID'] );
            #cat("\nnodesToRemove:\n");
            #print( nodesToRemove    );

            nodesToRetain <- base::setdiff(DF.input[,'nodeID'],nodesToRemove);
            #cat("\nnodesToRetain:\n");
            #print( nodesToRetain    );

            DF.output <- DF.input[DF.input[,'nodeID'] %in% nodesToRetain,];
            DF.output[DF.input[,'nodeID'] %in% nodesToPrune,   'satisfiedChildID'] <- NA;
            DF.output[DF.input[,'nodeID'] %in% nodesToPrune,'notSatisfiedChildID'] <- NA;

            output_list <- list(
                alpha = min.alpha,
                nodes_retained       = nodesToRetain,
                nodes_pruned         = nodesToPrune,
                nodes_removed        = nodesToRemove,
                nodes_retained_table = DF.output
                );
            #cat("\noutput_list:\n");
            #print( output_list    );

            return( output_list );
            },
        get_best_split = function(currentRowIDs) {
            uniqueVarValuePairs_factor  <- list();
            uniqueVarValuePairs_numeric <- list();
            if (length(self$predictors_factor) > 0) {
                DF.temp <- self$data;
                DF.temp <- DF.temp[currentRowIDs,self$predictors_factor];
                temp <- as.list(private$get_non_constant_columns(
                    DF.input       = self$data,
                    currentRowIDs  = currentRowIDs,
                    input.colnames = self$predictors_factor
                    ));
                temp.list <- as.list(private$get_non_constant_columns(
                    DF.input       = self$data,
                    currentRowIDs  = currentRowIDs,
                    input.colnames = self$predictors_factor
                    ));
                if (length(temp.list) > 0) {
                    uniqueVarValuePairs_factor <- private$get_var_value_pairs(
                        x = lapply(
                            X   = temp.list,
                            FUN = function(x) { return( private$get_midpoints(x) ); }
                            ),
                        comparison = private$is_equal_to
                        );
                    }
                }
            if (length(self$predictors_numeric) > 0) {
                temp.list <- as.list(private$get_non_constant_columns(
                    DF.input       = self$data,
                    currentRowIDs  = currentRowIDs,
                    input.colnames = self$predictors_numeric
                    ));
                uniqueVarValuePairs_numeric <- private$get_var_value_pairs(
                    x = lapply(
                        X   = temp.list,
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
                    notSatisfied <- base::sort(base::setdiff(currentRowIDs,satisfied));
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
            DF.output <- DF.input[DF.input[,self$syntheticID] %in% currentRowIDs,input.colnames];

            # If length(input.colnames) == 1, then DF.output will be a vector.
            # In that case, cast DF.output into a data frame.
            DF.output <- as.data.frame(DF.output);

            colnames(DF.output) <- input.colnames;
            nUniqueValues       <- apply(X = DF.output, MARGIN = 2, FUN = function(x) { return(length(unique(x))) } );
            DF.output           <- as.data.frame(DF.output[,nUniqueValues > 1]);
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
        risk = function(x){
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
                impurity = NULL,
                risk     = NULL,

                splitCriterion = NULL,
                birthCriterion = NULL,

                satisfiedChildID    = NULL,
                notSatisfiedChildID = NULL,

                initialize = function(
                    nodeID   = NULL,
                    parentID = NULL,
                    depth    = NULL,
                    rowIDs   = NULL,
                    impurity = NULL,
                    risk     = NULL,

                    splitCriterion = NULL,
                    birthCriterion = NULL,

                    satisfiedChildID    = NULL,
                    notSatisfiedChildID = NULL
                    ) {
                        self$nodeID   <- nodeID;
                        self$parentID <- parentID;
                        self$depth    <- depth;
                        self$rowIDs   <- rowIDs;
                        self$impurity <- impurity;
                        self$risk     <- risk;

                        self$splitCriterion <- splitCriterion;
                        self$birthCriterion <- birthCriterion;

                        self$satisfiedChildID    <- satisfiedChildID;
                        self$notSatisfiedChildID <- notSatisfiedChildID;
                    },

                print_node = function(
                    indent     = '  ',
                    FUN.format = function(x) { return(x) }
                    ) {
                    cat("\n");
                    cat(paste0(rep(indent,self$depth),collapse="") );
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
                    cat(paste0(", impurity = ",FUN.format(self$impurity)));
                    cat(paste0(", risk = ",    FUN.format(self$risk    )));
                    }
                )

            )

        )

    );

