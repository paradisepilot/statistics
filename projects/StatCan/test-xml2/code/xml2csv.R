
xml2csv <- function(inputXML,outputCSV) {

    require(xml2);
    require(dplyr);
    require(tidyr);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    docXML  <- read_xml(x = inputXML, encoding = "ISO-8859-1");
    entries <- xml_children(docXML)["entry" == xml_name(xml_children(docXML))];

    n.entries <- length(xml_name(entries));
    DF.output <- data.frame(
        id      = character(n.entries),
        domain  = character(n.entries),
        title   = character(n.entries),
        summary = character(n.entries),
        stringsAsFactors = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    domain <- basename(inputXML);

    domain <- gsub(
        x           = domain,
        pattern     = "query-arXiv-cat-",
        replacement = ""
        );

    domain <- gsub(
        x           = domain,
        pattern     = "-1000.txt",
        replacement = ""
        );

    DF.output[,"domain"] <- domain;

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for (i in 1:n.entries) {

        temp.index   <- which("id" == xml_name(xml_children(entries[[i]])));
        temp.id      <- xml_text(xml_child(entries[[i]], search = temp.index));

        temp.index   <- which("title" == xml_name(xml_children(entries[[i]])));
        temp.title   <- xml_text(xml_child(entries[[i]], search = temp.index));
        temp.title   <- gsub(x=temp.title,pattern="\\n",replacement=" ");
        temp.title   <- gsub(x=temp.title,pattern=" +", replacement=" ");

        temp.index   <- which("summary" == xml_name(xml_children(entries[[i]])));
        temp.summary <- xml_text(xml_child(entries[[i]], search = temp.index));
        temp.summary <- gsub(x=temp.summary,pattern="\\n",replacement=" ");
        temp.summary <- gsub(x=temp.summary,pattern=" +", replacement=" ");

        DF.output[i,"id"     ] <- temp.id;
        DF.output[i,"title"  ] <- temp.title;
        DF.output[i,"summary"] <- temp.summary;

        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    write.csv(
        file      = outputCSV,
        x         = DF.output,
        row.names = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }
