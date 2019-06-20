## Simplest usage:

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

retrieve_ds("metadata", NULL, tc$rawdata)
retrieve_ds("cock", NULL, tc$rawdata)
retrieve_ds("fruits", NULL, tc$rawdata)
retrieve_ds("", c("afdata","metadata"), tc$rawdata)
retrieve_ds("", c("afdata","cock"), tc$rawdata)

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
