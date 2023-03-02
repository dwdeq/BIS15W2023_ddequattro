ui <- fluidPage(
  selectInput("fill", "Select Variable", choices = c("trophic.guild", "thermoregulation"), 
              selected = "trophic.guild"),
  plotOutput("plot", 
             width = "750px", 
             height = "750px")
)

server <- function(input, output, session) {
  session$onSessionEnded(stopApp)
  output$plot <- renderPlot({
    ggplot(homerange, 
           aes_string(x = "locomotion", 
                      fill = input$fill)) + 
      geom_bar() +
      scale_fill_brewer(palette = "RdPu") +
      theme_classic() +
      labs(title = "Number of Individuals by Locomotion Method",
           x = "Locomotion Method",
           y = "Number of Individuals") +
      theme(plot.title = element_text(hjust = .5))
  })
}

shinyApp(ui, server)
