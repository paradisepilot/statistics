
require(R6);

myCART  <- R6Class(
    classname = "myCART",

    public = list(

        formula = NULL,
        data    = NULL,
        nodes   = list(),

        initialize = function(formula, data) {
            self$formula <- as.formula(formula);
            self$data    <- data;

            temp <- all.vars(self$formula);
            colname.response   <- temp[1];
            colname.predictors <- temp[2];
            if (identical(".",colname.predictors)) {
                colname.predictors <- setdiff(colnames(self$data),c(colname.response));
                }

            cat( "\nself$formula:\n" )
            print(  self$formula     )

            cat( "\nstr(self$formula):\n" )
            print(  str(self$formula)     )

            cat( "\ncolname.response\n" );
            print(  colname.response    );

            cat( "\ncolname.predictors\n" );
            print(  colname.predictors    );

            },

        grow = function() {
            return( NULL );
            },

        predict = function() {
            return( NULL );
            }

        )
    )

