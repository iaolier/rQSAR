rm(list=ls())
library(devtools)
load_all(pkg=".")
#document()

Targets()
Targets(c("CHEMBL1234", "CHEMBL5678"))

condp1 <- src_mysql(dbname = "metaqsardb", user = "mqsardb-user", password = "mqsardb-user-pw")
targs <- downloadTargets(.connection = condp1)
