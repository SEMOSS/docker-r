

######################################################################
# Method to check whether a package is installed
######################################################################
is.installed <- function(package) {

	# Check if installed
	installed <- require(package, character.only=TRUE)
	
	# If it is installed, need to detach the package, as require loads the package
	# Otherwise creates name space conflicts when several packages are loaded at the same time
	if (installed) {
		try(detach(paste("package:", package, sep=""), character.only=TRUE, unload=TRUE))
	}
	return(installed)
}


######################################################################
# Method to install a package if it is not yet installed
######################################################################
install <- function(packages, script="install.packages(package, dependencies=TRUE)") {

	# Keep track of the progress
	success <- c()
	fail <- c()
	total <- length(packages)
	i <- 0
	
	# Install each package
	for (package in packages) {
		i <- i + 1
		installed <- FALSE
		
		# Do the install inside a try catch just in case
		tryCatch({
			
			# Check to see if already installed		
			# If not, then try to install it
			installed = is.installed(package)
			if (!installed) {
				eval(parse(text=script))
				
				# Check again after install
				installed = is.installed(package)
			}
		}, finally={
		
			# Finally register the progress
			if (installed) {
				success <- c(success, package)
			} else {
				fail <- c(fail, package)
			}
			print(paste("<<<<<<<<<<<<<<<<<<<<<<<< ", format(round(i/total * 100, 2), nsmall = 2), 
						"% complete >>>>>>>>>>>>>>>>>>>>>>>>", sep=""))
		})
	}
	return(list("success"=success, "fail"=fail))
}


######################################################################
# Install packages that require customizations
######################################################################
success <- c()
fail <- c()

# BH (needed for RcppParallel)
# ggplot2 (needed for AnomalyDetection)
# lubridate (needed for AnomalyDetection)
ret <- install(c("BH", "ggplot2", "lubridate"))
success <- c(success, ret$success)
fail <- c(fail, ret$fail)

# RcppParallel (needed for text2vec) (source install required)
ret <- install(c("RcppParallel"), script='install.packages(package, type = "source", repos="https://RcppCore.github.io/drat", dependencies=TRUE)')
success <- c(success, ret$success)
fail <- c(fail, ret$fail)

# AnomalyDetection (dev install required)
ret <- install(c("AnomalyDetection"), script='install.packages("~/AnomalyDetectionV1.0.0.tar.gz", type="source", dependencies=TRUE)')
success <- c(success, ret$success)
fail <- c(fail, ret$fail)


######################################################################
# Install all other packages
######################################################################

# Array of packages, in alphabetical order
packages <- c("arules", 
			  "cellranger", 
			  "cluster", 
			  "curl", 
			  "data.table", 
			  "devtools",
			  "digest", 
			  "dplyr", 
			  "fuzzyjoin", 
			  "HDoutliers", 
			  "httr",
			  "igraph", 
			  "jsonlite", 
			  "lattice", 
			  "lsa", 
			  "memoise", 
			  "NLP", 
			  "plyr", 
			  "purrr", 
			  "RcppProgress", 
			  "RCurl", 
			  "readxl", 
			  "reshape2", 
			  "reticulate", 
			  "rJava", 
			  "RJDBC", 
			  "RSclient", 
			  "Rserve", 
			  "splitstackshape", 
			  "stringdist", 
			  "stringr", 
			  "text2vec", 
			  "textreuse", 
			  "tidyr", 
			  "tidyselect", 
			  "WikidataR", 
			  "WikipediR", 
			  "withr", 
			  "XML")
			  
# Run the installer
ret <- install(packages)
success <- c(success, ret$success)
fail <- c(fail, ret$fail)


######################################################################
# Write the install status to disk
######################################################################
write.table(data.frame(success=ret["success"]), 
			file = "/opt/status/R/success.csv", 
			quote = FALSE, 
			sep = ",", 
			row.names = FALSE, 
			col.names = FALSE)
write.table(data.frame(fail=ret["fail"]), 
			file = "/opt/status/R/fail.csv", 
			quote = FALSE, 
			sep = ",", 
			row.names = FALSE, 
			col.names = FALSE)
