
train.predict.evaluate <- function(DF.train, DF.test, attributeAdder, methodName, trainFunction) {

    my.trainedMachine <- trainFunction(
        DF.input       = DF.train,
        attributeAdder = attributeAdder
        );

    train.predictions <- my.predict(
        DF.input       = DF.train,
        attributeAdder = attributeAdder,
        trainedImputer = my.trainedMachine[['trainedImputer']],
        trainedModel   = my.trainedMachine[['trainedModel']]
        );

    test.predictions <- my.predict(
        DF.input       = DF.test,
        attributeAdder = attributeAdder,
        trainedImputer = my.trainedMachine[['trainedImputer']],
        trainedModel   = my.trainedMachine[['trainedModel']]
        );

    print(paste0(rep("#",50),collapse=""));
    print(paste0("###  evaluations on train set: ",methodName));
    print( postResample(pred = train.predictions, obs = DF.train[,'median_house_value']) );

    print("###  trained model");
    print( my.trainedMachine[['trainedModel']] );

    print(paste0("###  evaluations on test set: ",methodName));
    print( postResample(pred = test.predictions, obs = DF.test[,'median_house_value']) );

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

