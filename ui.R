# Application that draws a scatter plot base on simple dataset input choices
ui <- fluidPage(
  
  # Application title
  titlePanel("Modelling App - DEMO"),
  
  # Basic sidebar with a couple of dropdowns
  fluidRow(
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
           
           # Dynamic dropdowns (appear once user selects input data
           uiOutput("response"),
           uiOutput("explanatory"),
           uiOutput("graph_params")
    ),
    
    
    # Show a plot of the two variables
    column(7,
           tabsetPanel(type="tabs",
                       tabPanel("Main", plotOutput("dist_plot_main")),
                       tabPanel("Meta", plotOutput("dist_plot_meta"))
                       #plotOutput("distPlot")
           )

           
    ),
    
    column(2,#offset=2,
           uiOutput("export_zone"),
           uiOutput("downloadButton")
    )
    )
)
