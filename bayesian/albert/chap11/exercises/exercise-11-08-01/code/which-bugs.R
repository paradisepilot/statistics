
which.bugs <- function() {
	bugs.path <- Sys.which("OpenBUGS");
	LIST.output <- list(
		bugs.path = bugs.path,
		use.wine  = grepl(x = bugs.path, pattern = "\\.exe$")
		);
	return(LIST.output);
	}

