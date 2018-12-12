
pop <- function(list, i = length(list)) {
    stopifnot(inherits(list, "list"))
    if (0 == length(list)) { return(NULL); }
    result <- list[[i]];
    assign(deparse(substitute(list)), list[-i], envir = .GlobalEnv);
    return( result );
    }

push <- function(list, x, i = length(list)) {
    stopifnot(inherits(list, "list"));
    return( c(list,list(x)) );
    }

