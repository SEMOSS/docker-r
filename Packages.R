# Helper method to check whether a package has been installed
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

# Install script
register.install <- function(packages) {

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
				install.packages(package, dependencies=TRUE)
				
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

# First get the tricky ones out of the way
success <- c()
fail <- c()

# BH (needed for RcppParallel)
package <- "BH"
install.packages(package, dependencies=TRUE)
if (is.installed(package)) {
	success <- c(success, package)
} else {
	fail <- c(fail, package)
}

# RcppParallel (needed for text2vec)
package <- "RcppParallel"
install.packages(package, type = "source", repos="https://RcppCore.github.io/drat", dependencies=TRUE)
if (is.installed(package)) {
	success <- c(success, package)
} else {
	fail <- c(fail, package)
}

# ggplot2 (needed for AnomalyDetection)
package <- "ggplot2"
install.packages(package, dependencies=TRUE)
if (is.installed(package)) {
	success <- c(success, package)
} else {
	fail <- c(fail, package)
}

# lubridate (needed for AnomalyDetection)
package <- "lubridate"
install.packages(package, dependencies=TRUE)
if (is.installed(package)) {
	success <- c(success, package)
} else {
	fail <- c(fail, package)
}

# AnomalyDetection (no CRAN version, need to install from zip)
install.packages("~/AnomalyDetectionV1.0.0.tar.gz", type="source", dependencies=TRUE)
package <- "AnomalyDetection"
if (is.installed(package)) {
	success <- c(success, package)
} else {
	fail <- c(fail, package)
}

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
ret <- register.install(packages)
success <- c(success, ret$success)
fail <- c(fail, ret$fail)

# Write the status
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