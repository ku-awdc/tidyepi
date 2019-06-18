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
			htmlOutput('instructionstext', style="text-align:left; ", width="100%"),
			hr()
		),
		tabPanel("Upload",
			# Conditional panel here for pre-loaded (and previously checked) dictionaries
			hr(),
			h4("Upload dictionary and data file(s)", style="text-align:left; "),
			hr(),
			htmlOutput('ditext', style="text-align:left; ", width="100%"),
		    fileInput("in_file", "Input file:", accept=c("txt/csv", "text/comma-separated-values,text/plain", ".csv")),
			actionButton("upload_data", "Upload File(s)")
		),
		tabPanel("Process",
			# Conditional panel here for pre-loaded (and previously checked) dictionaries
			hr(),
			h4("Upload dictionary and data file(s)", style="text-align:left; "),
			hr()
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
	htmlOutput('footer'),
	hr()
)
