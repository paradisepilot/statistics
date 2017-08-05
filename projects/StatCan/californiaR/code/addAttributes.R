
addAttributes <- function(DF.input) {
    require(dplyr);
    DF.output <- DF.input %>%
        mutate(      roomsPerHousehold =     total_rooms/  households ) %>%
        mutate( populationPerHousehold =     population /  households ) %>%
        mutate(        bedroomsPerRoom = total_bedrooms / total_rooms );
    return( DF.output );
    }

