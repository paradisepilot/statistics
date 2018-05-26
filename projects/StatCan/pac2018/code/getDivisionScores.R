
getDivisionScores <- function(DF.participantScores,FILE.output=NULL) {

    require(dplyr);
    require(tidyr);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.participantScores %>%
        group_by(week, division) %>%
        summarize( score = mean(score) );
    
    DF.output <- as.data.frame(DF.output);
    
    DF.output <- DF.output %>%
        spread(key = week, value = score)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if (!is.null(FILE.output)) {
        write.csv(x = DF.output, file = FILE.output, row.names = FALSE);
        }

    return( DF.output );

    }
