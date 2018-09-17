# ------------------------------------------------------------------------------
# Import handling

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