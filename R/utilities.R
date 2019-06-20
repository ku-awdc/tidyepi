get_dictionaries <- function(include_default=FALSE){
	
	# Return pre-loaded dictionaries from inst and also from the tidyepi_env
	
	return(list())
}

getpackagesaveinfo <- function(){
	pd <- packageDescription('tidyepi')
	sysinfo <- sessionInfo()
	return(list(package=pd, system=sysinfo))
}

get_example_path <- function(){
	system.file("extdata", "example_afdata.xlsx", package = "tidyepi")
}

get_example <- function(filename='tidyepi_example.xlsx'){
	if(file.exists(filename))
		stop("Unable to write example: file already exists")
	invisible(file.copy(get_example_path(), filename))
}