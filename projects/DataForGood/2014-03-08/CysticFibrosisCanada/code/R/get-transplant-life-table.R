
get.transplant.life.table <- function(
	CFC.Registry     = NULL,
	output.directory = NULL
	) {

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

	#print('str(DF.transplants)');
	#print( str(DF.transplants) );
	#print('summary(DF.transplants)');
	#print( summary(DF.transplants) );

	#unknowns <- DF.transplants['Unknown' == DF.transplants[,'OrganName'],'PatientKey'];
	#knowns   <- DF.transplants['Unknown' != DF.transplants[,'OrganName'],'PatientKey'];
	#unknown.only <- setdiff(unknowns,knowns);
	#print('unknown.only');
	#print( unknown.only );
	#DF.temp <- DF.transplants[DF.transplants[,'PatientKey'] %in% unknown.only,];
	#DF.temp <- DF.temp[order(DF.temp[,'PatientKey']),];
	#print('str(DF.temp)');
	#print( str(DF.temp) );
	#print('DF.temp');
	#print( DF.temp );

	patients.with.transplants <- DF.transplants[,'PatientKey'];
	print('length(patients.with.transplants)');
	print( length(patients.with.transplants) );
	print('length(unique(patients.with.transplants))');
	print( length(unique(patients.with.transplants)) );

	DF.patients <- CFC.Registry[['tblPatients']];
	DF.patients <- DF.patients[DF.patients[,'PatientID'] %in% patients.with.transplants,];
	print('str(DF.patients)');
	print( str(DF.patients) );

	DF.patients.with.transplants <- merge(
		x    = DF.patients,
		y    = DF.transplants,
		by.x = 'PatientID',
		by.y = 'PatientKey'
		);
	print('str(DF.patients.with.transplants)');
	print( str(DF.patients.with.transplants) );

	DF.dispositions <- CFC.Registry[['tblDisposition']][,c('DispositionID','Disposition')];
	print('str(DF.dispositions)');
	print( str(DF.dispositions) );

	print("colnames(CFC.Registry[['tblAnnualData']])");
	print( colnames(CFC.Registry[['tblAnnualData']]) );

	DF.annual.data <- CFC.Registry[['tblAnnualData']][,c('PatientKey','ReportYr','DispositionKey')];
	DF.annual.data[,'ReportYr'] <- as.Date(paste0(as.character(DF.annual.data[,'ReportYr']),'-01-01'));
	DF.annual.data <- DF.annual.data[DF.annual.data[,'PatientKey'] %in% patients.with.transplants,];
	DF.annual.data <- merge(
		x    = DF.annual.data,
		y    = DF.dispositions,
		by.x = 'DispositionKey',
		by.y = 'DispositionID'
		);
	print('str(DF.annual.data)');
	print( str(DF.annual.data) );

	DF.temp <- aggregate(
		formula = ReportYr ~ PatientKey,
		data    = DF.annual.data,
		FUN     = max
		);
	DF.annual.data <- merge(
		x  = DF.annual.data,
		y  = DF.temp,
		by = c('PatientKey','ReportYr')
		);
	DF.annual.data <- DF.annual.data[order(DF.annual.data[,'PatientKey'],DF.annual.data[,'ReportYr']),]; 

	print('str(DF.annual.data)');
	print( str(DF.annual.data) );
	print('summary(DF.annual.data)');
	print( summary(DF.annual.data) );

	write.table(file = 'annual-data.csv', x = DF.annual.data, sep = '\t', quote = FALSE, row.names = FALSE);

	DF.patients.with.transplants <- merge(
		x     = DF.patients.with.transplants,
		y     = DF.annual.data,
		by.x  = 'PatientID',
		by.y  = 'PatientKey',
		all.x = TRUE,
		all.y = FALSE
		);

	write.table(
		file      = 'patients-with-transplants.csv',
		x         = DF.patients.with.transplants,
		sep       = '\t',
		quote     = FALSE,
		row.names = FALSE
		);

	return(1);

	}

