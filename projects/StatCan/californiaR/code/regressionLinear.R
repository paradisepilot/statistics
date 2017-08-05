
regressionLinear <- function(DF.input) {

    require(caret);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("str(DF.input)");
    print( str(DF.input) );

    print("summary(DF.input)");
    print( summary(DF.input) );

    fit.lm <- train(
        form   = median_house_value ~ .,
        data   = DF.input,
        method = "lm"
        );

    prediction.lm <- predict(
        object  = fit.lm,
        newdata = DF.input[,base::setdiff(colnames(DF.input),"median_house_value")]
        );

    print("postResample(pred = prediction.lm, obs = DF.input[,'median_house_value'])");
    print( postResample(pred = prediction.lm, obs = DF.input[,'median_house_value']) );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }

