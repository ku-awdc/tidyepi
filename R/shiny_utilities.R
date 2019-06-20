get_instructions_text <- function(){
	return(paste(readLines(system.file('shinytext','instructions.html', package='tidyepi')), collapse='\n'))
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


process_files <- function(files){
	
	print('processing')
}