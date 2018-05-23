
createTemplates <- function(FILE.sections) {

    require(readxl);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.sections <- as.data.frame(read_excel(
        path = FILE.sections
        ));
    
    cat("\n\n##### DF.sections:\n")
    print( DF.sections );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dates <- seq(
        from = as.Date("2018/5/28"),
        to   = as.Date("2018/6/22"),
        by   = "day"
        );
    
    DF.temp <- data.frame(
        date                = dates,
        Division            = rep("",length(dates)),
        SectionChief        = rep("",length(dates)),
        FirstName           = rep("",length(dates)),
        LastName            = rep("",length(dates)),
        Exercise            = rep("",length(dates)),
        Intensity           = rep(0, length(dates)),
        Duration_in_Minutes = rep(0, length(dates)),
        stringsAsFactors = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for (i in 1:nrow(DF.sections)) {

        temp.division     <- DF.sections[i,"Division"];
        temp.sectionChief <- DF.sections[i,"SectionChief"];

        temp.directory <- file.path(
            "pac2018-microdata-template",
            gsub(x = temp.division, pattern = "/", replacement = "-"),
            temp.sectionChief
            );

        dir.create(path = temp.directory, recursive = TRUE);
        
        DF.temp[,"Division"]     <- temp.division;
        DF.temp[,"SectionChief"] <- temp.sectionChief;
        
        temp.file <- paste0(
            "pac2018_",
            gsub(x = temp.division, pattern = "/", replacement = "-"),"_",
            temp.sectionChief,
            "_template.csv"
            );

        write.csv(
            x         = DF.temp,
            file      = file.path(temp.directory,temp.file),
            row.names = FALSE
            );

        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( DF.sections );

    }

