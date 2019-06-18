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
		tabPanel("Dictionary",
			# Conditional panel here for pre-loaded (and previously checked) dictionaries
			hr(),
			h4("Enter or upload your data dictionary", style="text-align:left; "),
			hr(),
			htmlOutput('ditext', style="text-align:left; ", width="100%"),
			selectInput("dictionarytype", "Select entry format for data dictionary:", c("Upload", "Copy/Paste"), selected="Upload", width='100%'),
			hr(),
			conditionalPanel(
				condition = "input.dictionarytype == 'Upload'",
				hr(),
				h4("Upload", style="text-align:center; "),			
				hr()
			),
			conditionalPanel(
				condition = "input.dictionarytype == 'Copy/Paste'",
				rHandsontableOutput("dictionary")
			)
		),
		tabPanel("Results", 
			hr(),
			h4("Select Test Parameters", style="text-align:center; "),			
			hr(),
	        sliderInput('target', 'Target efficay (%)', min=0, max=100, value=95, step=0.5, width='100%'),
	        sliderInput('nim', 'Non-inferiority margin (% points)', min=0, max=25, value=5, step=0.5, width='100%'),
			numericInput('pthresh', 'Threshold for significance (p)', min=0, max=0.1, value=0.025, step=0.025, width='100%'),
			hr(),
			actionButton("calculate", "Click to Calculate", width="100%"),
			htmlOutput("dataerrors", style="text-align:center; color:red; ", width="100%"),
			conditionalPanel(
				condition = "output.showresults == 1",
				hr(),
				h4("Results", style="text-align:center; "),			
				hr(),
				htmlOutput('summaries', width="100%")
			)
		)
	),

	hr(),
	htmlOutput('footer'),
	hr()
)
