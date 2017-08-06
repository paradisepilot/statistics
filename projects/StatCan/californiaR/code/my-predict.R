
my.predict <- function(DF.input, attributeAdder, trainedImputer, trainedModel) {

    require(caret);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.imputed <- predict(object = trainedImputer, newdata = DF.input);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- attributeAdder(DF.input = DF.imputed);
    DF.temp[,"median_house_value"] <- DF.input[,"median_house_value"];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.predict <- predict(
        object  = trainedModel, 
        newdata = DF.temp[,base::setdiff(colnames(DF.temp),"median_house_value")]
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( results.predict );

    }

