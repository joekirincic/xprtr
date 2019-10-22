#' @import shiny
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      h1("xprtr"),
      shinyjs::useShinyjs(),
      mod_read_tds_ui("read_tds_ui_1"),
      shinyjs::runcodeUI(),
      actionButton("browser", "browser"),
      tags$script("$('#browser').hide();")
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'xprtr')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon(),
    tags$script(src = "www/tableau_datasource_utils.js"),
    tags$script(src = "www/tableau.extensions.1.latest.js"),
    tags$script(src = "www/d3.js")
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
