#' MolRepresentation class
#'
#' Creates a new \code{MolRepresentation} object.
#'
#' @param .representation_id representation identifier (numerical value). Default: NULL
#' @param .fingerprint_id fingerprint identifiers (character vector). Default: NULL
#' @param .molproperty_id molecular property identifiers (character vector). Default: NULL
#'
#' @return A \code{MolRepresentation} object.
#' @export
MolRepresentation <- function(.representation_id = NULL, .fingerprint_id = NULL, .molproperty_id = NULL){
  atts <- list(
    representation_id = .representation_id,
    fingerprint_id = .fingerprint_id,
    molproperty_id = .molproperty_id
  )
  class(atts) <- "MolRepresentation"
  return(atts)
}

#' Downloads a molecular representation from the database
#'
#' Downloads a molecular representation from the database.
#'
#' @param .connection a database connection created using \code{dplyr::src_*}.
#' @param .representation_id representation identifier (numerical value). Default: NULL
#'
#' @return a \code{MolRepresentation} object.
#' @export
downloadMolRepresentation <- function(.connection, .representation_id = NULL){
  #TODO: what happens when id == null?
  rep_tbl <- tbl(.connection, "Representation") %>% filter(representation_id == .representation_id) %>%
    collect()
  if(nrow(rep_tbl)==0) {
    warning("No molecular representations matching filter criteria\n were found in the database.")
    return(NULL)
  }

  fingp_tbl <- tbl(.connection, "RepFingType") %>% filter(representation_id == .representation_id) %>%
    collect()
  fingp_id <- NULL
  if(nrow(fingp_tbl)>0)
    fingp_id <- fingp_tbl$fingerprint_id
  molp_tbl <- tbl(.connection, "RepMolPropType") %>% filter(representation_id == .representation_id) %>%
    collect()
  molp_id <- NULL
  if(nrow(molp_tbl)>0)
    molp_id <- molp_tbl$molproperty_id

  if(is.null(fingp_id) & is.null(molp_id))
    warning("There are molecular representation IDs without associated properties.")
  MolRepresentation(.representation_id = .representation_id, .fingerprint_id = fingp_id, .molproperty_id = molp_id)
}
