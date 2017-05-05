rm(list=ls())
library(devtools)
load_all(pkg=".")

QSARDatasets()

condp1 <- src_mysql(dbname = "metaqsardb", user = "mqsardb-user", password = "mqsardb-user-pw")
targs <- downloadTargets(.connection = condp1)
targs$target_id <- targs$target_id[1:2]
reprs <- downloadMolRepresentation(.connection = condp1, .representation_id = 1)
dsets <- createQSARDatasets(.connection = condp1, .targets = targs, .molrepresentation = reprs, .response = "pXC50")

uploadDB(dsets, .connection = condp1)


bioacs <- downloadBioactivities(.connection = condp1, .targets = targs)
molid <- bioacs$data$molecule_id
molid <- molid[!duplicated(molid)]
fingps <- downloadFingerprints(.connection = condp1, .fingerprint_id = "FCFP4_1024", .molecule_id = molid)
fingpsdf <- str2df(fingps)
