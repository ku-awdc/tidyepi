#' @title Central reference class for TidyContainer (don't export??)
#' @name TidyContainer

#' @description
#' TODO

#' @details
#' TODO

#' @return
#' An object of class TidyContainer.

#' @examples
#' \dontrun{
#' vignette('TidyContainer', package='tidyepi')
#' }

#' @param filepaths the file paths to read from

#' @importFrom methods new
#' @importFrom parallel mclapply
#' @importFrom readxl read_excel
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#' @import tidyverse

#' @export TidyContainer
TidyContainer <- setRefClass('TidyContainer',
	fields = list(rawdata='list', metadata='data.frame', key='data.frame', processed='list', stage='numeric', name='character', tempdir='character'),

	methods = list(

	initialize = function(){
		"Set up a TidyContainer object before importing files"

		.self$rawdata <- list()

		zeros <- rep(0, length(tidyepi_env$mtdtreqcols))
		names(zeros) <- tidyepi_env$mtdtreqcols
		.self$metadata <- as.data.frame(lapply(zeros, character))

		zeros <- rep(0, length(tidyepi_env$keyreqcols))
		names(zeros) <- tidyepi_env$keyreqcols
		.self$key <- as.data.frame(lapply(zeros, character))

		.self$processed <- list()

		.self$stage <- 0
	},

	Reset = function(){
		"Reset the TidyContainer object (clear all data)"

		.self$initialize()

	},

	ReadFiles = function(filepaths, names=filepaths){
		"Read one or more Excel or CSV files and store them in the TidyContainer"

		newfiles <- readfiles(filepaths, names)
		if(length(newfiles)==length(filepaths)){
			cat("Succesfully read ", length(newfiles), " files\n", sep="")
		}else{
			cat("Only ", length(newfiles), " of the ", length(filepaths), " specified files could be read\n", sep="")
		}

		# It is OK for the same filename and/or sheetname to be re-used in the raw data:
		.self$rawdata <- c(.self$rawdata, newfiles)
		.self$stage <- 0

		invisible(names(newfiles))
	},

	ReadDataFrame = function(dataframe, name){
		"Read a data frame already existing in R and store it in the TidyContainer"

		stop("Not yet implemented")
		# TODO
		# Check that it inherits from data.frame and has colnames, then convert all column types to text

		.self$stage <- 0

	},

	ExtractMetadata = function(name="metadata", file=NULL){
		"Identify and extract meta-data from the internally stored list of files"

		# First check that at least one data frame has been uploaded:
		if(length(.self$rawdata)==0){
			stop("You must read one or more files in before attempting to extract")
		}

		# Set up a fake metadata key;
		metakey <- tribble(~"Variable", ~"Type", ~"Min", ~"Max", ~"Categories", ~"MissingOK", ~"Description",
							 "Metadata", "Text", as.numeric(NA), as.numeric(NA), as.character(NA), "No", "Metadata type",
							 "Text", "Text", as.numeric(NA), as.numeric(NA), as.character(NA), "Yes", "Metadata entry")

		# Find the metadata in the datasets:
		raw <- retrieve_ds(name=name, file=file, rawdata=.self$rawdata)

		# Verify the metadata:
		prcsd <- process_df(raw, metakey, logfile="", cellref=TRUE)

		# Some special checks that at least Name is given in the metadata
		# TODO
		.self$name <- prcsd %>% filter(.data$Metadata=='Name') %>% pull(.data$Text)


		# Save and return invisibly:
		.self$metadata <- prcsd
		.self$stage <- 1
		invisible(prcsd)
	},

	ExtractKey = function(name="key", file=NULL){
		"Identify and extract the data key from the internally stored list of files"

		if(.self$stage < 1){
			.self$ExtractMetadata()
		}

		# Find the key in the datasets:
		raw <- retrieve_ds(name=name, file=file, rawdata=.self$rawdata)

		# Verify the key:
		prcsd <- process_key(raw, logfile="", cellref=TRUE)

		# Save and return invisibly:
		.self$key <- prcsd
		.self$stage <- 2
		invisible(key)
	},

	ExtractData = function(interactive=FALSE){
		"Identify and extract the datasets from the internally stored list of files"

		if(.self$stage < 2){
			.self$ExtractKey()
		}
		
		if(interactive) stop("Interactive mode not yet supported")
		
		# Find the unique datasets being used:
		datasetnames <- unique(.self$key$Dataset)

		# Process each one in turn:
		prcsd <- vector('list', length(datasetnames))
		names(prcsd) <- datasetnames
		for(dsn in datasetnames){
			# Restrict the key:
			dkey <- .self$key %>% filter(.data$Dataset == dsn) %>% select(-.data$Dataset)
			# Find the dataset:
			raw <- retrieve_ds(name=dsn, file=NULL, rawdata=.self$rawdata)
			# Process the dataset:
			prcsd[[dsn]] <- process_df(raw, dkey, logfile="", cellref=TRUE)
		}

		# Save and return invisibly:
		.self$processed <- prcsd
		.self$stage <- 3
		invisible(prcsd)
	},

	WriteProcessed = function(filename=NULL, overwrite=FALSE){
		"Write the processed data to an .rdata file"

		if(.self$stage < 2){
			.self$ExtractData()
		}
		
		if(is.null(filename)){
			filename <- paste0(.self$name, '.rdata')
		}

		if(file.exists(filename) && !overwrite){
			stop("Will not overwrite existing file when overwrite=FALSE")
		}
		
		ee <- list()
		ee$metadata <- .self$metadata
		ee$key <- .self$key
		for(nn in names(.self$processed)){
			ee[[nn]] <- .self$processed[[nn]]
		}
		ee$tidyEpi_version <- getpackagesaveinfo()

		save(list=names(ee), file=filename, envir=as.environment(ee))
	},
	
	GetRaw = function(){
		return(.self$rawdata)
	}


))
