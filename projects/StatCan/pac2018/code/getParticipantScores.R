
getParticipantScores <- function(
    microdata.directory,
    max.date    = as.Date("2018-06-24"),
    max.score   = 1500,
    FILE.output = NULL
    ) {

    require(readxl);
    require(tidyr);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- data.frame(
        stringsAsFactors = FALSE,
        week             = character(0),
        division         = character(0),
        chief            = character(0),
        participant      = character(0),
        high             = numeric(0),
        low              = numeric(0),
        high0            = numeric(0),
        low0             = numeric(0),
        score.high       = numeric(0),
        score.low        = numeric(0),
        score.uncapped   = numeric(0),
        score            = numeric(0)
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    divisions <- list.files(path = microdata.directory);
    cat("\n### divisions:\n");
    print( divisions );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for (division in divisions) {

        dir.division <- file.path(microdata.directory,division);
        sections     <- list.files(path = dir.division);
        for (section in sections) {
            
            cat(paste0("\n\n### division: ",division,", section: ",section));
            dir.section  <- file.path(dir.division,section);
            participants <- list.files(path=dir.section);
            for (participant in participants) {
                
                cat(paste0("\nprocessing: ",participant));
                DF.participant <- getScoresSingleParticipant(
                    file.participant = file.path(dir.section,participant),
                    max.date         = max.date,
                    max.score        = max.score
                    );
                DF.output <- rbind(DF.output,DF.participant);
                
                }
            
            }
        
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if (!is.null(FILE.output)) {
        write.csv(x = DF.output, file = FILE.output, row.names = FALSE);
        }

    return( DF.output );

    }

#################################################
getScoresSingleParticipant <- function(
    file.participant,
    max.date  = as.Date("2018-06-24"),
    max.score = 1500
    ) {
    
    require(dplyr);
    require(tools);
    require(tidyr);
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    participant <- gsub(
        x           = file_path_sans_ext(x = basename(file.participant)),
        pattern     = "pac2018_",
        replacement = ""
        );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.raw <- read.csv(file = file.participant);
    
    DF.raw[,"participant"] <- participant;
    DF.raw <- DF.raw[,c("date","division","chief","participant","intensity","minutes")];
    
    #cat(paste0("\n### ",file.participant,":\n"));
    #print( DF.raw );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.daily <- DF.raw %>%
        spread(key = intensity, value = minutes);

    weeklyHigh0 <- DF.daily["weekly_baseline" == DF.daily[,"date"],"high"];
    weeklyLow0  <- DF.daily["weekly_baseline" == DF.daily[,"date"],"low" ];
    
    DF.daily <- DF.daily["weekly_baseline" != DF.daily[,"date"],];
    DF.daily[,"date"] <- as.Date(DF.daily[,"date"]);
    
    is.week1 <- as.Date("2018-05-28") <= DF.daily[,"date"] & DF.daily[,"date"] <= as.Date("2018-06-03");
    is.week2 <- as.Date("2018-06-04") <= DF.daily[,"date"] & DF.daily[,"date"] <= as.Date("2018-06-10");
    is.week3 <- as.Date("2018-06-11") <= DF.daily[,"date"] & DF.daily[,"date"] <= as.Date("2018-06-17");
    is.week4 <- as.Date("2018-06-18") <= DF.daily[,"date"] & DF.daily[,"date"] <= as.Date("2018-06-24");
    
    DF.daily[,"week"] <- rep("",nrow(DF.daily));
    DF.daily[is.week1,"week"] <- "week1";
    DF.daily[is.week2,"week"] <- "week2";
    DF.daily[is.week3,"week"] <- "week3";
    DF.daily[is.week4,"week"] <- "week4";
    
    DF.daily <- DF.daily[,c("week",setdiff(colnames(DF.daily),"week"))];
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    is.after.max.date <- DF.daily[,"date"] > max.date;
    DF.daily[is.after.max.date,"high"] <- 0;
    DF.daily[is.after.max.date,"low"]  <- 0;
    
    #cat(paste0("\n### participant: ",participant,", DF.daily:\n"));
    #print( DF.daily );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.weekly <- DF.daily %>%
        group_by(week, division, chief, participant) %>%
        summarize( high = sum(high), low = sum(low) );
    
    DF.weekly <- as.data.frame(DF.weekly);
    DF.weekly[,"high0"] <- weeklyHigh0;
    DF.weekly[, "low0"] <- weeklyLow0;

    # score.high     = min(high,high0) + 2 * max(0,high - high0)
    # score.low      = min( low, low0) + 2 * max(0, low -  low0)
    # score.uncapped = 2 * score.high + score.low
    # score          = min(max.score,score.uncapped)

    DF.weekly[,"score.high"] <- apply(
        X      = DF.weekly[,c("high","high0")],
        MARGIN = 1,
        FUN    = function(x) { min(x) + 2 * max(0,sum(c(1,-1)*x)) }
        );
    
    DF.weekly[,"score.low"] <- apply(
        X      = DF.weekly[,c("low","low0")],
        MARGIN = 1,
        FUN    = function(x) { min(x) + 2 * max(0,sum(c(1,-1)*x)) }
        );

    DF.weekly <- DF.weekly %>% mutate( score.uncapped = 2 * score.high + score.low );

    DF.weekly[,"score"] <- apply(
        X      = cbind(DF.weekly[,"score.uncapped"],rep(max.score,nrow(DF.weekly))),
        MARGIN = 1,
        FUN    = function(x) { min(x) }
        );
    
    #cat(paste0("\n### participant: ",participant,", DF.weekly:\n"));
    #print( DF.weekly );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( DF.weekly );
    
    }