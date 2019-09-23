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
      textInput(inputId = ns("filter_field"), label = "Field"),
      textInput(inputId = ns("filter_values"), label = "Field Values"),
      actionButton(inputId = ns("redify"), "Woah!")
    ),
    mainPanel(
      verbatimTextOutput(ns("table1")),
      verbatimTextOutput(ns("table2"))
    )
  )
  
}
    
# Module Server
    
#' @rdname mod_read_tds
#' @export
#' @keywords internal
    
mod_read_tds_server <- function(input, output, session){
  ns <- session$ns
  
  tds <- reactive({
    
    # For now, display whatever's not null.
    
    if(is.null(input$payload)){
      data_ <- xprtr::super_store
    }
    else{
      data_ <- input$payload
      # data_ <- input$payload %>%
      #   jsonlite:::fromJSON(simplifyDataFrame = TRUE) %>%
      #   as_tibble()
    }
    
    # data_ <- `%||%`(input$payload, xprtr::super_store)
    
    return(data_)
    
  })
  
  output$table1 <- renderPrint({
    
    validate(need(tds(), "No data yet."))
    
    head(tds())
    
  })
  
  output$table2 <- renderPrint({
    validate(need(input$payload, "No `payload` yet."))
    
    head(tds())
    
  })
  
  observeEvent( input$redify , {
    
    spec <- list(
      filter_field = input$filter_field, 
      filter_values = input$filter_values %>% stringr::str_split(",") %>% unlist() %>% as.integer()
      ) %>%
      jsonlite:::toJSON(auto_unbox = TRUE)
    
    golem::invoke_js("showMe", spec)
    
  })
  
  
  return(tds)
}
    
## To be copied in the UI
# mod_read_tds_ui("read_tds_ui_1")
    
## To be copied in the server
# callModule(mod_read_tds_server, "read_tds_ui_1")
 
