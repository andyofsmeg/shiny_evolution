# Application that draws a scatter plot base on simple dataset input choices
ui <- fluidPage(theme = shinytheme("united"), 
  
  # Application title
  titlePanel("Plotting App - DEMO"),
  
  # Basic sidebar with a couple of dropdowns
  fluidRow(
    # --------------------------------------------------------------------------
    # Input Parameters
    column(2,
           
           h4("Main Inputs"),
           
           # Input file
           fileInput("file_in", "Dataset",
                     accept = c(
                       'text/csv',
                       'text/comma-separated-values',
                       'text/tab-separated-values',
                       'text/plain',
                       '.csv',
                       '.sas7bdat')
           ),
           
           # -------------------------------------------------------------------
           # Dynamic dropdowns (appear once user selects input data)
           # Y vs X
           uiOutput("response"),
           uiOutput("explanatory"),

           # Graphical Options
           uiOutput("graph_params")
    ),
    
    # --------------------------------------------------------------------------
    # Input Parameters
    # Display (using tabs)
    column(7,
           uiOutput("display_tabs")
    ),
    
    # --------------------------------------------------------------------------
    # Export options
    column(2,#offset=2,
           uiOutput("export_zone"),
           uiOutput("downloadButton")
    )
    )
)
