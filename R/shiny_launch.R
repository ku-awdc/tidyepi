tidyepi <- function(...){
	
	# Make any previously saved dictionaries available:
	dictionaries <- get_dictionaries()
	
	runApp(appDir=get_shiny(eval=TRUE), ...)
	
}
