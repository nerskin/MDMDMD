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
    titlePanel("Traffic Camera Offence and Fines"),

    # Sidebar with a slider input for number of bins 
selectInput("var",label = "Option 1", choices = list("State of Vehicle Registration", "Vehicle Category","Camera Type"))
)

mainPanel(
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  df <- read_csv("Traffic_camera_offences_and_fines.csv")

  output$plot <- renderPlot({Switch(input$var, 
                                    "" = ggplot(df,aes())+ 
                                      geom_col
                                    
                                    
                                    )})
  plot <- ggplot(df,aes(x = Clt_Catg, y = Sum_Pen_Amt)) + 
    geom_col()
  
  plot
}

# Run the application 
shinyApp(ui = ui, server = server)
