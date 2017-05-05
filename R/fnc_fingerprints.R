
#' Fingerprint class
#'
#' Creates a \code{Fingerprint} object.
#'
#' @param .fingerprint_id fingerprint identifier (character). Default: NULL
#' @param .data fingerprint representation of molecules (data.frame). Default: NULL
#' @param .nbits number of bits (numeric). Default: NULL
#' @param .standard_base standard fingerprint numeric base: 2,...,32 (numeric). Default: NULL
#' @param .current_base current numeric base: 2,...,32 (numeric). Default: NULL
#'
#' @return A \code{Fingerprint} object.
#' @export
Fingerprint <- function(.fingerprint_id = NULL, .data = NULL, .nbits = NULL,
                        .standard_base = NULL, .current_base = NULL){
  atts <- list(
    fingerprint_id = .fingerprint_id,
    data = as.data.frame(.data),
    nbits = .nbits,
    standard_base = .standard_base,
    current_base = .current_base
  )
  class(atts) <- "Fingerprint"
  return(atts)
}

#' Download fingerprints from the database
#'
#' Download fingerprints from the database.
#'
#' @param .connection a database connection created using \code{dplyr::src_*}.
#' @param .fingerprint_id fingerprint identifier (character)
#' @param .molecule_id molecule identifiers (character vector). Default: NULL, all molecules.
#'
#' @return A \code{Fingerprint} object.
#' @export
downloadFingerprints <- function(.connection, .fingerprint_id, .molecule_id = NULL){
  fingp_tbl <- tbl(.connection, "Fingerprint") %>%
    filter(fingerprint_id == .fingerprint_id) %>%
    select(-fingerprint_id)
  #FIXME: what if molecule id doesn't have a fingerprint?
  if(!is.null(.molecule_id))
    fingp_tbl <- fingp_tbl %>% filter(molecule_id %in% .molecule_id)
  fingp_tbl <- collect(fingp_tbl, n = Inf)
  fingtyp <- tbl(.connection, "FingerprintType") %>%
    filter(fingerprint_id == .fingerprint_id) %>%
    collect()
  Fingerprint(.fingerprint_id = .fingerprint_id,
              .data = as.data.frame(fingp_tbl),
              .nbits = fingtyp$standard_nbits,
              .standard_base = fingtyp$standard_base,
              .current_base = fingtyp$recorded_base)
}

str2df <- function(.obj, ...) UseMethod("str2df", .obj)

str2df.Fingerprint <- function(.obj, ...) {
  fing_tbl <- .obj$data
  fings1 <- str_pad(.obj$data$string_value, width = 256, pad = "0")
  fings2 <- lapply(fings1, hex2bin)
  fings_mat <- as.data.frame(matrix(unlist(fings2), ncol = 1024, byrow = TRUE))
  names(fings_mat) <- paste0("b",str_pad(1:1024, width = 4, pad = "0"))
  fing_tbl <- fing_tbl %>% select(molecule_id) %>% bind_cols(fings_mat)
}
