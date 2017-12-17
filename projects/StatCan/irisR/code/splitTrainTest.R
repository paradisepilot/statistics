
splitTrainTest <- function(DF.input) {

    require(caret);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trainIndices <- createDataPartition(
        y      = DF.input[,"median_house_value"],
        times  = 1,
        p      = 0.8,
        list   = TRUE,
        groups = min(13,nrow(DF.input))
        )[['Resample1']];

    LIST.output <- list(
        trainSet = DF.input[ trainIndices,],
        testSet  = DF.input[-trainIndices,]
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( LIST.output );

    }
