



.onLoad <- function(...) {
  
  read_tds <- function(x, session, inputname){
    
    x %>% jsonlite:::fromJSON(simplifyDataFrame = TRUE) %>% 
      tibble::as_tibble(.name_repair = function(x){ janitor::make_clean_names(x, case = "snake") }) %>%
      return(.)
    
  }
  
  shiny::registerInputHandler("read_tds", read_tds, force = TRUE)

}

make_message <- function(){
  x <- list(filter_field = "AGG(ID)", filter_values = as.character(1:4))
  return(x)
}