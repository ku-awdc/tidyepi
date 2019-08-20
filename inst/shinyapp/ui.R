library('shiny')
library('shinythemes')

fluidPage(

	theme = shinytheme("cerulean"),

	hr(),
	h3("tidyepi:  automated tools for clean and tidy epidemiological datasets", style="text-align:left"),
	hr(),
	
	tabsetPanel(
		tabPanel("Instructions",
			hr(),
			htmlOutput('instructions_text', style="text-align:left; ", width="100%"),
			hr()
		),
		tabPanel("Upload",
			# Maybe include a conditional panel here to include previously (and pre) loaded files and/or dictionaries??
			hr(),
			h4("Upload data file", style="text-align:left; "),
			hr(),
			htmlOutput('upload_text', style="text-align:left; ", width="100%"),
		    fileInput("data_file", "Data file:", accept=c(".xlsx", ".xls"), multiple=FALSE),
			actionButton("process", "Process")
		),
		tabPanel("Output",
			hr(),
			h4("Error messages and/or data entry mistakes shown below", style="text-align:left; "),
			hr(),
			tableOutput("values"),
			htmlOutput("output_text", style="text-align:left; ", width="100%")
		),
		tabPanel("Download", 
			hr(),
			h4("Download correction CSV or complete ZIP file when available", style="text-align:left; "),			
			hr()
			# Need to conditionally add a download button here and pass the file to be downloaded back from server
		)
	),
	hr(),
	htmlOutput('footer_text'),
	hr()
)
