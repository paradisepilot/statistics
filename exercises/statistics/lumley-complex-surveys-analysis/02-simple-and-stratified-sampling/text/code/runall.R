
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];

setwd(output.directory);

###################################################
source(file.path(code.directory,"figure-02-02.R"));
source(file.path(code.directory,"figure-02-03.R"));
source(file.path(code.directory,"figure-02-04.R"));
source(file.path(code.directory,"figure-02-05.R"));
source(file.path(code.directory,"figure-02-06.R"));
source(file.path(code.directory,"figure-02-07.R"));
source(file.path(code.directory,"figure-02-08.R"));
source(file.path(code.directory,"getData-CHIS-adult.R"));

resolution <- 300;

###################################################
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#figure.02.02();
#figure.02.03();
#figure.02.04();
#figure.02.05();
#figure.02.06();
figure.02.07();
#figure.02.08(data.directory = data.directory);

###################################################
cat("\n\n### warnings()\n");
print( warnings() );

cat("\n\n### sessionInfo()\n");
print( sessionInfo() );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
q();
