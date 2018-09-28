# ------------------------------------------------------------------------------
# Display tabs

# A reactive base graphic
base_plot = reactive({
  # Wait until user has chosen variables before trying to plot
  req(input$explan)
  req(input$resp)
  # Base plot with no options
  base_plot <- ggplot(data_in(), 
                      aes_string(x = input$explan, y = input$resp))+
    geom_point() 
  base_plot
})


# Another reactive graphic
the_plot <- reactive({
  # Add title if specified
  the_plot <- base_plot() + 
    ggtitle(input$plot_title) 
  # Add line of best fit if requested
  if(input$best_fit){
    the_plot <- base_plot() + 
      geom_smooth(method = "lm", se = FALSE)
  }
  the_plot
})
  
# Output of reactive graphic
output$dist_plot_main <- renderPlot({
  if(is.null(data_in())) return()
  print(the_plot())
})

# Output of reactive graphic
output$dist_plot_meta <- renderPlot({
  if(is.null(data_in())) return()
  meta_plot <- pharmaTag(the_plot(), protocol = "ABC", population = "ITT")
})

# Return the data
output$data_view <- renderDT({
  if(is.null(data_in())) return()
  datatable(data_in(), options = list(scrollX = TRUE))
})


output$display_tabs <- renderUI({
  req(input$file_in)
  tabsetPanel(type="tabs",
              tabPanel("Main", plotOutput("dist_plot_main")),
              tabPanel("Meta", plotOutput("dist_plot_meta")),
              tabPanel("Data", DTOutput("data_view"))
  )
})