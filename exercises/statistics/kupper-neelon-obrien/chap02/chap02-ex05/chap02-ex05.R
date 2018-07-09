
.enumerate.strings <- function(alphabet = NULL, string.length = NULL) {
	output.strings <- alphabet;
	if (string.length > 1) {
		temp.strings <- output.strings;
		for (i in 2:string.length) {
			temp <- paste0(alphabet[1],temp.strings);
			for (j in 2:length(alphabet)) {
				temp <- c(temp,paste0(alphabet[j],temp.strings));
				}
			temp.strings <- temp;
			}
		output.strings <- temp.strings;
		}
	return(output.strings);
	}

.is.stopping.sequence <- function(x = NULL, alphabet = NULL) {
	split.x  <- strsplit(x,split='')[[1]];
	if ((length(alphabet)    == length(unique(split.x))) &
		(length(alphabet)-1) == length(unique(split.x[1:(length(split.x)-1)]))) {
		return(1);
		}
	return(0);
	}

.binarize <- function(x = NULL) {
	temp    <- integer(length = length(x));
	split.x <- strsplit(x = x, split = '')[[1]];
	for (i in 1:length(split.x)) {
		temp[i] <- length(unique(split.x[1:i]));
		}
	lag.temp <- c(0,temp[1:(length(temp)-1)]);
	return(paste(temp-lag.temp,collapse=''));
	}

####################################################################################################
alphabet      <- c('A','C','G','T');

for (string.length in 5:8) {

	print('################################################################');

	print('string.length');
	print( string.length );

	strings <- .enumerate.strings(alphabet = alphabet, string.length = string.length);
	DF.temp <- cbind(strings,sapply(X = strings, FUN = .is.stopping.sequence, alphabet = alphabet));

	temp <- DF.temp[DF.temp[,2]==1,];
	temp <- cbind(temp,sapply(X=temp[,1],FUN=.binarize));
	#temp;

	print('table(temp[,3])');
	print( table(temp[,3]) );

	print('table(temp[,3]) / 24');
	print( table(temp[,3]) / 24 );

	}

