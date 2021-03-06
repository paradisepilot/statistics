
lm.train <- function(DF.input, attributeAdder) {

    require(caret);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trained.imputer <- preProcess(x = DF.input, method = c("medianImpute"));
    DF.imputed <- predict(object = trained.imputer, newdata = DF.input);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- attributeAdder(DF.input = DF.imputed);
    DF.temp[,"median_house_value"] <- DF.input[,"median_house_value"];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    trained.model <- train(
        form      = median_house_value ~ .,
        data      = DF.temp,
        method    = "lm",
        preProc   = c("center", "scale"),
        trControl = trainControl(method = "none")
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( list(trainedImputer = trained.imputer, trainedModel = trained.model) );

    }

