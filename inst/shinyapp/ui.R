library('shiny')
library('shinythemes')
library('rhandsontable')

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
			# Include a conditional panel here to include previously (and pre) loaded files
			hr(),
			h4("Upload data file(s)", style="text-align:left; "),
			hr(),
			htmlOutput('upload_text', style="text-align:left; ", width="100%"),
		    #fileInput("data_files", "Data file:", accept=c(".xlsx", ".xls", ".csv"), multiple=TRUE),
			uiOutput('file_upload'),
			htmlOutput("upload_fb", style="text-align:left; ", width="100%"),
			hr(),
			actionButton("upload_more", "Upload More File(s)"),
			actionButton("reset_files", "Reset Uploaded File(s)")		
		),
		tabPanel("Process",
			# Conditional panel here for pre-loaded (and previously checked) dictionaries
			hr(),
			h4("Upload dictionary and data file(s)", style="text-align:left; "),
			hr(),
			actionButton("process", "Process Uploaded File(s)"),
			htmlOutput("process_fb", style="text-align:left; ", width="100%")
		),
		tabPanel("Results", 
			hr(),
			h4("Select Test Parameters", style="text-align:center; "),			
			hr()
		),
		tabPanel("Output", 
			hr(),
			h4("Select Test Parameters", style="text-align:center; "),			
			hr()
		)
	),

	hr(),
	htmlOutput('footer_text'),
	hr()
)
