
preprocessData <- function(DF.input) {

    require(caret);
    require(dplyr);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.input %>%
        mutate_if(.predicate = is.numeric, .funs = function(x){ x[is.na(x)] <- median(x,na.rm=TRUE); return(x); }) %>%
        mutate(      roomsPerHousehold =     total_rooms/  households ) %>%
        mutate( populationPerHousehold =     population /  households ) %>%
        mutate(        bedroomsPerRoom = total_bedrooms / total_rooms ) %>%
        mutate_if(.predicate = is.numeric, .funs = function(x){ return(scale(x,center=TRUE,scale=TRUE)); });

    DF.output[,"median_house_value"] <- DF.input[,"median_house_value"];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- data.frame(predict(dummyVars(formula = ~ ., data=DF.output),newdata=DF.output));
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( DF.output );

    }

