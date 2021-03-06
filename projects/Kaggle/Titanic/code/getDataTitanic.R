
getDataTitanic <- function(data.directory = NULL) {

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.titanic <- read.table(
		file             = paste0(data.directory,"/train.csv"),
		header           = TRUE,
		sep              = ',',
		quote            = '"',
		stringsAsFactors = FALSE
		);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	colnames(DF.titanic) <- gsub(
		x           = colnames(DF.titanic),
		pattern     = "PassengerId",
		replacement = "PassengerID"
		);

	DF.titanic[['PassengerID']] <- as.character(DF.titanic[['PassengerID']]);
	DF.titanic[['Pclass'     ]] <- factor(DF.titanic[['Pclass']]);
	DF.titanic[['Sex'        ]] <- factor(DF.titanic[['Sex']]);

	DF.titanic[['Cabin']] <- factor(
		x = gsub(x=DF.titanic[['Cabin']],pattern="^$",replacement="unknown")
		);

	DF.titanic[['Embarked']] <- factor(
		x      = DF.titanic[['Embarked']],
		levels = c("C","Q","S","U"),
		labels = c('Cherbourg','Queenstown','Southampton','unknown')
		);
	DF.titanic[is.na(DF.titanic[['Embarked']]),'Embarked'] <- "unknown";

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	DF.titanic[,'AgeGroup'] <- as.character(cut(
		x      = DF.titanic[['Age']],
		breaks = c(0,16,50,Inf),
		right  = FALSE
		));
	DF.titanic[is.na(DF.titanic[['AgeGroup']]),'AgeGroup'] <- "Unknown";
	DF.titanic[['AgeGroup']] <- as.factor(DF.titanic[['AgeGroup']]);

	DF.titanic[,'SibSpGroup'] <- as.character(cut(
		x      = DF.titanic[['SibSp']],
		breaks = c(0,1,Inf),
		right  = FALSE
		));
	DF.titanic[['SibSpGroup']] <- as.factor(DF.titanic[['SibSpGroup']]);

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
	return(DF.titanic);

	}

