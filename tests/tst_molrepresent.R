rm(list=ls())
library(devtools)
load_all(pkg=".")

MolRepresentation()

condp1 <- src_mysql(dbname = "metaqsardb", user = "mqsardb-user", password = "mqsardb-user-pw")
reprs <- downloadMolRepresentation(.connection = condp1, .representation_id = 1)
