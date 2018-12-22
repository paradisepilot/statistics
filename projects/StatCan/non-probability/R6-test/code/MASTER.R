
command.arguments <- commandArgs(trailingOnly = TRUE);
   code.directory <- normalizePath(command.arguments[1]);
 output.directory <- normalizePath(command.arguments[2]);

cat(paste0("##### Sys.time(): ",Sys.time(),"\n"));
start.proc.time <- proc.time();

setwd(output.directory);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(rpart);
library(rpart.plot);
library(RColorBrewer);

library(R6);
source(paste0(code.directory,'/myCART.R'));

###################################################
data(iris);
print( str( iris) );
print( head(iris) );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
myTree <- myCART$new(
    formula = Species ~ .,
    data    = iris
    );
#print( str(myTree) );

myTree$grow();
#cat("\nmyTree$nodes\n" );
#print( myTree$nodes    );

myTree$print();

print( myTree$get_cp_table() );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.rpart <- rpart(
    formula = Species ~ .,
    data    = iris,
    control = list(
        minsplit  = 1,
        minbucket = 1,
        cp        = 0
        )
    );

cat("\nresults.rpart\n");
print( results.rpart   );
printcp( x = results.rpart, digits = 3 );

palette.iris <- brewer.pal(3,"Set1")[c(3,2,1)]; # c("green","blue","red");
names(palette.iris) <- c("setosa","versicolor","virginica");

palette.iris.light        <- c("#99ff99","#99ccff","#ffad99");
names(palette.iris.light) <- c("setosa","versicolor","virginica");

FILE.ggplot <- "plot-rpart.png";
png(filename = FILE.ggplot, height = 12, width = 30, units = "in", res = 300);
prp(
    x           = results.rpart,
    extra       = 101,
    cex         = 3.5, # 3.5,
    legend.cex  = 3.5,
    box.palette = as.list(palette.iris.light)
    );
dev.off();

###################################################
# print warning messages to log
cat("\n##### warnings()\n")
print(warnings());

# print session info to log
cat("\n##### sessionInfo()\n")
print( sessionInfo() );

# print system time to log
cat(paste0("\n##### Sys.time(): ",Sys.time(),"\n"));

# print elapsed time to log
stop.proc.time <- proc.time();
cat("\n##### start.proc.time() - stop.proc.time()\n");
print( stop.proc.time - start.proc.time );

q();

