
which.bugs <- function() {

	bugs.path <- Sys.which("OpenBUGS");
	if (.is.Darwin()) { bugs.path <- "/Applications/OpenBUGS/OpenBUGS321/OpenBUGS.exe"; }

	LIST.output <- list(
		bugs.path = bugs.path,
		use.wine  = grepl(x = bugs.path, pattern = "\\.exe$")
		);

	return(LIST.output);

	}

### AUXILIARY FUNCTIONS ############################################################################
.is.Darwin <- function() {
	is.Darwin <- grepl(
		x           = system(command = 'uname', intern = TRUE),
		pattern     = 'Darwin',
		ignore.case = TRUE
		);

	return(is.Darwin);
	}

