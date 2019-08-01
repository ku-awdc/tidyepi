# Make necessary packages available:
library('tidyepi')
library('tidyverse')
library('shiny')
library('shinythemes')
library('readxl')
library('zip')

# Some text used by the package:
instructions_text <- paste(readLines(system.file('shinytext','instructions.html', package='tidyepi')), collapse='\n')  # Retrieves installed version!
# Note: the instructions need to be updated

footer_text <- paste0('<p align="left">tidyepi version ', packageDate('tidyepi'), ' (', packageVersion('tidyepi'), '): &nbsp <a href="", target="_blank">Click here for more information (opens in a new window)</a></p>')
upload_text <- '<p>For more details on the format required for your data see <a href="", target="_blank">a page we need to create (opens in a new window)</a></p>'
# Note: webpage needs to be created!  Matt to do as part of section website on GitHub

server <- function(input, output, session) {
	
	rv <- reactiveValues(download_file="", output_text="No file uploaded yet")
		
	observeEvent(input$process, {
		
		# Default return values:
		download_file <- ""
		output_text <- ""
		
		# Create a new S4 object:
		tc <- new("TidyContainer", type='shiny')
		
		# This could return an error if the file is not .xlsx/.xlx:
		tc$ReadFiles(input$file_name)
		
		# This could return an error if the metadata sheet is missing or wrong:
		tc$ExtractMetadata(name="metadata")
		
		# This could return an error if the key sheet is missing or wrong:
		tc$ExtractKey(name="key")
		
		# This could return an error if one or more data sheet or variable is missing:
		tc$ExtractData()
		
		# This could return an error if there is an issue in the corrections file:
		tc$ExtractCorrections(name="corrections", optional=TRUE)
		
		# This will return a list (it should not throw an error):
		checks <- tc$CheckData()
		
		# If there are errors in data checking then get them as a text and CSV file:
		if(checks$any_error){
			error_text <- paste(checks$error_text, collapse='\n')
			# This error_text should be given to the user somehow:
			
			# If a corrections CSV file is produced allow the user to download it:
			if(checks$any_corrections){
				download_file <- 'corrections.csv'
				write.csv(check$corrections_df, file=download_file, row.names=FALSE)				
			}
		}else{
			# If there are no errors generate the outputs as a zip file in a location we provide:
			path <- tempdir()
			download_file <- tc$CreateOutputs(path=path, zip=TRUE, overwrite=TRUE)						
		}
		
		# Stuff that we need to pass back to the UI:
		rv$download_file <- download_file
		rv$output_text <- error_text

	})
	
	fluidPage(
		output$output_text <- renderText(rv$output_text)
	)
	
	# Fixed text strings:
    output$footer_text <- renderText(footer_text)
	output$upload_text <- renderText(upload_text)
	output$instructions_text <- renderText(instructions_text)

}
