# ------------------------------------------------------------------------------
# Export handling
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
    
    # Write out each file as selected by user
    if(input$out2png){
      png("out.png")
      print(the_plot())
      dev.off()
    }
    if(input$out2pdf){
      pdf("out.pdf")
      if(input$tagged){
        pharmaTag(the_plot(), protocol = "ABC", population = "ITT")
      }
      else{
        print(the_plot()) 
      }
      dev.off()
    }
    if(input$output_data){
      readr::write_csv(data_in(), "out.csv")
    }
    # TODO: Add code and plot data
    
    files <- c("out.png", "out.pdf", "out.csv")[c(input$out2png, input$out2pdf, input$output_data)]
    
    #create the zip file
    #if(!is.null(files)){
      zip(file,files)
    #}
  }
)