# R + AppVeyor [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/ku-awdc/tidyepi?branch=master&svg=true)](https://ci.appveyor.com/project/ku-awdc/tidyepi)


# tidyepi
Automated tools for clean and tidy epidemiological datasets

This R package is currently under active development at the Section for Animal Welfare and Disease Control, University of Copenhagen

To get started run the following code in R:

	# If the devtools package is not already installed:
	install.packages('devtools')
	# Install the package from github:
	devtools::install_github('ku-awdc/tidyepi')
	# Load and launch the shiny server UI:
	library('tidyepi')
	tidyepi()
	
Alternatively you can try out the interface provided at our [shiny webserver]()


# Data format

The tidyepi package works on the premise that the data to be checked and formatted complies exactly with the specified format.  This format is intentionally restrictive but is envisaged to encompass the majority of applications within epidemiology.  At a minimum the data must consist of three separate sets of information (typically provided as separate sheets within an Excel file).  These are detailed below.

## Metadata

A sheet named 'metadata' must be provided, containing exactly two columns with names 'Metadata' and 'Text'.  A row with first column 'Name' and second column a short name/label for the dataset is mandatory. It is strongly suggested to also include Version, Contact, and a short Description of the complete dataset.  Other information may also be included as relevant.  For an example see below:

```{r}
readxl::read_excel(system.file("extdata", "example_afdata.xlsx", package = "tidyepi"), 'metadata')
```

## Key

A sheet named 'key' must be provided ... TODO

```{r}
readxl::read_excel(system.file("extdata", "example_afdata.xlsx", package = "tidyepi"), 'key')
```


## Data

Other sheets give the actual data - this can be a single sheet or multiple sheets for multiple relational data frames.  Any sheet not named as a Dataset in the key is ignored. TODO add long vs wide discussion etc.


## Corrections

Optional.  Gives Dataset, UniqueID, Variable, From, To, Notes
Dates must be characters
Datset/UniqueID/Variable must be unique combinations

This allows a transparent way of recoding or removing data entry mistakes whilst retaining the original data intact.


# R package use

If you already use R (or want to learn to use R) then you might as well start using the tidyepi package within R, as this gives you more options and help for generating your own R code.

## Use with a single Excel file

The easiest method of using the tidyepi package is to place the metadata, key and all dataset sheets inside the same Excel file. You can then run the complete tidyepi process using one R command:

TODO

This does the following initial step:

* Reads the Excel file and stores all of the sheets internally within R
* Extracts the metadata sheet and checks that the Name entry is given and valid
* Extracts the key sheet and checks that all required entries are given and valid

If any issues are detected during this step, an (informative) error is given and the function aborts.  If this happens to you, check to see what the error is and correct the problem in the metadata or key sheet accordingly, and then re-run the function.

Assuming that the first step is successful, the tidyepi function then goes to the second step, which is to check each of the data sheets specified as a Dataset within the key. This makes sure that all required variables are given, and that each of the values complies with the restrictions (e.g. variable type, min/max values, valid categories etc) specified in the key file. Any issues identified (variables missing, data entries that do not correspond to the specifications in the key) are noted in a text file. By default, a Corrections CSV file is also generated corresponding to the individual errors found in each dataset - this can then be filled in by the user.  Once the issues identified by the second step have been rectified by the user the code can be re-run (this process may be iterative until all issues are resolved).

If the first and second steps pass without errors, then tidyepi moves on to the third and final step, which is to generate the cleaned/formatted data as well as R code needed to import, correct and subsequently check the data from the original sources.  Some example code for graphs etc is also provided.  When the function completes successfully a new folder is created in the working directory containing the following:

* A copy of the Excel file containing the original metadata, key, dataset(s), and any corrections
* An R code file that reads the data, applies the corrections as needed, checks and formats the data, and then produces a .Rdata file containing the dataset(s) in the correct format
* An R code file containing some example analyses / graphs to help get you started
* A PDF containing an overview/summary of your data (and a .Rmd file used to generate this overview)


## Use with multiple data sources

The tidyepi package also allows flexibility in the provision of data sources in different formats, or from multiple files, for example having a separate file for metadata, key, and datasets, and/or providing data as a CSV file or an existing data frame or tibble in R.  Using these options requires direct access to the underlying methods, which is provided by a core S4 object.  This also allows flexibility to produce slightly different outputs.

TODO



# Shiny application use

TODO
