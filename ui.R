library(shiny)

# Application that draws a scatter plot base on simple dataset input choices

ui <- fluidPage(
   
   # Application title
   titlePanel("Modelling App - DEMO"),
   
   # Basic sidebar with a couple of dropdowns
   sidebarLayout(
      sidebarPanel(
        h4("Main Inputs"),
        # selectInput("data_set",
        #              "Dataset:",
        #              choices = c("Airquality"="airquality", "Cars"="mtcars")),
        
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
        
        # Dynamic dropdowns
        uiOutput("response"),
        uiOutput("explanatory"),
        
        h4("Graphical Parameters"),
        textInput("plot_title",
                  "Title"),
        checkboxInput("best_fit",
                      "Add line of best fit?",
                      value=FALSE)
      ),
      
      
      # Show a plot of the two variables
      mainPanel(
         plotOutput("distPlot"),
         uiOutput("downloadButton")
      )
      
   )
)
