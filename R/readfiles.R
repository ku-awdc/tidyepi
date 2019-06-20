# Internal function to read and superficially check files
readfiles <- function(paths, filenames=paths, csvfun=utils::read.csv, ...){

	stopifnot(is.character(paths))
	stopifnot(all(!is.na(paths)))
	stopifnot(is.character(filenames))
	stopifnot(all(!is.na(filenames)))
	stopifnot(length(paths)==length(filenames))

	newfiles <- list()

	for(i in seq_along(paths)){
		p <- paths[i]
		n <- filenames[i]
		if(!file.exists(p)){
			warning(paste0("File '", p, "' does not exist (file ignored)"))
		}else{
			if(grepl('\\.xlsx$', p) || grepl('\\.xls$', p)){
				ss <- try(shnms <- excel_sheets(p))
				if(inherits(ss, 'try-error')){
					warning(paste0("There was a problem reading the sheet names for file '", p, "' (file ignored)"))
				}else{
					ss <- try(newdf <- lapply(shnms, read_excel, path=p, col_types = 'text', .name_repair='minimal', ...))
					if(inherits(ss, 'try-error')){
						warning(paste0("There was a problem reading the excel sheets for file '", p, "' (file ignored)"))
					}else{
						names(newdf) <- shnms
						toadd <- list(newdf)
						names(toadd) <- n
						newfiles <- c(newfiles, toadd)
					}
				}
			}else if(grepl('\\.csv$', p) || grepl('\\.txt$', p)){
				ss <- try(csvtry <- csvfun(file=p, header=FALSE, colClasses='character', ...))
				if(inherits(ss, 'try-error')){
					warning(paste0("There was a problem reading the CSV file '", p, " using the csvfun provided' (file ignored)"))
				}else{
					if(ncol(csvtry)==1 && (all(grepl(";", csvtry[[1]], fixed=TRUE)) || all(grepl(",", csvtry[[1]], fixed=TRUE)))){
						warning(paste0("Only a single column was obtained from the CSV file '", p, "' - ensure that the csvfun is set correctly to match your locale (file ignored)"))
					}else{
						colnames <- csvtry[1,]
						csvtry <- csvtry[-1,,drop=FALSE]
						names(csvtry) <- colnames
						newdf <- list(csvtry)
						names(newdf) <- n
						toadd <- list(newdf)
						names(toadd) <- n
						newfiles <- c(newfiles, toadd)
					}
				}
			}
		}
	}

	# Note: data frames may have duplicate or blank column names (these should be exactly as in the original file)
	return(newfiles)
}


# Internal function to retrieve a dataset by unique name or location (metadata and key only):
retrieve_ds <- function(name="", file=NULL, rawdata){

	# Can be specified as the precise file and sheet:
	if(!is.null(file)){
		# Is either length 1 (file name and sheet match i.e. CSV) or 2:
		stopifnot(is.character(file))
		if(length(file)==1)
			file <- c(file, file)
		stopifnot(length(file)==2)

		if(sum(names(rawdata)==file[1]) == 0){
			stop("No matching file name found")
		}
		if(sum(names(rawdata)==file[1]) > 1){
			stop("Multiple matching file names found")
		}

		if(sum(names(rawdata[[file[1]]])==file[2]) == 0){
			stop("No matching sheet name found")
		}
		if(sum(names(rawdata[[file[1]]])==file[2]) > 1){
			stop("Multiple matching sheet names found")
		}

		return(rawdata[[file[1]]][[file[2]]]);
	}

	# Or otherwise a name to be found:
	stopifnot(is.character(name))
	stopifnot(length(name)==1)
	stopifnot(name!="")

	dfmatch <- lapply(rawdata, function(x) which(names(x) == name))
	if(length(unlist(dfmatch))==0){
		stop("No data frame found with specified name '", name, "'")
	}
	if(length(unlist(dfmatch))>1){
		stop("Several data frames found with specified name '", name, "'")
	}

	wf <- which(sapply(dfmatch, length) == 1)
	stopifnot(length(wf)==1)
	wd <- dfmatch[[wf]]
	stopifnot(length(wd)==1)

	return(rawdata[[wf]][[wd]])
}
