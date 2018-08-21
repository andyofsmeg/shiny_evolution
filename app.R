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
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv")
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
         downloadButton('downloadPlot', 'Save Plot')
      )
   )
)

library(ggplot2)
theme_set(theme_bw(base_size = 14))

server <- function(input, output) {
   
  
  # File selection processing
  data_in = reactive({
    req(input$file_in)
    # input$file_in will be NULL initially. After the user selects
    # and uploads a file, the data will be returned

    readr::read_csv(input$file_in$datapath)
  })
  
  # Simple reactive inputs
  var_options = reactive({
    req(input$file_in)
    names(data_in())
  })
  explan = reactive(input$explan)
  resp = reactive(input$resp)
  best_fit = reactive(input$best_fit)
  plot_title = reactive(input$plot_title)

  
  # UI
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
  

  # Main plot
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
      base_plot + 
        geom_smooth(method = "lm", se = FALSE)
    }
    else{
      base_plot
    }
  })
  
  # Show the plot
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

# Run the application 
shinyApp(ui = ui, server = server)

