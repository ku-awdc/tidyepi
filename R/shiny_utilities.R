
# Hidden function called with ::: before deploying to shiny server:
set_shinyserver <- function(status=TRUE){
	tidyepi_env$shinyserver <- status
}


process_files <- function(files){
	
	print('processing')
}