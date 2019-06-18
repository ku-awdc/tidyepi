tidyepi_env <- new.env()
tidyepi_env$shinyserver <- FALSE

get_instructions_text <- function(){
	return(paste(readLines(system.file('instructions.html', package='tidyepi')), sep='\n'))
}

get_footer_text <- function(){
	pubdate <- packageDate('tidyepi')
	version <- packageVersion('tidyepi')
	return(paste0('<p align="left">tidyepi version ', version, ' (', pubdate, '): &nbsp <a href="http://www.fecrt.com/BNB/", target="_blank">Click here for more information (opens in a new window)</a></p>'))
}

# Hidden function called with ::: before deploying to shiny server:
set_shinyserver <- function(status=TRUE){
	tidyepi_env$shinyserver <- status
}

# preload will give a list of previously checked dictionaries
get_shiny <- function(eval=TRUE){
	if(eval){
		return(list(ui=eval(shiny_ui), server=eval(shiny_server)))
	}else{
		return(list(ui=shiny_ui, server=shiny_server))
	}
}