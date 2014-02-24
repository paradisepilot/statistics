
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

####################################################################################################
library(RMySQL);

####################################################################################################
conn.CFC  <- dbConnect(drv = MySQL(), user='webuser', password='', dbname='CFC', host='localhost');

print("dbListTables(conn.CFC)");
dbListTables(conn.CFC);

print("dbListFields(conn.CFC, 'tblPatients')");
dbListFields(conn.CFC, 'tblPatients');

print("dbListFields(conn.CFC, 'tblAnnualData')");
dbListFields(conn.CFC, 'tblAnnualData');

print("dbListFields(conn.CFC, 'tblDisposition')");
dbListFields(conn.CFC, 'tblDisposition');

####################################################################################################
setwd(output.directory);

####################################################################################################
sql <- "select PatientID,BirthDt from tblPatients";
myQuery <- dbSendQuery(conn.CFC, sql);
DF.patient.birth.dates <- fetch(myQuery, n = -1);
DF.patient.birth.dates[,'BirthDate'] <- as.Date(DF.patient.birth.dates[,'BirthDt']);
str(DF.patient.birth.dates);
summary(DF.patient.birth.dates);

write.table(
	file      = 'patient-birth-dates.csv',
	x         = DF.patient.birth.dates,
	row.names = FALSE,
	sep       = '\t',
	quote     = FALSE
	);

is.selected <- DF.patient.birth.dates[,'BirthDate'] >= as.Date("2008-01-01");
DF.temp <- DF.patient.birth.dates[is.selected,];
str(DF.temp);
summary(DF.temp);

write.table(
	file      = 'temp.csv',
	x         = DF.temp,
	row.names = FALSE,
	sep       = '\t',
	quote     = FALSE
	);

####################################################################################################
sql <- "select * from tblDisposition";
myQuery <- dbSendQuery(conn.CFC, sql);
DF.dispositions <- fetch(myQuery, n = -1);
str(DF.dispositions);
DF.dispositions;

####################################################################################################
sql <- "select * from tblTransplants";
myQuery <- dbSendQuery(conn.CFC, sql);
DF.transplants <- fetch(myQuery, n = -1);
str(DF.transplants);
DF.transplants;

write.table(
	file      = 'transplants.csv',
	x         = DF.transplants,
	row.names = FALSE,
	sep       = '\t',
	quote     = FALSE
	);

####################################################################################################

dbDisconnect(conn.CFC);
q();

####################################################################################################

#access.date <- "20130913"; # Used for Summary Reports
#access.date <- "20131125";
access.date <- "20140113";
year <- 2012;
end.of.year <- "2012-12-31";

### HELPER FUNCTIONS ##############################################################################
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

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

####################################################################################################
print(output.directory);
setwd(output.directory);

DF.data <- data[['annual.data']];

DF.data <- merge(
	x    = data[['patients']],
	y    = DF.data,
	by.x = 'PatientID',
	by.y = 'PatientKey'
	);

DF.data <- merge(
	x    = data[['annual.clinical']],
	y    = DF.data,
	by.x = 'AnnualDataKey',
	by.y = 'AnnualDataID'
	);

write.table(
	file      = 'new-born-screen.csv',
	x         = DF.data,
	row.names = FALSE,
	sep       = '\t',
	quote     = FALSE
	);

