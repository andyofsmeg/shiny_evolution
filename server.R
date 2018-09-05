server <- function(input, output) {
   
  
  # File selection processing
  data_in = reactive({
    req(input$file_in)
    # Detect if it's a SAS file and use appropriate read function
    if(grepl(".sas7bdat$", input$file_in$name)){
      haven::read_sas(input$file_in$datapath)
    }
    else {
      readr::read_csv(input$file_in$datapath)
    }
  })
  
  
  # ----------------------------------------------------------------------------
  # Simple reactive inputs
  var_options = reactive({
    req(input$file_in)
    names(data_in())
  })
  explan = reactive(input$explan)
  resp = reactive(input$resp)
  best_fit = reactive(input$best_fit)
  plot_title = reactive(input$plot_title)
  tagged = reactive(input$tagged)

  # ----------------------------------------------------------------------------
  # UI
  
  # Response
  output$response <- renderUI({
    selectInput("resp",
                "Response:",
                choices = var_options())
  })  
  
  output$explanatory <- renderUI({
    selectInput("explan",
                "Explanatory variable:",
                choices = var_options()[var_options() != resp()])
  })  
  
  # Graph parameter UI  
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
  
  output$export_zone <- renderUI({
    req(input$file_in)
    tagList(
      h4("Export Options"),
      
 #     splitLayout(cellWidths=c(80,80,80),
        checkboxInput("out2pdf",
                      "PDF?",
                      value=TRUE),
        
        checkboxInput("out2png",
                      "PNG?",
                      value=FALSE),
        
        checkboxInput("output_code",
                      "Code?",
                      value=FALSE),
  #    ),


      checkboxInput("tagged",
                    "Add metadata to PDF?",
                    value=FALSE)
    )
  })
  
  # Tagging option and download button only appears once input data are selected
  output$downloadButton <- renderUI({
    req(input$file_in)
    downloadButton('downloadPlot', 'Save Plot')
  }) 
  
  # ----------------------------------------------------------------------------
  # Main plot definition
  the_plot = reactive({
    # Wait until user has chosen variables before trying to plot
    req(input$resp)
    req(input$explan)
    # Base plot with no options
    base_plot <- ggplot(data_in(), 
                        aes_string(x = explan(), y = resp()))+
      geom_point() +
      ggtitle(plot_title())
    if(best_fit()){
      base_plot <- base_plot + 
        geom_smooth(method = "lm", se = FALSE)
    }
    if(tagged()){
      pharmaTag(base_plot, protocol = "ABC", population = "ITT")
    }
    else {
      base_plot
    }
  })
  
  # Return the plot
  output$distPlot <- renderPlot({
    if(is.null(data_in())) return()
    print(the_plot())
  })
  
  # Enable download of the plot
  output$downloadPlot <- downloadHandler(
    filename = paste0(input$file_in$name, '.pdf'),
    content = function(file) {
      ggsave(file,the_plot())
    }
  )
  

}



