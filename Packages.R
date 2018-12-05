# Install the package manager
if (!require("pacman")) install.packages("pacman")

# Function to recursively install all packages and their dependencies
recursively_install <- function(packages) {
	completed <- c()
	recursively_install_sub <- function(packages) {
		for (package in packages) {
			cat(">>>>>>>>>>>> Starting installation of package: ", package)
			if (!require(package, character.only=TRUE)) {
				dependencies <- pacman::p_depends(package, character.only=TRUE)
				recursively_install_sub(dependencies)
				if (!is.element(package, completed)) {
					completed <<- c(completed, package)
					pacman::p_install(package, character.only=TRUE)
				}
			}
			cat(">>>>>>>>>>>> Completed installation of package: ", package)
		}
	}
	recursively_install(packages)
}

# List of packages to install
packages <- c("arules",
			  "cellranger",
			  "cluster",
			  "codetools",
			  "compiler",
			  "curl",
			  "data.table",
			  "devtools",
			  "digest",
			  "doParallel",
			  "dplyr",
			  "FactoMineR",
			  "foreach",
			  "formatR",
			  "futile.logger",
			  "futile.options",
			  "fuzzyjoin",
			  "grid",
			  "HDoutliers",
			  "httr",
			  "igraph",
			  "iterators",
			  "jsonlite",
			  "lambda.r",
			  "lattice",
			  "lsa",
			  "lsa,",
			  "LSAfun",
			  "Matrix",
			  "memoise",
			  "mlapi",
			  "NLP",
			  "parallel",
			  "partykit",
			  "plyr",
			  "purrr",
			  "randomForest",
			  "RcppParallel",
			  "RcppProgress",
			  "RCurl",
			  "readxl",
			  "reshape2",
			  "rJava",
			  "RJDBC",
			  "Rlof",
			  "RSclient",
			  "Rserve",
			  "settings",
			  "SnowballC",
			  "splitstackshape",
			  "stats",
			  "stringdist",
			  "stringi",
			  "stringr",
			  "text2vec",
			  "textreuse",
			  "tidyr",
			  "tidyselect",
			  "tm",
			  "validate",
			  "VGAM",
			  "WikidataR",
			  "WikipediR",
			  "withr",
			  "XML",
			  "yaml")

# Install all packages and their dependencies	
recursively_install(packages)

# Install AnomalyDetection from GitHub
pacman::p_install_gh(c("twitter/AnomalyDetection"))

# Write the install status to disk 
all.packages <- c(packages, "AnomalyDetection")
write.table(data.frame(sapply(all.packages, function(x) require(x, character.only=TRUE))), 
			file = "/opt/status/R.csv", 
			quote = FALSE, 
			sep = ",", 
			row.names = TRUE, 
			col.names = FALSE)
