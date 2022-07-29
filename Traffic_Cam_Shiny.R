#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(tidyverse)
library(shiny)
library(ggplot2)
library(RColorBrewer)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Traffic Camera Offence and Fines"),
    sidebarLayout(
      sidebarPanel(
selectInput("var",
            label = "Choose X Axis", 
            choices = list("State of Vehicle Registration", "Vehicle Category","Camera Type","Offence Description"), 
            selected = "Camera Type") 
),
mainPanel(
  plotOutput("plot", height = 600)
)
)
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  df <- read_csv("Traffic_camera_offences_and_fines.csv")

  output$plot <- renderPlot({ggplot(df,aes(x = switch(input$var,"State of Vehicle Registration" = Rego_State, "Vehicle Category" = Clt_Catg, "Camera Type" = Camera_Type, "Offence Description" = Offence_Desc),
                                             y = Sum_Pen_Amt)) +
                                      geom_col() +
                                     xlab(input$var)+ 
                                      ylab("Total Penalty Amount ($)")+
      theme(plot.title = element_text(size=22),axis.text.x = element_text(angle = if(input$var != "Offence Description"){45} else {90}, vjust = 1, hjust=1, size = 12))+
      scale_color_brewer(palette = "Dark2")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
