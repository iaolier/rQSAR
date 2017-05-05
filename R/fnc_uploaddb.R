
#' Uploads an rQSAR object to the database
#'
#' Generic function to upload an rQSAR object to the database.
#' @param .obj an rQSAR object
#' @param .connection a database connection created using \code{dplyr::src_*}.
#' @param ... further arguments (see specific functions for details)
#'
#' @return Usually a logical value indicating whether the uploading was succesful. See specific functions for more details.
#' @export
uploadDB <- function(.obj, .connection) UseMethod("uploadDB", .obj)

#' Uploads QSAR datasets to the database
#'
#' Uploads a \code{QSARDatasets} object to the database.
#'
#' @param .obj a \code{QSARDatasets} object.
#' @param .connection a database connection created using \code{dplyr::src_*}.
#' @param ... further arguments (currently not in use)
#'
#' @return a logical value that indicates whether the uploading was succesful.
#' @export
uploadDB.QSARDatasets <- function(.obj, .connection, ...){
  newdataset_tbl <- ldply(.obj$datasets, function(tdt){
    tc <- textConnection("ftxt", "w")
    write.csv(tdt, tc, row.names = F)
    csvd <- paste0(ftxt, collapse = "\n")
    close(tc)
    data.frame(csv_data = csvd, row.names = F, stringsAsFactors = F)
  }, .id = "target_id")
  newdataset_tbl <- newdataset_tbl %>% mutate(representation_id = .obj$molrepresentation$representation_id, standard_type = .obj$response)
  dbWriteTable(.connection$con, "QSARDataset", newdataset_tbl, append = T, row.names = F)
}
