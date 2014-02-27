
extract.transplant.data <- function(
	CFC.Registry     = NULL,
	output.directory = NULL
	) {

	#print('str(CFC.Registry)');
	#print( str(CFC.Registry) );

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

	print('str(DF.transplants)');
	print( str(DF.transplants) );
	print('summary(DF.transplants)');
	print( summary(DF.transplants) );

	unknowns <- DF.transplants['Unknown' == DF.transplants[,'OrganName'],'PatientKey'];
	knowns   <- DF.transplants['Unknown' != DF.transplants[,'OrganName'],'PatientKey'];
	unknown.only <- setdiff(unknowns,knowns);
	print('unknown.only');
	print( unknown.only );
	DF.temp <- DF.transplants[DF.transplants[,'PatientKey'] %in% unknown.only,];
	DF.temp <- DF.temp[order(DF.temp[,'PatientKey']),];
	print('str(DF.temp)');
	print( str(DF.temp) );
	print('DF.temp');
	print( DF.temp );

	patients.with.transplants <- DF.transplants[,'PatientKey'];
	print('length(patients.with.transplants)');
	print( length(patients.with.transplants) );
	print('length(unique(patients.with.transplants))');
	print( length(unique(patients.with.transplants)) );

	DF.patients <- CFC.Registry[['tblPatients']];
	DF.patients <- DF.patients[DF.patients[,'PatientID'] %in% patients.with.transplants,];
	print('str(DF.patients)');
	print( str(DF.patients) );

	return(1);

	}

