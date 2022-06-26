
generate.data <- function(
    n.obs           = 1000,
    semi.major.axis = 20,
    semi.minor.axis =  1,
    theta           = pi/4,
    h.offset        = 2.5
    ) {

    thisFunctionName <- "generate.data";

    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n# ",thisFunctionName,"() starts.\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    require(RColorBrewer);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    rotation.matrix <- matrix(
        data  = c(cos(theta),sin(theta),-sin(theta),cos(theta)),
        nrow  = 2,
        byrow = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.data <- data.frame(
        x1 = rnorm(n = n.obs, mean = 0, sd = semi.major.axis),
        x2 = rnorm(n = n.obs, mean = 0, sd = semi.minor.axis)
        );
    colnames.DF.data <- colnames(DF.data);
    DF.data <- as.data.frame(t( rotation.matrix %*% t(DF.data) ));
    colnames(DF.data) <- colnames.DF.data;

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.data[,'y'] <- sample(
        x       = c(-1,1),
        size    = n.obs,
        replace = TRUE,
        prob    = c(0.5,0.5)
        );
    DF.data <- as.data.frame(DF.data);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.data[,'h.offset'] <- - h.offset;
    DF.data[DF.data[,'y'] > 0,'h.offset'] <- h.offset;
    DF.data[,'x1'] <- DF.data[,'x1'] + DF.data[,'h.offset'];
    DF.data <- DF.data[,setdiff(colnames(DF.data),'h.offset')];
    DF.data <- as.data.frame(DF.data);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.data[,c('x1','x2')] <- as.data.frame(apply(
        X      = DF.data[,c('x1','x2')],
        MARGIN = 2,
        FUN    = function(x) { return(x - mean(x)) }
        ));
    DF.data <- as.data.frame(DF.data);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.colour.palette <- RColorBrewer::brewer.pal(n = 3, name = "Set1")[c(1,2)];

    DF.data[,'colour'] <- my.colour.palette[1];
    DF.data[DF.data[,'y'] > 0,'colour'] <- my.colour.palette[2];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n# ",thisFunctionName,"() exits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.data );

    }
