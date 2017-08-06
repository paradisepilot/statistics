
train.predict.evaluate <- function(DF.input, attributeAdder, methodName, trainFunction) {

    my.trainedMachine <- trainFunction(
        DF.input       = DF.input,
        attributeAdder = attributeAdder
        );

    my.predictions <- my.predict(
        DF.input       = DF.input,
        attributeAdder = attributeAdder,
        trainedImputer = my.trainedMachine[['trainedImputer']],
        trainedModel   = my.trainedMachine[['trainedModel']]
        );


    print(paste0(rep("#",50),collapse=""));
    print(paste0("###  results: ",methodName));
    print( postResample(pred = my.predictions, obs = DF.input[,'median_house_value']) );

    print("###  trained model");
    print( my.trainedMachine[['trainedModel']] );

    return( NULL );

    }

###################################################
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

