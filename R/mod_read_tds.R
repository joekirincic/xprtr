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
      fluidRow(
        column(width = 6, actionButton(inputId = ns("redify"), "Run Report")),
        column(width = 6, downloadButton(outputId = ns("download_data"), label = "Download"))
      )
    ),
    mainPanel(
      verbatimTextOutput(ns("success")),
      verbatimTextOutput(ns("tfile")),
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
  
  tds <- reactiveFileReader(1000, session, tf, vroom::vroom, delim = ",", col_names = TRUE)
  
  rvs <- reactiveValues(incrementer = 0)
  
  output$tfile <- renderPrint({
    tf
  })
  
  output$table1 <- renderPrint({
    
    validate(need(tds(), "No data yet."))
    
    head(tds())
    
  })
  
  observeEvent( input$redify , {
    
    rvs$observers <- extract_datasource(n = input$n, dest = tf, input = input)
    
  })
  
  output$download_data <- downloadHandler(
    filename <- function() {
      paste0("report_", stringi::stri_rand_strings(n = 1, length = 13), ".csv")
    },
    
    content <- function(file) {
      file.copy(tf, file)
    },
    contentType = "text/csv"
  )
  
  output$success <- renderPrint({
    cat(
      paste0("input_n: ", input$n),
      paste0("nrow(tds()): ", nrow(tds())),
      paste0("success: ", dplyr::near(input$n, nrow(tds())))
    )
  })
  
  observe({
    shinyjs::toggleState(id = "download_data", condition = nrow(tds()) == input$n)
  })
  
  return(tds)
  
}

    
## To be copied in the UI
# mod_read_tds_ui("read_tds_ui_1")
    
## To be copied in the server
# callModule(mod_read_tds_server, "read_tds_ui_1")
 
