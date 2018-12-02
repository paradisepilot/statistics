
regressionTree.train <- function(DF.input, attributeAdder) {

    require(caret);
    require(rpart);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trained.imputer <- preProcess(x = DF.input, method = c("medianImpute"));
    DF.imputed <- predict(object = trained.imputer, newdata = DF.input);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- attributeAdder(DF.input = DF.imputed);
    DF.temp[,"median_house_value"] <- DF.input[,"median_house_value"];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    #trained.model <- rpart(
    #    formula   = median_house_value ~ .,
    #    data      = DF.temp,
    #    minsplit  =  1,
    #    minbucket =  1,
    #    cp        = -1 
    #    );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trained.model <- train(
        form      = median_house_value ~ .,
        data      = DF.temp,
        method    = "rpart",
        preProc   = c("center", "scale"),
        tuneGrid  = data.frame(cp = c(-1)), # complexity parameter = -1: no pruning at all
        trControl = trainControl(method = "none")
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( list(trainedImputer = trained.imputer, trainedModel = trained.model) );

    }

