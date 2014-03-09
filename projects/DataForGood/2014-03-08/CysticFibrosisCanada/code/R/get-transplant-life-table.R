
get.transplant.life.table <- function(
	CFC.Registry     = NULL,
	output.directory = NULL
	) {

	print('names(CFC.Registry)');
	print( names(CFC.Registry) );

	################################################################################################
	DF.organs <- CFC.Registry[['tblOrgans']][,c('OrganID','OrganName')];

	DF.transplants <- CFC.Registry[['tblTransplants']][,c('TransplantID','PatientKey','TransplantDt','ListingDt','OrganKey')];
	DF.transplants[,'TransplantDt'] <- as.Date(DF.transplants[,'TransplantDt']);
	DF.transplants[,'ListingDt']    <- as.Date(DF.transplants[,'ListingDt']);

	DF.transplants <- merge(
		x    = DF.transplants,
		y    = DF.organs,
		by.x = 'OrganKey',
		by.y = 'OrganID'
		);
	DF.transplants <- DF.transplants[,setdiff(colnames(DF.transplants),'OrganKey')];
	DF.transplants[order(DF.transplants[,'PatientKey']),];

	DF.temp <- aggregate(
		formula = TransplantDt ~ PatientKey,
		data    = DF.transplants,
		FUN     = min
		);
	DF.temp[,'TransplantDt'] <- as.Date(DF.temp[,'TransplantDt']);
	colnames(DF.temp) <- gsub(x = colnames(DF.temp), pattern = 'TransplantDt', replacement = 'FirstTransplantDt');

	DF.transplants <- merge(
		x = DF.transplants,
		y = DF.temp,
		by.x = 'PatientKey',
		by.y = 'PatientKey'
		);

	had.lung.transplants <- grepl(x = DF.transplants[,'OrganName'], pattern = '(lung|unknown)', ignore.case = TRUE);
	patients.with.lung.transplants <- unique(DF.transplants[had.lung.transplants,'PatientKey']);
	DF.transplants[,'lung.transplant'] <- FALSE;
	DF.transplants[DF.transplants[,'PatientKey'] %in% patients.with.lung.transplants,'lung.transplant'] <- TRUE;

	write.table(
		file      = 'transplants.csv',
		x         = DF.transplants,
		sep       = '\t',
		quote     = FALSE,
		row.names = FALSE
		);

	patients.with.transplants <- unique(DF.transplants[,'PatientKey']);

	################################################################################################
	DF.patients.with.BCepacia <- CFC.Registry[['tblAnnualData']][,c('AnnualDataID','PatientKey','ReportYr')];
	DF.patients.with.BCepacia <- DF.patients.with.BCepacia[DF.patients.with.BCepacia[,'PatientKey'] %in% patients.with.transplants,];

	DF.annual.BCepacia <- CFC.Registry[['tlinkAnnualBCepacia']];
	DF.patients.with.BCepacia <- merge(
		x    = DF.patients.with.BCepacia,
		y    = DF.annual.BCepacia,
		by.x = 'AnnualDataID',
		by.y = 'AnnualKey'
		);

	DF.BCepacia <- CFC.Registry[['tblBCepacia']];
	DF.patients.with.BCepacia <- merge(
		x    = DF.patients.with.BCepacia,
		y    = DF.BCepacia,
		by.x = 'BCepaciaKey',
		by.y = 'BCepaciaID'
		);

	DF.patients.with.BCepacia <- DF.patients.with.BCepacia[order(DF.patients.with.BCepacia[,'PatientKey'],DF.patients.with.BCepacia[,'ReportYr']),];

	print('str(DF.patients.with.BCepacia)');
	print( str(DF.patients.with.BCepacia) );
	print('summary(DF.patients.with.BCepacia)');
	print( summary(DF.patients.with.BCepacia) );

	write.table(
		file      = 'patients-with-BCepacia.csv',
		x         = DF.patients.with.BCepacia,
		sep       = '\t',
		quote     = FALSE,
		row.names = FALSE
		);

	patients.with.BCepacia <- unique(DF.patients.with.BCepacia[,'PatientKey']);

	################################################################################################
	DF.patients <- CFC.Registry[['tblPatients']];
	DF.patients[,'BirthDt'] <- as.Date(DF.patients[,'BirthDt']);
	DF.patients[,'DiagDt']  <- as.Date(DF.patients[,'DiagDt']);
	DF.patients[,'DeathDt'] <- as.Date(DF.patients[,'DeathDt']);
	DF.patients[367 == DF.patients[,'PatientID'],'DeathDt'] <- as.Date("2006-10-17");

	################################################################################################
	DF.patients.with.transplants <- DF.patients[DF.patients[,'PatientID'] %in% patients.with.transplants,];
	print('str(DF.patients)');
	print( str(DF.patients) );

	DF.patients.with.transplants <- merge(
		x    = DF.patients.with.transplants[,c('PatientID','Sex')],
		y    = DF.transplants,
		by.x = 'PatientID',
		by.y = 'PatientKey'
		);

	print('str(DF.patients.with.transplants)');
	print( str(DF.patients.with.transplants) );

	DF.temp <- aggregate(
		formula = FirstTransplantDt ~ PatientID,
		data    = DF.patients.with.transplants,
		FUN     = min
		);
	#DF.temp[,'TransplantDt'] <- as.Date(DF.temp[,'TransplantDt']);

	DF.patients.with.transplants <- merge(
		x  = DF.patients,
		y  = DF.temp,
		by = 'PatientID'
		);

	DF.races <- CFC.Registry[['tblRaces']];
	DF.patients.with.transplants <- merge(
		x    = DF.patients.with.transplants,
		y    = DF.races,
		by.x = 'RaceKey',
		by.y = 'RaceID'
		);

	DF.patients.with.transplants[,'BCepacia'] <- rep(FALSE,nrow(DF.patients.with.transplants));
	DF.patients.with.transplants[DF.patients.with.transplants[,'PatientID'] %in% patients.with.BCepacia,'BCepacia'] <- TRUE;

	DF.patients.with.transplants[,'lung.transplant'] <- rep(FALSE,nrow(DF.patients.with.transplants));
	DF.patients.with.transplants[DF.patients.with.transplants[,'PatientID'] %in% patients.with.lung.transplants,'lung.transplant'] <- TRUE;

	DF.annual.data <- CFC.Registry[['tblAnnualData']][,c('AnnualDataID','PatientKey','ReportYr')];
	DF.annual.data[,'ReportYr'] <- as.Date(paste0(as.character(DF.annual.data[,'ReportYr']),'-12-31'));
	DF.annual.data <- DF.annual.data[DF.annual.data[,'PatientKey'] %in% patients.with.transplants,];

	write.table(
		file      = 'annual-data.csv',
		x         = DF.annual.data,
		sep       = '\t',
		quote     = FALSE,
		row.names = FALSE
		);

	DF.LastReportYr <- aggregate(
		formula = ReportYr ~ PatientKey,
		data    = DF.annual.data,
		FUN     = max
		);
	colnames(DF.LastReportYr) <- gsub(
		x           = colnames(DF.LastReportYr),
		pattern     = 'ReportYr',
		replacement = 'LastReportYr'
		);

	DF.patients.with.transplants <- merge(
		x    = DF.patients.with.transplants,
		y    = DF.LastReportYr,
		by.x = 'PatientID',
		by.y = 'PatientKey'
		);

	DF.patients.with.transplants <- .select.columns(
		DF.input = DF.patients.with.transplants
		);

	DF.patients.with.transplants[,'post.Y2K'] <- FALSE;
	DF.patients.with.transplants[as.Date("2000-01-01") <= DF.patients.with.transplants[,'FirstTransplantDt'],'post.Y2K'] <- TRUE;

	DF.patients.with.transplants[,'ExitDt'] <- DF.patients.with.transplants[,'DeathDt'];
	is.not.dead <- is.na(DF.patients.with.transplants[,'DeathDt']);
	DF.patients.with.transplants[is.not.dead,'ExitDt'] <- DF.patients.with.transplants[is.not.dead,'LastReportYr']; 
	DF.patients.with.transplants[is.not.dead,'ExitDt'] <- apply(
		X      = DF.patients.with.transplants[is.not.dead,c('FirstTransplantDt','LastReportYr')],
		MARGIN = 1,
		FUN    = max
		);

	DF.patients.with.transplants[,'integer.FirstTransplantDt'] <- as.integer(DF.patients.with.transplants[,'FirstTransplantDt']) / 365.25;
	DF.patients.with.transplants[,'integer.ExitDt']       <- as.integer(DF.patients.with.transplants[,'ExitDt']) / 365.25;

	DF.patients.with.transplants[,'integer.followup.time'] <- DF.patients.with.transplants[,'integer.ExitDt'] - DF.patients.with.transplants[,'integer.FirstTransplantDt'];

	min.date.integer <- min(DF.patients.with.transplants[,'integer.FirstTransplantDt']);
	DF.patients.with.transplants[,'integer.FirstTransplantDt'] <- DF.patients.with.transplants[,'integer.FirstTransplantDt']  - min.date.integer;
	DF.patients.with.transplants[,'integer.ExitDt'] <- DF.patients.with.transplants[,'integer.ExitDt'] - min.date.integer;

	DF.patients.with.transplants[,'Event'] <- rep(1,nrow(DF.patients.with.transplants));
	DF.patients.with.transplants[is.na(DF.patients.with.transplants[,'DeathDt']),'Event'] <- 0;

	print('str(DF.patients.with.transplants)');
	print( str(DF.patients.with.transplants) );
	print('summary(DF.patients.with.transplants)');
	print( summary(DF.patients.with.transplants) );

	write.table(
		file      = 'patients-with-transplants.csv',
		x         = DF.patients.with.transplants,
		sep       = '\t',
		quote     = FALSE,
		row.names = FALSE
		);

	################################################################################################
	resolution <- 300;
	xmin <-  0;
	xmax <- 30;
	ymax <-  1;

	library(survival)
	library(ggplot2);
	library(GGally);
	#library(eha);

	### Overall
	temp.filename <- 'post-transplant-survival-overall.png';
	temp.surv <- survfit(Surv(integer.followup.time,Event) ~ 1, data = DF.patients.with.transplants);
	my.ggplot <- ggsurv(temp.surv);
	my.ggplot <- my.ggplot + xlab("Time (Years)");
	my.ggplot <- my.ggplot + theme(axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

	### Sex
	temp.filename <- 'post-transplant-survival-Sex.png';

	results.logrank <- coxph(Surv(integer.followup.time,Event) ~ Sex, data = DF.patients.with.transplants);
	temp <- summary(results.logrank);
	logrank.stat <- temp[['sctest']][['test']];
	logrank.pval <- temp[['sctest']][['pvalue']];

	temp.surv <- survfit(Surv(integer.followup.time,Event) ~ Sex, data = DF.patients.with.transplants);
	my.ggplot <- ggsurv(temp.surv);
	my.ggplot <- my.ggplot + xlab("Time (Years)");
	my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
	my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

	### B. Cepacia
	temp.filename <- 'post-transplant-survival-BCepacia.png';

	results.logrank <- coxph(Surv(integer.followup.time,Event) ~ BCepacia, data = DF.patients.with.transplants);
	temp <- summary(results.logrank);
	logrank.stat <- temp[['sctest']][['test']];
	logrank.pval <- temp[['sctest']][['pvalue']];

	temp.surv <- survfit(Surv(integer.followup.time,Event) ~ BCepacia, data = DF.patients.with.transplants);
	my.ggplot <- ggsurv(temp.surv);
	my.ggplot <- my.ggplot + xlab("Time (Years)");
	my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
	my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

	### Y2K
	temp.filename <- 'post-transplant-survival-Y2K.png';

	results.logrank <- coxph(Surv(integer.followup.time,Event) ~ post.Y2K, data = DF.patients.with.transplants);
	temp <- summary(results.logrank);
	logrank.stat <- temp[['sctest']][['test']];
	logrank.pval <- temp[['sctest']][['pvalue']];

	temp.surv <- survfit(Surv(integer.followup.time,Event) ~ post.Y2K, data = DF.patients.with.transplants);
	my.ggplot <- ggsurv(temp.surv);
	my.ggplot <- my.ggplot + xlab("Time (Years)");
	my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
	my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

	### Lung
	temp.filename <- 'post-transplant-survival-lung.png';

	results.logrank <- coxph(Surv(integer.followup.time,Event) ~ lung.transplant, data = DF.patients.with.transplants);
	temp <- summary(results.logrank);
	logrank.stat <- temp[['sctest']][['test']];
	logrank.pval <- temp[['sctest']][['pvalue']];

	temp.surv <- survfit(Surv(integer.followup.time,Event) ~ lung.transplant, data = DF.patients.with.transplants);
	my.ggplot <- ggsurv(temp.surv);
	my.ggplot <- my.ggplot + xlab("Time (Years)");
	my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
	my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
	ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

	return(1);

	}

####################################################################################################
.select.columns <- function(DF.input = NULL) {
	selected.columns <- c(
		'PatientID',
		'Sex',
		'Race',
		'BirthDt',
		'DiagDt',
		'BCepacia',
		'lung.transplant',
		'FirstTransplantDt',
		'DeathDt',
		'LastReportYr'
		);
	DF.output <- DF.input[,selected.columns];
	return(DF.output);
	}

