
getData.CHIS.adult <- function(data.directory) {
    
    require(haven);
    require(survey);
    
    cat("\n\n#######################################");
    cat("\n### getData.CHIS.adult() starts ...\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### data.directory\n");
    print( data.directory );
    
    data.directory <- file.path(
        gsub(
            x           = data.directory,
            pattern     = "lumley-complex-surveys-analysis.+",
            replacement = "lumley-complex-surveys-analysis"
            )
        );
    
    cat("\n### data.directory\n");
    print( data.directory );
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    output.file <- file.path(data.directory,"CHIS-2005-adult.RData");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if (file.exists(output.file)) {

        cat("\n### loading *.RData file ...\n");
        load(file=output.file);

    } else {

        cat("\n### loading *.sas7bdat file ...\n");
        DF.CHIS.adult <- as.data.frame(read_sas(
            data_file = file.path(
                data.directory,
                "chis05_adult_sas",
                "chis05_adult_sas",
                "adult.sas7bdat"
                )
            ));

        DF.CHIS.adult <- as.data.frame(apply(
            X      = DF.CHIS.adult,
            MARGIN = 2,
            FUN    = function(x) { as.numeric(x) }
            ));

        save(list = c("DF.CHIS.adult"), file=output.file);

    }
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\n### getData.CHIS.adult() quits ...");
    cat("\n#######################################\n");
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return(DF.CHIS.adult);
    
    }