# ------------------------------------------------------------------------------
# Display tabs

# Some simple reactive options
explan = reactive(input$explan)
resp = reactive(input$resp)


the_plot = reactive({
  # Wait until user has chosen variables before trying to plot
  req(resp())
  req(explan())
  # Base plot with no options
  base_plot <- ggplot(data_in(), 
                      aes_string(x = explan(), y = resp()))+
    geom_point() +
    ggtitle(input$plot_title)
  
  # Add best fit line?
  if(input$best_fit){
    base_plot <- base_plot + 
      geom_smooth(method = "lm", se = FALSE)
  }
  
  base_plot
  
})

# Return the plot
output$dist_plot_main <- renderPlot({
  if(is.null(data_in())) return()
  print(the_plot())
})
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