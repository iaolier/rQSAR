rm(list=ls())
library(devtools)
load_all(pkg=".")

Fingerprint()

condp1 <- src_mysql(dbname = "metaqsardb", user = "mqsardb-user", password = "mqsardb-user-pw")
targs <- downloadTargets(.connection = condp1)
targs$target_id <- targs$target_id[1:2]
bioacs <- downloadBioactivities(.connection = condp1, .targets = targs)
molid <- bioacs$data$molecule_id
molid <- molid[!duplicated(molid)]
fingps <- downloadFingerprints(.connection = condp1, .fingerprint_id = "FCFP4_1024", .molecule_id = molid)
fingpsdf <- str2df(fingps)
