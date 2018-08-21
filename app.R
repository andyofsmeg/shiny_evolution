#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Modelling App - DEMO"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        h4("Main Inputs"),
        selectInput("data_set",
                     "Dataset:",
                     choices = c("Airquality"="airquality", "Cars"="mtcars")),
        uiOutput("response"),
        uiOutput("explanatory"),
        h4("Graphical Parameters"),
        textInput("plot_title",
                  "Title"),
        checkboxInput("best_fit",
                      "Add line of best fit?",
                      value=FALSE)
      ),
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         downloadButton('downloadPlot', 'Save Plot')
      )
   )
)

library(ggplot2)
theme_set(theme_bw(base_size = 14))
# Define server logic required to draw a histogram
server <- function(input, output) {
   
  # Simple reactive inputs
  var_options = reactive(names(get(input$data_set)))
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
    base_plot <- ggplot(get(input$data_set), 
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
    print(the_plot())
  })
  
  # Enable download of the plot
  output$downloadPlot <- downloadHandler(
    filename = paste0(input$data_set, '.pdf'),
    content = function(file) {
      ggsave(file,the_plot())
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

