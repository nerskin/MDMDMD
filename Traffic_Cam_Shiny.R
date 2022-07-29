#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Traffic Camera Offence and Fines"),
    sidebarLayout(
      sidebarPanel(
selectInput("var",
            label = "Choose X Axis", 
            choices = list("State of Vehicle Registration", "Vehicle Category","Camera Type"), 
            selected = "Camera Type")
),
mainPanel(
  plotOutput("plot")
)
)
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  df <- read_csv("Traffic_camera_offences_and_fines.csv")

  
  output$plot <- renderPlot({ggplot(df,aes(x = switch(input$var,"State of Vehicle Registration" = Rego_State, "Vehicle Category" = Clt_Catg, "Camera Type" = Camera_Type),
                                             y = Sum_Pen_Amt)) +
                                      geom_col()
                                    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
