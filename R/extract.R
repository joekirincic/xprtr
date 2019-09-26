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
            start = dplyr::if_else(as.integer(start) > as.integer(n), as.integer(n), as.integer(start)),
            stop = dplyr::if_else(as.integer(stop) > as.integer(n), as.integer(n), as.integer(stop))
          ) %>%
          return(.)
      }
    ) %>%
    dplyr::mutate(
      idx = dplyr::row_number(),
      chunk_id = glue::glue("payload_{i}", i = stringi::stri_rand_strings(nrow(.), 9)),
      chunk_id_verbose = paste0("read_tds_ui_1-", chunk_id)
    ) %>%
    return(.)
}

make_request <- function(x){
  
  m <- x %>% 
    dplyr::transmute(chunk_id_verbose = chunk_id_verbose, filter_field = field, filter_values = list(as.integer(seq(start, stop, 1)))) %>%
    with({
      list(chunk_id_verbose = chunk_id_verbose, filter_field = filter_field, filter_values = purrr::flatten_chr(filter_values))
    }) %>%
    jsonlite::toJSON()
  
  m
  
}

extract_datasource <- function(n, dest, input){
  
  chunks <- f(field = "AGG(ID)", n = n)
  
  obs <- purrr::list_along(nrow(chunks))
  
  for(i in seq_len(nrow(chunks))){
    chunk <- chunks[i, ]
    input_id <- dplyr::pull(chunk, chunk_id)
    
    # Form message to send Tableau.
    msg <- make_request(chunk)
    # Create an observer to watch for it.
    if(i == 1){
      ob <- observeEvent( input[[input_id]] , {
        input[[input_id]] %>%
          vroom::vroom_write(path = dest, delim = ",", append = TRUE, col_names = TRUE)
      })
    }
    else{
      ob <- observeEvent( input[[input_id]] , {
        input[[input_id]] %>%
          vroom::vroom_write(path = dest, delim = ",", append = TRUE)
      }) 
    }
    # Add observer to group.
    obs[[i]] <- ob
    # Send message to Tableau.
    golem::invoke_js("fetch_tds_chunked", msg)
  }
  
  return(obs)
  
}