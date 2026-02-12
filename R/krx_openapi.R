# KRX OPEN API docs and data endpoints
.krx_openapi_info_url <- "https://openapi.krx.co.kr/contents/OPP/INFO/service/OPPINFO004.cmd"
.krx_openapi_base_url <- "https://data-dbg.krx.co.kr"
.krx_openapi_sample_auth_url <- "https://openapi.krx.co.kr/contents/OPP/USES/service/OPPUSES002_S2.cmd?BO_ID=JvJFzlAENzZlPBDNGAWC"
.krx_openapi_sample_auth_env <- "KRX_SAMPLE_AUTH_KEY"
.krx_openapi_code_api_ids <- c(
  "stk_isu_base_info",
  "ksq_isu_base_info",
  "knx_isu_base_info"
)
.krx_openapi_trade_api_ids <- c(
  KOSPI = "stk_bydd_trd",
  KOSDAQ = "ksq_bydd_trd",
  KONEX = "knx_bydd_trd"
)

.krx_empty_field_tbl <- function() {
  tibble::tibble(
    seq = integer(),
    label = character(),
    name = character(),
    type = character(),
    size = character(),
    format = character(),
    default = character()
  )
}

.krx_text <- function(node) {
  if (length(node) == 0 || inherits(node, "xml_missing")) {
    return(NA_character_)
  }
  txt <- trimws(xml2::xml_text(node))
  if (!nzchar(txt)) {
    return(NA_character_)
  }
  txt
}

.krx_attr <- function(node, name) {
  if (length(node) == 0 || inherits(node, "xml_missing")) {
    return(NA_character_)
  }
  value <- xml2::xml_attr(node, name)
  if (is.na(value) || !nzchar(value)) {
    return(NA_character_)
  }
  value
}

.krx_to_abs_url <- function(path) {
  if (is.na(path) || !nzchar(path)) {
    return(NA_character_)
  }
  if (grepl("^https?://", path)) {
    return(path)
  }
  paste0("https://openapi.krx.co.kr", path)
}

.krx_extract_bo_id <- function(url) {
  if (is.na(url) || !nzchar(url)) {
    return(NA_character_)
  }
  match <- regmatches(url, regexec("BO_ID=([^&]+)", url, perl = TRUE))[[1]]
  if (length(match) < 2) {
    return(NA_character_)
  }
  match[2]
}

.krx_extract_bld_xml <- function(html_text) {
  match <- regmatches(
    html_text,
    regexec("var\\s+bld\\s*=\\s*'([^']*)';", html_text, perl = TRUE)
  )[[1]]
  if (length(match) < 2) {
    return("")
  }
  rawToChar(jsonlite::base64_dec(match[2]))
}

.krx_parse_bld_fields <- function(bld_xml, block_name) {
  if (!nzchar(bld_xml)) {
    return(.krx_empty_field_tbl())
  }
  bld_doc <- xml2::read_xml(bld_xml)
  xpath <- paste0(
    ".//*[local-name()='", block_name, "']",
    "/*[local-name()='block']/*[local-name()='field']"
  )
  fields <- xml2::xml_find_all(bld_doc, xpath)
  if (length(fields) == 0) {
    return(.krx_empty_field_tbl())
  }

  tibble::tibble(
    seq = seq_along(fields),
    label = vapply(fields, .krx_attr, character(1), name = "label"),
    name = vapply(fields, .krx_attr, character(1), name = "name"),
    type = vapply(fields, .krx_attr, character(1), name = "type"),
    size = vapply(fields, .krx_attr, character(1), name = "size"),
    format = vapply(fields, .krx_attr, character(1), name = "format"),
    default = trimws(vapply(fields, xml2::xml_text, character(1)))
  )
}

.krx_detail_value <- function(doc, label) {
  query <- paste0(
    "//dl[contains(@class,'col2')]",
    "/dt[normalize-space()='", label, "']/following-sibling::dd[1]"
  )
  .krx_text(xml2::xml_find_first(doc, query))
}

.krx_resolve_auth_key <- function(auth_key, sample) {
  auth_key <- as.character(auth_key)[1]
  if (is.na(auth_key) || !nzchar(auth_key)) {
    if (isTRUE(sample)) {
      return(.krx_sample_auth_key())
    }
    stop(
      "`auth_key` is required for non-sample calls. Set `KRX_AUTH_KEY` or pass `auth_key`.",
      call. = FALSE
    )
  }
  auth_key
}

.krx_sample_auth_key <- local({
  key_cache <- NULL
  function() {
    if (!is.null(key_cache) && nzchar(key_cache)) {
      return(key_cache)
    }

    env_key <- Sys.getenv(.krx_openapi_sample_auth_env, unset = "")
    if (nzchar(env_key)) {
      key_cache <<- env_key
      return(key_cache)
    }

    response <- httr::GET(.krx_openapi_sample_auth_url)
    httr::stop_for_status(response)
    doc <- xml2::read_html(httr::content(response, "text", encoding = "UTF-8"))
    sample_key <- .krx_attr(xml2::xml_find_first(doc, "//input[@name='AUTH_KEY']"), "value")
    if (is.na(sample_key) || !nzchar(sample_key)) {
      stop(
        "Could not resolve sample AUTH_KEY from KRX docs. Set `KRX_SAMPLE_AUTH_KEY` or pass `auth_key`.",
        call. = FALSE
      )
    }
    key_cache <<- sample_key
    sample_key
  }
})

.krx_openapi_get <- function(api_id,
                             query = list(),
                             auth_key = Sys.getenv("KRX_AUTH_KEY", unset = ""),
                             sample = FALSE,
                             path = "sto",
                             base_url = .krx_openapi_base_url) {
  auth_key <- .krx_resolve_auth_key(auth_key = auth_key, sample = sample)
  base_url <- sub("/+$", "", base_url)
  service_path <- if (isTRUE(sample)) "/svc/sample/apis" else "/svc/apis"
  api_url <- paste0(base_url, service_path, "/", path, "/", api_id, ".json")

  response <- httr::GET(
    url = api_url,
    query = query,
    httr::add_headers(AUTH_KEY = auth_key)
  )
  httr::stop_for_status(response)
  payload <- httr::content(response, "text", encoding = "UTF-8")
  parsed <- jsonlite::fromJSON(payload, simplifyDataFrame = TRUE)

  if (is.list(parsed) && !is.null(parsed$respCode)) {
    resp_msg <- parsed$respMsg
    if (is.null(resp_msg) || is.na(resp_msg) || !nzchar(as.character(resp_msg))) {
      resp_msg <- "unknown error"
    }
    stop(
      sprintf(
        "KRX OPEN API error (%s): %s",
        parsed$respCode,
        resp_msg
      ),
      call. = FALSE
    )
  }

  parsed
}

#' Crawl KRX OPEN API service list
#'
#' @param url KRX OPEN API service list URL.
#'
#' @return A tibble with `category`, `api_name`, `description`, `bo_id`, and `detail_url`.
#' @export
#' @importFrom xml2 read_html xml_find_all xml_find_first xml_text xml_attr
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows
krx_service_list <- function(url = "https://openapi.krx.co.kr/contents/OPP/INFO/service/OPPINFO004.cmd") {
  doc <- xml2::read_html(url)
  rows <- xml2::xml_find_all(
    doc,
    "//tbody/tr[td/a[contains(@href, '/contents/OPP/USES/service/')]]"
  )

  category <- NA_character_
  result <- vector("list", length(rows))

  for (i in seq_along(rows)) {
    cells <- xml2::xml_find_all(rows[[i]], "./td")
    if (length(cells) == 3) {
      category <- .krx_text(cells[[1]])
      api_cell <- cells[[2]]
      desc_cell <- cells[[3]]
    } else {
      api_cell <- cells[[1]]
      desc_cell <- cells[[2]]
    }

    href <- .krx_attr(xml2::xml_find_first(api_cell, ".//a"), "href")
    detail_url <- .krx_to_abs_url(href)
    result[[i]] <- tibble::tibble(
      category = category,
      api_name = .krx_text(api_cell),
      description = .krx_text(desc_cell),
      bo_id = .krx_extract_bo_id(detail_url),
      detail_url = detail_url
    )
  }

  dplyr::bind_rows(result)
}

#' Crawl KRX OPEN API service specification
#'
#' @param bo_id API identifier (`BO_ID`).
#' @param detail_url Optional detail page URL. If missing, it is resolved from `bo_id`.
#'
#' @return A list with API metadata and parsed `input`/`output` field tables.
#' @export
#' @importFrom httr GET stop_for_status content
#' @importFrom jsonlite base64_dec fromJSON
krx_service_spec <- function(bo_id, detail_url = NULL) {
  bo_id <- as.character(bo_id)[1]
  if (is.na(bo_id) || !nzchar(bo_id)) {
    stop("`bo_id` must be a non-empty string.", call. = FALSE)
  }

  if (is.null(detail_url) || is.na(detail_url) || !nzchar(detail_url)) {
    service_list <- krx_service_list()
    matched <- service_list[service_list$bo_id == bo_id, , drop = FALSE]
    if (nrow(matched) == 0) {
      stop(sprintf("Could not find BO_ID '%s' in service list.", bo_id), call. = FALSE)
    }
    detail_url <- matched$detail_url[[1]]
  }

  response <- httr::GET(detail_url)
  httr::stop_for_status(response)
  html_text <- httr::content(response, "text", encoding = "UTF-8")
  doc <- xml2::read_html(html_text)
  bld_xml <- .krx_extract_bld_xml(html_text)

  list(
    bo_id = bo_id,
    api_id = .krx_attr(xml2::xml_find_first(doc, "//input[@name='apiId']"), "value"),
    path = .krx_attr(xml2::xml_find_first(doc, "//input[@name='path']"), "value"),
    api_name = .krx_detail_value(doc, "API \uba85"),
    description = .krx_detail_value(doc, "\uc124\uba85"),
    registered_at = .krx_detail_value(doc, "\ub4f1\ub85d\uc77c"),
    updated_at = .krx_detail_value(doc, "\ucd5c\uadfc \uc218\uc815\uc77c"),
    sample_url = .krx_attr(xml2::xml_find_first(doc, "//input[@name='apiUrl']"), "value"),
    detail_url = detail_url,
    input = .krx_parse_bld_fields(bld_xml, "input"),
    output = .krx_parse_bld_fields(bld_xml, "output")
  )
}
