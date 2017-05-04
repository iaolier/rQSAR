
#' Targets class
#'
#' Creates a new \code{Targets} object
#'
#' @param .target_id target identifiers (character vector). Default: NULL
#'
#' @return A \code{Targets} object.
#' @export
Targets <- function(.target_id = NULL){
  atts <- list(
    target_id = .target_id
  )

  ## Set the name for the class
  class(atts) <- "Targets"
  return(atts)
}

#' Downloads targets from database.
#'
#' Downloads targets form database.
#'
#' @param .connection a database connection created using \code{dplyr::src_*}.
#'
#' @return A \code{Targets} object.
#' @export
downloadTargets <- function(.connection){
  targs_tbl <- tbl(.connection, "Target") %>%
    select(target_id) %>% collect(n = Inf)
  Targets(.target_id = targs_tbl$target_id)
}
