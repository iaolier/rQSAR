rm(list=ls())
library(devtools)
load_all(pkg=".")

Bioactivities()

condp1 <- src_mysql(dbname = "metaqsardb", user = "mqsardb-user", password = "mqsardb-user-pw")
targs <- downloadTargets(.connection = condp1)
targs1 <- targs
targs1$target_id <- targs1$target_id[1:5]
bioacs <- downloadBioactivities(.connection = condp1, .targets = targs1)
bioacs <- downloadBioactivities(.connection = condp1, .nmols_min = 50, .nmols_max = 80)
