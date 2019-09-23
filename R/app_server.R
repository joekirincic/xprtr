#' @import shiny
app_server <- function(input, output,session) {
  
  # List the first level callModules here
  
  shinyjs::runcodeServer()
  
  observeEvent(input$browser, {
    browser()
  })
  
  # Extracts Tableau datasource
  tds <- callModule(mod_read_tds_server, "read_tds_ui_1")
  
}
