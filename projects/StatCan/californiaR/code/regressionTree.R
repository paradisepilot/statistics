
regressionTree <- function(DF.input) {

    require(caret);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fit.rpart <- rpart(
        formula   = median_house_value ~ .,
        data      = DF.input,
        minsplit  =  1,
        minbucket =  1,
        cp        = -1 
        );

    prediction.rpart <- predict(
        object  = fit.rpart,
        newdata = DF.input[,base::setdiff(colnames(DF.input),"median_house_value")]
        );

    print("sqrt(mean((prediction.rpart - DF.input[,'median_house_value'])^2))");
    print( sqrt(mean((prediction.rpart - DF.input[,'median_house_value'])^2)) );

    print("mean(abs(prediction.rpart - DF.input[,'median_house_value']) / DF.input[,'median_house_value'])");
    print( mean(abs(prediction.rpart - DF.input[,'median_house_value']) / DF.input[,'median_house_value']) );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    fit.caret.rpart <- train(
        form     = median_house_value ~ .,
        data     = DF.input,
        method   = "rpart",
        tuneGrid = data.frame(cp = c(-1)) # complexity parameter = -1: no pruning at all
        );

    # print("str(fit.tree)");
    # print( str(fit.tree) );

    prediction.caret.rpart <- predict(
        object  = fit.caret.rpart,
        newdata = DF.input[,base::setdiff(colnames(DF.input),"median_house_value")]
        );

    print("sqrt(mean((prediction.caret.rpart - DF.input[,'median_house_value'])^2))");
    print( sqrt(mean((prediction.caret.rpart - DF.input[,'median_house_value'])^2)) );

    print("postResample(pred = prediction.caret.rpart, obs = DF.input[,'median_house_value'])");
    print( postResample(pred = prediction.caret.rpart, obs = DF.input[,'median_house_value']) );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }

