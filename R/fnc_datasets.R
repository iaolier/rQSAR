
#' QSARDatasets class
#'
#' Creates a \code{QSARDatasets} object.
#'
#' @param .targets a \code{Targets} object. Default: NULL.
#' @param .molrepresentation a \code{MolRepresentation} object. Default: NULL.
#' @param .response name of the response variable (character). Default: NULL.
#' @param .datasets named list of datasets (named list of data.frames). Default: NULL. Names should correspond to target ids.
#' @param .dataset_id dataset identifiers (numerical vector). Default: NULL.
#'
#' @return A \code{QSARDatasets} object.
#' @export
QSARDatasets <- function(.targets = NULL, .molrepresentation = NULL, .response = NULL,
                         .datasets = NULL, .dataset_id = NULL) {
  atts <- list(
    targets = .targets,
    molrepresentation = .molrepresentation,
    response = .response,
    datasets = .datasets,
    dataset_id = .dataset_id
  )
  class(atts) <- "QSARDatasets"
  return(atts)
}

#' Creates QSAR datasets
#'
#' Creates QSAR datasets.
#'
#' @param .connection a database connection created using \code{dplyr::src_*}.
#' @param .targets a \code{Targets} object.
#' @param .molrepresentation a \code{MolRepresentation} object.
#' @param .response name of the response variable (character).
#' @param .nrow_min min number of molecules per dataset (numeric). Default: NULL.
#' @param .nrow_max max number of molecules per dataset (numeric). Default: NULL.
#'
#' @return A \code{QSARDatasets} object.
#' @export
createQSARDatasets <- function(.connection, .targets, .molrepresentation, .response,
                               .nrow_min = NULL, .nrow_max = NULL){
  bioacs <- downloadBioactivities(.connection = .connection, .targets = .targets, .standard_type = .response,
                                  .nmols_min = .nrow_min, .nmols_max = .nrow_max)
  molid <- bioacs$data$molecule_id
  molid <- molid[!duplicated(molid)]

  #FIXME: below secion only works with fingerprints... still have to implement mol properties part.

  if(!is.null(.molrepresentation$fingerprint_id)) {
    fingps <- downloadFingerprints(.connection = condp1, .fingerprint_id = .molrepresentation$fingerprint_id, .molecule_id = molid)
    fingpsdf <- str2df(fingps)
  }

  # 3.4. Form full dataset
  full_data <- inner_join(bioacs$data, fingpsdf)
  full_data <- select(full_data, -c(standard_type, relation))
  full_data <- rename_(full_data, .dots = setNames("standard_value", .response))
  full_data <- dlply(full_data, .(target_id), function(tdt) select(tdt, -target_id))

  #output: QSARDatasets object
  QSARDatasets(.targets = .targets, .molrepresentation = .molrepresentation, .response = .response,
               .datasets = full_data)

}
