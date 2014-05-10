
spss.to.csv <- function(
	unicef.directory = NULL,
	output.directory = NULL,
	output.prefix    = NULL
	) {

	table.names <- dbListTables(mysql.connection);
	print('table.names');
	print( table.names );

	LIST.output <- list();
	for (table.name in table.names) {

		sql <- paste0("select * from ",table.name);
		myQuery <- dbSendQuery(mysql.connection, sql);
		DF.temp <- fetch(myQuery, n = -1);
		print('str(DF.temp)');
		print( str(DF.temp) );

		LIST.output[[table.name]] <- DF.temp;

		write.table(
			file      = paste0(table.name,'.csv'),
			x         = DF.temp,
			row.names = FALSE,
			sep       = '\t',
			quote     = FALSE
			);

		}

	return(LIST.output);

	}

