
#' retrieves licenses of all attached and loaded packages
#'
#' \code{get_licenses} retrieves the versions, licenses and repositories of
#' all the attached and loaded R packages in an R session.
#'
#' @return A data frame of the names, versions, licenses and repositories
#'     of the attached and loaded packages
#' @examples
#' get_licenses()
#' @export
get_licenses <- function() {

    DF.output <- data.frame(
        package    = character(0),
        version    = character(0),
        license    = character(0),
        repository = character(0),
        stringsAsFactors=FALSE
    );

    my.sessionInfo <- sessionInfo();
    temp.list <- intersect(c("otherPkgs","loadedOnly"),names(my.sessionInfo));

    for (temp.name in temp.list) {
        for (temp.package in my.sessionInfo[[temp.name]]) {
            temp.row <- data.frame(
                package    = .my.ifelse(temp.package[["Package"]]),
                version    = .my.ifelse(temp.package[["Version"]]),
                license    = .my.ifelse(temp.package[["License"]]),
                repository = .my.ifelse(temp.package[["Repository"]]),
                stringsAsFactors=FALSE
            );
            DF.output <- rbind(DF.output,temp.row);
        }
    }

    DF.output <- DF.output[with(DF.output,order(license,package)),];
    rownames(DF.output) <- seq(1,nrow(DF.output));

    return( DF.output );
}

.my.ifelse <- function(x) { ifelse(is.null(x),NA,x) }
