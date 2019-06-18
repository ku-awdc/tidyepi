tidyepi <- function(...){
	
	ad <- system.file("shinyapp", package = "tidyepi")
	if(ad == ""){
		stop("Package directory not found - is the tidyepi package installed?", call. = FALSE)
	}
	  
	# Make any previously saved dictionaries available:
	dictionaries <- get_dictionaries()
	
	runApp(appDir=ad, ...)
	
}
