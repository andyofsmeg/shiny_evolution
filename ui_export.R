# ------------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Default output name depends on input dataset
outfile = reactive({
  outname <- str_split(input$file_in$name, "\\.")[[1]][1]
  paste0(outname, '.zip')}
)

# UI for Export
output$export_zone <- renderUI({
  # Only appears once input data are selected
  req(input$file_in)
  tagList(
    h4("Export Options"),
    
    checkboxInput("out2pdf",
                  "PDF?",
                  value=TRUE),
    
    checkboxInput("out2png",
                  "PNG?",
                  value=FALSE),
    
    checkboxInput("output_code",
                  "Code?",
                  value=FALSE),
    
    checkboxInput("tagged",
                  "Add metadata to PDF?",
                  value=FALSE)
  )
})

# Download button 
output$downloadButton <- renderUI({
  # Only appears once input data are selected
  req(input$file_in)
  downloadButton('downloadPlot', 'Export')
}) 