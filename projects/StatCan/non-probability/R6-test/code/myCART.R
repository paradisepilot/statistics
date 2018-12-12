
require(R6);

myCART  <- R6Class(
    classname = "myCART",

    public = list(

        formula = NULL,
        data    = NULL,

        response           = NULL,
        predictors_factor  = NULL,
        predictors_numeric = NULL,

        nodes = list(),

        initialize = function(formula, data) {
            self$formula <- as.formula(formula);
            self$data    <- data;

            temp <- all.vars(self$formula);
            self$response      <- temp[1];
            colname_predictors <- temp[2];
            if (identical(".",colname_predictors)) {
                colname_predictors <- setdiff(colnames(self$data),c(self$response));
                }

            self$predictors_factor  <- colname_predictors[sapply(X=data[1,colname_predictors],FUN=is.factor )]
            self$predictors_numeric <- colname_predictors[sapply(X=data[1,colname_predictors],FUN=is.numeric)]

            cat( "\nself$formula:\n" )
            print(  self$formula     )

            cat( "\nstr(self$formula):\n" )
            print(  str(self$formula)     )

            cat( "\nself$response\n" );
            print(  self$response    );

            cat( "\nself$predictors_factor\n" );
            print(  self$predictors_factor    );

            cat( "\nself$predictors_numeric\n" );
            print(  self$predictors_numeric    );

            remove(temp);

            },

        grow = function() {
            return( NULL );
            },

        predict = function() {
            return( NULL );
            }

        ),

    private = list(
        pop = function(list, i = length(list)) {
            stopifnot(inherits(list, "list"))
            if (0 == length(list)) { return(NULL); }
            result <- list[[i]];
            assign(deparse(substitute(list)), list[-i], envir = .GlobalEnv);
            return( result );
            },
        push = function(list, x, i = length(list)) {
            stopifnot(inherits(list, "list"));
            return( c(list,list(x)) );
            }
        )

    )

