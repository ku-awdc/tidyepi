tidyepi_env <- new.env()
tidyepi_env$shinyserver <- FALSE
tidyepi_env$tmpdir <- NULL
tidyepi_env$files <- list()
tidyepi_env$mtdtreqcols <- c("Metadata","Text")
tidyepi_env$keyreqcols <- c("Dataset","Variable","Type","Min","Max","Categories","MissingOK","Description")


.onLoad <- function(lib, pkg)
{
    ## Create a temporary folder for generating reports etc:
	tidyepi_env$tmpdir <- file.path(tempdir(check=TRUE), "tidyepi")
	dir.create(tidyepi_env$tmpdir)
	
	## Load the key key:
	keykey <- read_excel(system.file("extdata", "keykey.xlsx", package = "tidyepi"), 1)
	keykey$Min <- as.numeric(keykey$Min)
	keykey$Max <- as.numeric(keykey$Max)
	tidyepi_env$keykey <- keykey	
	#TODO: replace with lazy loaded data
}

.onAttach <- function(lib, pkg)
{
    packageStartupMessage("Welcome to the tidyepi package!  To launch the shiny interface type tidyepi()")
}

.onUnload <- function(libpath)
{
	## Remove the temporary folder:
	if(file.exists(tidyepi_env$tmpdir))
	    unlink(tidyepi_env$tmpdir, recursive=TRUE)
}

