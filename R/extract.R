f <- function(field, n, chunk_size = 100){
  seq(1, n, chunk_size) %>%
    purrr::map_dfr(
      .x = .,
      .f = function(x){
        tibble::tibble(
          start = x,
          stop = x + (chunk_size - 1)
        ) %>%
          dplyr::mutate(
            field = field,
            start = dplyr::if_else(start > n, n, start),
            stop = dplyr::if_else(stop > n, n, stop)
          ) %>%
          return(.)
      }
    ) %>%
    mutate(
      idx = row_number(),
      chunk_id = glue::glue("payload_{i}", i = stringi::stri_rand_strings(nrow(.), 9)),
      chunk_id_verbose = paste0("read_tds_ui_1-", chunk_id)
    ) %>%
    return(.)
}

make_request <- function(x){
  
  m <- x %>% 
    transmute(chunk_id_verbose = chunk_id_verbose, filter_field = field, filter_values = list(as.integer(seq(start, stop, 1)))) %>%
    with({
      list(chunk_id_verbose = chunk_id_verbose, filter_field = filter_field, filter_values = flatten_chr(filter_values))
    }) %>%
    jsonlite::toJSON()
  
  m
  
}

extract_datasource <- function(){
  
  chunks <- f(field = "AGG(ID)", n = input$n)
  
  rvs$observers <- lapply(
    nrow(chunks),
    function(row){
      id <- pull(chunks, chunk_id)[row]
      observe(input[[ns(id)]], {
        vroom_write(input[[ns(id)]], path = tf, delim = ",", append = TRUE)
      })
    }
  )
  
  walk(
    .x = pull(chunks, chunk_id_verbose),
    .f = function(x){
      golem::invoke_js("read_tds_chunked", x)
    }
  )
  
}