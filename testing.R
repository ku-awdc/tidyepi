## Shiny usage:

# Launch the shiny app for testing purposes:
shiny::runApp('inst/shinyapp/')



## Code effectively run by Shiny that must work:
tc <- new("TidyContainer", type='shiny')
tc$ReadFiles(system.file("extdata", "example_afdata.xlsx", package = "tidyepi"))
tc$ExtractMetadata(name="metadata")
tc$ExtractKey(name="key")
tc$ExtractData()
tc$ExtractCorrections(name="corrections", optional=TRUE)
checks <- tc$CheckData()
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
	path <- getwd()
	download_file <- tc$CreateOutputs(path=path, zip=TRUE, overwrite=TRUE)
}








## Simplest R usage:


# If necessary:
# devtools::install_github("ku-awdc/tidyepi")

library('tidyepi')

# Copy the example Excel file to the current working directory:
get_example("test.xlsx")

# The process of reading the Excel file and writing .rdata file:
tc <- new("TidyContainer")
tc$ReadFiles("test.xlsx")
tc$WriteProcessed("output.rdata")


ff <- c(system.file("extdata", "example_afdata.xlsx", package = "tidyepi"), system.file("extdata", "example_fruits.csv", package = "tidyepi"))

tc <- new("TidyContainer")
tc$GetRaw()
tc$ReadFiles(ff, c("afdata", "fruits"))
tc$ReadFiles(ff[2], "fruits")

(tc$ExtractMetadata())
(tc$ExtractKey())
(tc$ExtractData())

tc$WriteProcessed()

nn

tidyepi::tidyepi_env$keykey


tc$GetRaw()
newfiles

metakey


library(readxl)
keykey <- read_excel("/Users/matthewdenwood/Documents/GitHub/tidyepi/inst/extdata/keykey.xlsx", 1)

keykey$Min <- as.numeric(keykey$Min)
keykey$Max <- as.numeric(keykey$Max)
keykey
