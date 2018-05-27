
synthesizeData <- function(FILE.sections) {

    require(readxl);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.sections <- as.data.frame(read_excel(
        path = FILE.sections
        ));
    
    cat("\n\n##### DF.sections:\n")
    print( DF.sections );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dates <- seq(
        from = as.Date("2018/05/28"),
        to   = as.Date("2018/06/24"),
        by   = "day"
        );
    
    DF.temp <- rbind(
        data.frame(
            date             = dates,
            division         = rep("",    length(dates)),
            chief            = rep("",    length(dates)),
            intensity        = rep("high",length(dates)),
            minutes          = rep(0,     length(dates)),
            stringsAsFactors = FALSE
            ),
        data.frame(
            date             = dates,
            division         = rep("",   length(dates)),
            chief            = rep("",   length(dates)),
            intensity        = rep("low",length(dates)),
            minutes          = rep(0,    length(dates)),
            stringsAsFactors = FALSE
            )
        );

    DF.temp <- DF.temp[order(DF.temp[,"date"]),];
    DF.temp[,"date"] <- as.character(DF.temp[,"date"]);
    rownames(DF.temp) <- seq(1,nrow(DF.temp));
    
    DF.temp <- rbind(
        data.frame(
            date             = rep("weekly_baseline",2),
            division         = rep("",2),
            chief            = rep("",2),
            intensity        = c("high","low"),
            minutes          = rep(0,2),
            stringsAsFactors = FALSE
            ),
        DF.temp
        );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for (i in 1:nrow(DF.sections)) {

        temp.division     <- DF.sections[i,"Division"];
        temp.sectionChief <- DF.sections[i,"SectionChief"];

        temp.directory <- file.path(
            "pac2018-microdata-synthesized",
            gsub(x = temp.division, pattern = "/", replacement = "-"),
            temp.sectionChief
            );

        dir.create(path = temp.directory, recursive = TRUE);
        
        DF.temp[,"division"] <- temp.division;
        DF.temp[,"chief"]    <- temp.sectionChief;

        section.mean <- rnorm(n = 1, mean = 75, sd = 15);
        for (j in 1:sample(x=seq(3,5,1),size=1)) {
            
            DF.temp[,"minutes"]    <- floor(rnorm(n = nrow(DF.temp), mean = section.mean, sd = 15));
            DF.temp[1:2,"minutes"] <- 7 * DF.temp[1:2,"minutes"];
            
            temp.file <- paste0(
                "pac2018_",
                gsub(x = temp.division, pattern = "/", replacement = "-"),"_",
                temp.sectionChief,"_",
                j,
                ".csv"
                );

            write.csv(
                x         = DF.temp,
                file      = file.path(temp.directory,temp.file),
                row.names = FALSE
                );
        
            }
        
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( DF.sections );

    }

