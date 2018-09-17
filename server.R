server <- function(input, output) {
  
  # ----------------------------------------------------------------------------
  # Import function Depends on file type
  source("import_handler.R", local = TRUE)
  
  # ----------------------------------------------------------------------------
  # IU Inputs
  source("ui_inputs.R", local=TRUE)
  
  # ----------------------------------------------------------------------------
  # Display
  source("display.R", local=TRUE)
 
  # ----------------------------------------------------------------------------
  # IU Export
  source("ui_export.R", local=TRUE)
  
  # ----------------------------------------------------------------------------
  # Export handling
  source("export_handler.R", local=TRUE)
  
}



