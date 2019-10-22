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

# make_observers <- function(jobs, dest, input){
#   
#   obs <- purrr::list_along(nrow(jobs()))
#   
#   for(i in seq_len(nrow(jobs()))){
#     job <- jobs()[i, ]
#     input_id <- dplyr::pull(job, chunk_id)
#     
#     # Create an observer to watch for it.
#     ob <- observeEvent( input[[input_id]] , {
#       input[[input_id]] %>%
#         vroom::vroom_write(path = dest, delim = ",", append = TRUE, col_names = TRUE)
#       uptick <- ticker() + 1
#       ticker(uptick)
#       msg <- make_request(jobs()[uptick, ])
#       golem::invoke_js("fetch_tds_chunked", msg)
#     })
#     
#     # Add observer to group.
#     obs[[i]] <- ob
#     
#   }
#   
#   return(obs)
#   
# }

# run_job <- function(jobs, rvs){
#   
#   job <- jobs()[rvs$ticker, ]
#   msg <- make_request(job)
#   
#   golem::invoke_js("fetch_tds_chunked", msg)
# }