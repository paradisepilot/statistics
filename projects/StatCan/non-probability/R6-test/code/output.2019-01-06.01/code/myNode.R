
require(R6);

myNode  <- R6Class(
    classname = "myNode",

    public = list(

        nodeID     = NULL,
        rowIndexes = NULL,
        parentID   = NULL,

        variable   = NULL,
        threshold  = NULL,
        binaryOP   = NULL,

        matchChildID    = NULL,
        nonMatchChildID = NULL,

        initialize = function(
            nodeID          = NULL,
            rowIndexes      = NULL,
            parentID        = NULL,
            variable        = NULL,
            threshold       = NULL,
            binaryOP        = NULL,
            matchChildID    = NULL,
            nonMatchChildID = NULL
            ) {
                self$nodeID     <- nodeID;
                self$rowIndexes <- rowIndexes;
                self$parentID   <- parentID;

                self$variable   <- variable;
                self$threshold  <- threshold;
                self$binaryOP   <- binaryOP;

                self$matchChildID    <- matchChildID;
                self$nonMatchChildID <- nonMatchChildID;
                }

        )
    );

