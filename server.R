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
  
  # Default output name to input name, relacing extension
  outfile = reactive({
    outname <- str_split(input$file_in$name, "\\.")[[1]][1]
    paste0(outname, '.zip')}
  )

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
    downloadButton('downloadPlot', 'Export')
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

      base_plot

  })
  
  # Return the plot
  output$dist_plot_main <- renderPlot({
    if(is.null(data_in())) return()
    print(the_plot())
  })
  output$dist_plot_meta <- renderPlot({
    if(is.null(data_in())) return()
    meta_plot <- pharmaTag(the_plot(), protocol = "ABC", population = "ITT")
  })
  
  
  
  # Enable download of the plot
  output$downloadPlot <- downloadHandler(
    filename = function(){
      #paste0(input$file_in$name, 'zip')
      outfile()
    },
    content = function(file) {
      #ggsave(file,the_plot())
      #go to a temp dir to avoid permission issues
      owd <- setwd(tempdir())
      on.exit(setwd(owd))

      #write out each file
      png("out.png")
      print(the_plot())
      dev.off()
      pdf("out.pdf")
      pharmaTag(the_plot(), protocol = "ABC", population = "ITT")
      dev.off()
      
      files <- c("out.png", "out.pdf")

      #create the zip file
      zip(file,files)
    }
  )
  

}



