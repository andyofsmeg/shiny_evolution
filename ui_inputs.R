# ----------------------------------------------------------------------------
# IU Inputs
# Once user has selected the data then we know what variables there are
var_options = reactive({
  req(data_in())
  names(data_in())
})

# Response variable
output$response <- renderUI({
  selectInput("resp",
              "Response:",
              choices = var_options())
})  

# Explanatory variable
output$explanatory <- renderUI({
  selectInput("explan",
              "Explanatory variable:",
              choices = var_options()[var_options() != input$resp])
})  

# Graph parameters  
output$graph_params <- renderUI({
  req(input$file_in)
  tagList(
    h4("Graphical Parameters"),
    
    textInput("plot_title",
              "Title"),
    checkboxInput("best_fit",
                  "Add line of best fit?",
                  value=FALSE)
  )
})