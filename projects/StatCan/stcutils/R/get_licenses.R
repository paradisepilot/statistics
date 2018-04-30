
#' retrieves licenses of all attached and loaded packages
#'
#' \code{get_licenses} retrieves the versions, licenses and repositories of
#' all the attached and loaded R packages in an R session.
#'
#' @return A data frame of the names, versions, licenses and repositories
#'     of the attached and loaded packages
#' @examples
#' # > library(ggplot2)
#' # > library(stcutils)
#' # > get_licenses()
#' # package    version                     license repository
#' # 1  colorspace      1.3-2 BSD_3_clause + file LICENSE       CRAN
#' # 2        Rcpp    0.12.11                  GPL (>= 2)       CRAN
#' # 3      gtable      0.2.0                       GPL-2       CRAN
#' # 4     ggplot2      2.2.1        GPL-2 | file LICENSE       CRAN
#' # 5    lazyeval      0.2.0                       GPL-3       CRAN
#' # 6       rlang      0.1.6                       GPL-3       CRAN
#' # 7    stcutils 0.0.0.9000                       GPL-3       <NA>
#' # 8     munsell      0.4.3          MIT + file LICENSE       CRAN
#' # 9        plyr      1.8.4          MIT + file LICENSE       CRAN
#' # 10     scales      0.4.1          MIT + file LICENSE       CRAN
#' # 11     tibble      1.3.3          MIT + file LICENSE       CRAN
#' # 12   compiler      3.4.3             Part of R 3.4.3       <NA>
#' # 13       grid      3.4.3             Part of R 3.4.3       <NA>
#' @export
get_licenses <- function() {

    DF.output <- data.frame(
        package    = character(0),
        version    = character(0),
        license    = character(0),
        repository = character(0),
        stringsAsFactors=FALSE
    );

    my.sessionInfo <- utils::sessionInfo();
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
