
#'
#' #' MolRepresentation class
#' #'
#' #' Creates a new \code{MolRepresentation} object.
#' #'
#' #' @param .representation_id representation identifier (numerical value). Default: NULL
#' #'
#' #' @return A \code{MolRepresentation} object.
#' #' @export
#' MolRepresentation <- function(.representation_id = NULL){
#'   atts <- list(
#'     representation_id = .representation_id
#'   )
#'
#'   ## Set the name for the class
#'   class(atts) <- append(class(atts),"MolRepresentation")
#'   return(atts)
#' }
#'
#' #' QSARDatasets object.
#' #'
#' #' Creates a new QSARDatasets object.
#' #'
#' #' @param .connection a database connection created using \code{dplyr::src_*}.
#' #' @param .targets a \code{Targets} class object.
#' #' @param .molrepresentation a \code{MolRepresentation} class object.
#' #' @param .response response name (character).
#' #'
#' #' @return A \code{QSARDatasets} object.
#' #' @export
#' formDatasets <- function(.connection, .targets, .molrepresentation, .response){
#'   bioac_tbl <- tbl(.connection, "Bioactivity") %>% filter(target_id %in% .targets_id, standard_type == .response) %>%
#'     select(target_id, molecule_id, standard_value) %>% collect(n = Inf)
#'
#' }
