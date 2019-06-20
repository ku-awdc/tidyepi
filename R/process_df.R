# Verify a given data frame against a given key (the key is assumed to be valid)

# Exported and also called by TidyContainer on the initial key
process_key <- function(key, logfile="", cellref=TRUE){

	# Give a warning when dropping columns from the key (process() doesn't warn):
	if(!all(names(key) %in% tidyepi_env$keyreqcols)){
		warning("Ignoring one or more unnecessary columns in the key file")
	}

	# Extract and re-format the key:
	processed <- extract_df(dataset=key, key=tidyepi_env$keykey, logfile=logfile, cellref=cellref)
	# This specifies that the key must specify Dataset - this can be removed later

	# Then validating against the internal master key
	validated <- validate_df(dataset=processed, key=tidyepi_env$keykey, logfile=logfile, cellref=cellref)


	return(processed)
}

# Exported and also called by TidyContainer on each individual dataset:
process_df <- function(dataset, key, logfile="", cellref=TRUE){

	# First re-validate the key against the keykey - shouldn't be necessary to reformat as it has been done before
	key <- validate_df(dataset=key, key=tidyepi_env$keykey, logfile=logfile, cellref=cellref)

	# Then extract and re-format the data:
	processed <- extract_df(dataset=dataset, key=key, logfile=logfile, cellref=cellref)

	# Then validate the data against the key:
	validated <- validate_df(dataset=processed, key=key, logfile=logfile, cellref=cellref)

	return(validated)
}


# Underlying function - not to be exported:
extract_df <- function(dataset, key, logfile, cellref){

	## This only does extraction and re-formatting not validation

	# Grab loggers:
	log_err <- get_log('error')
	log_warn <- get_log('warning')

	# Note: key must be guaranteed to be safe as this function is also used by verifykey

	# We can ignore dataset here but make sure they are all the same if provided:
	stopifnot(tidyepi_env$keyreqcols[1]=="Dataset")
	if(!all(sapply(lapply(key[[tidyepi_env$keyreqcols[1]]], all.equal, current=key[[tidyepi_env$keyreqcols[1]]][1]), isTRUE))){
		stop("If a Dataset column is given then they should be all the same value")
	}

	vnames <- names(dataset)
	if(!all(key$Variable %in% vnames)){
		stop("One or more missing variable in dataset")
	}
	tab <- table(vnames[vnames %in% key$Variable])
	if(any(tab > 1)){
		stop("One or more duplicate variable names in dataset")
	}
	extracted <- dataset[,key$Variable]

	return(extracted)
}


# Underlying function - not to be exported:
validate_df <- function(dataset, key, logfile, cellref){

	## This only does validation not extraction and reformatting

	# Grab loggers:
	log_err <- get_log('error')
	log_warn <- get_log('warning')

	# stopifnot() check that columns are precisely as required by the key

	validated <- dataset
	# validated <- as.tibble(dataset)


	return(validated)
}


get_log <- function(type){

	stopifnot(type %in% c('error','warning'))

	# Functions to write to the logfile with minimal effort:
	logger <- function(row, col, message){
		# row and col refer to the raw dataframe row (excluding headers) and col headers
		# hard-code the column headers and unique ID names here
		# hardcode cellref to also give Excel cell reference (use excel_columns from my .Rpfofile)
		# hardcode type error vs warning

		# Always use file=logfile, append=TRUE for catting here
	}

	return(logger)
}