# Module UI
  
#' @title   mod_read_tds_ui and mod_read_tds_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_read_tds
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_read_tds_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_read_tds
#' @export
#' @keywords internal
    
mod_read_tds_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_read_tds_ui("read_tds_ui_1")
    
## To be copied in the server
# callModule(mod_read_tds_server, "read_tds_ui_1")
 
