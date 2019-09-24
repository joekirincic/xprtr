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
  
  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = ns("n"), label = "Total Rows", value = 793),
      actionButton(inputId = ns("redify"), "Woah!")
    ),
    mainPanel(
      verbatimTextOutput(ns("table1"))
    )
  )
  
}
    
# Module Server
    
#' @rdname mod_read_tds
#' @export
#' @keywords internal
    
mod_read_tds_server <- function(input, output, session){
  ns <- session$ns
  
  tf <- tempfile(fileext = ".csv")
  file.create(tf)
  
  tds <- reactiveFileReader(1000, session, tf, vroom::vroom, delim = ",", col_names = FALSE)
  
  rvs <- reactiveValues(observers = list())
  
  # tds <- reactive({
  #   
  #   # For now, display whatever's not null.
  #   
  #   if(nrow()){
  #     data_ <- xprtr::super_store
  #   }
  #   else{
  #     data_ <- input$payload
  #   }
  #   
  #   return(data_)
  #   
  # })
  
  output$table1 <- renderPrint({
    
    validate(need(tds(), "No data yet."))
    
    head(tds())
    
  })
  
  # output$table2 <- renderPrint({
  #   
  #   validate(need(input$payload, "No `payload` yet."))
  #   
  #   head(tds())
  #   
  # })
  
  observeEvent( input$redify , {
    
    extract_datasource()
    
  })
  
  return(tds)
  
}
    
## To be copied in the UI
# mod_read_tds_ui("read_tds_ui_1")
    
## To be copied in the server
# callModule(mod_read_tds_server, "read_tds_ui_1")
 
