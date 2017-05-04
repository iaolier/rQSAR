
#' Bioactivities class
#'
#' Creates a \code{Bioactivities} object.
#'
#' @param .target_id target identifiers (character vector). Default: NULL
#' @param .standard_type standard type identifier (character). Default: NULL
#' @param .data bioactivities data (data.frame). Default: NULL
#'
#' @return A \code{Bioactivities} object.
#' @export
Bioactivities <- function(.target_id =  NULL, .standard_type = NULL, .data = NULL){
  atts <- list(
    target_id = .target_id,
    standard_type = .standard_type,
    data = .data
  )
  class(atts) <- "Bioactivities"
  return(atts)
}


#' Downloads bioactivities from database
#'
#' Downloads bioactivities from database.
#'
#' @param .connection a database connection created using \code{dplyr::src_*}.
#' @param .targets a \code{Targets} object. Default: NULL.
#' @param .standard_type standard type identifier (character). Default: NULL.
#' @param .nmols_min min number of molecules per target (numeric). Default: NULL.
#' @param .nmols_max max number of molecules per target (numeric). Default: NULL.
#'
#' @return A \code{Bioactivities} object.
#' @export
downloadBioactivities <- function(.connection, .targets = NULL, .standard_type = NULL,
                                  .nmols_min = NULL, .nmols_max = NULL){
  #check .targets is Targets class
  bioac_tbl <- tbl(condp1, "Bioactivity")
  if(!is.null(.targets))
    bioac_tbl <- filter(bioac_tbl, target_id %in% .targets$target_id)
  if(!is.null(.standard_type))
    bioac_tbl <- filter(bioac_tbl, standard_type == .standard_type)
  bioac_tbl <- collect(bioac_tbl, n = Inf)
  bioac_tbl <- group_by(bioac_tbl, target_id)
  if(!is.null(.nmols_min))
    bioac_tbl <- bioac_tbl %>% filter(n()>=.nmols_min)
  if(!is.null(.nmols_max))
    bioac_tbl <- bioac_tbl %>% filter(n()<=.nmols_max)
  bioac_tbl <- bioac_tbl %>% ungroup()
  return(Bioactivities(.target_id = bioac_tbl$target_id[!duplicated(bioac_tbl$target_id)],
                       .standard_type = .standard_type,
                       .data = as.data.frame(bioac_tbl)))
}
