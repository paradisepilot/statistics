
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

####################################################################################################
alphabet      <- c('A','C','G','T');
string.length <- 7;

strings <- .enumerate.strings(alphabet = alphabet, string.length = string.length);
DF.temp <- cbind(strings,sapply(X = strings, FUN = .is.stopping.sequence, alphabet = alphabet));
temp    <- DF.temp[DF.temp[,2]==1,];
dim(temp);
temp;

