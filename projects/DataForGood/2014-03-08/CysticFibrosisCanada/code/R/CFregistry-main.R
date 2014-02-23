### PARAMETERS ####################################################################################
#library(ggplot2);
#library(gridExtra);
#library(lattice);
#library(latticeExtra);
#library(lubridate);
#library(reshape);
#library(zoo); # Needed to override as.Date.numeric

### PARAMETERS ####################################################################################

#access.date <- "20130913"; # Used for Summary Reports
#access.date <- "20131125";
access.date <- "20140113";
year <- 2012;
end.of.year <- "2012-12-31";

### HELPER FUNCTIONS ##############################################################################
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

### LOAD DATA #####################################################################################
source(paste0(code.directory,'/CFregistry-utils.R'));
setwd(table.directory);

data <- load.data();

# Retrieve patient names
#if (.Platform$OS.type == "windows") {
#  cpdr.patients <- read.custom.csv("cpdrPatients.csv");
#  cpdr.patients$Birth.Date <- convert.date(cpdr.patients$Birth.Date);
#}

# Convert dates
data$patients$BirthDt         <- convert.date(data$patients$BirthDt);
data$patients$DeathDt         <- convert.date(data$patients$DeathDt);
data$patients$DiagDt          <- convert.date(data$patients$DiagDt);
data$transplants$TransplantDt <- convert.date(data$transplants$TransplantDt);
data$annual.clinical$ExamDt   <- convert.date(data$annual.clinical$ExamDt);

#annual.2012          <- data$annual.data[data$annual.data$ReportYr == year,];
#annual.clinical <- merge(annual.2012, data$annual.clinical, by.x = "AnnualDataID", by.y = "AnnualDataKey");
#annual.clinical <- merge(annual.clinical, data$patients, by.x = "PatientKey", by.y = "PatientID");
annual.clinical <- retrieve.annual.clinical(year);

# Add culture data
all.annual.cultures <- merge(data$annual.cultures, data$cultures, by.x = "CultureKey", by.y = "CultureID");
all.BCepacia        <- merge(data$BCepacia, data$annualBCepacia, by.x = "BCepaciaID", by.y = "BCepaciaKey");

### FILTERING STEP ################################################################################
print("Filter patients with disposition flag = 6!!");

# Remove patients with Disposition flag = 6
data$patients <- data$patients[!data$patients$Disp6Flag,];
# Remove those patients from annual.data
data$annual.data <- data$annual.data[data$annual.data$PatientKey %in% data$patients$PatientID,];
# Remove those patients from annual.clinical
data$annual.clinical <- data$annual.clinical[data$annual.clinical$AnnualDataKey %in% data$annual.data$AnnualDataID,];

print('str(data)');
print( str(data) );

