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
library(plyr)
library(ggplot2)
library(ggmap)
library(dplyr)
library(sf)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Traffic Camera Offence and Fines"),
    tabsetPanel(
    tabPanel("Exploratory Graphs", 
             h4("Create some column graphs to explore features of the data"),
            sidebarLayout(
      sidebarPanel(
selectInput("var",
            label = "Choose X Axis", 
            choices = list("State of Vehicle Registration", "Vehicle Category","Camera Type","Offence Description"), 
            selected = "Camera Type") 
),
mainPanel(
  plotOutput("plot", height = 600),
  plotOutput("plot2",height = 800)
)
)
)
)
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  df <- read_csv("Traffic_camera_offences_and_fines.csv")
  df_map <- read_csv("Traffic_Camera_Locations_-_Point_Map.csv")
  
  df_new <- df_map %>%
    janitor::clean_names() %>%
    mutate(location = str_remove(location,"\\(")) %>%
    mutate(location = str_remove(location,"\\)")) %>% 
    separate(location,into=c('lat','long'),sep=',')
  df_new$lat <- as.numeric(df_new$lat)
  df_new$long <- as.numeric(df_new$long)
  myLocation <- c(149.05,-35.45,149.25,-35.192)
  myMap <- get_map(location = myLocation, source = "osm", maptype = "watercolor", crop = FALSE)
  
  output$plot <- renderPlot({ggplot(df,aes(x = switch(input$var,"State of Vehicle Registration" = Rego_State, "Vehicle Category" = Clt_Catg, "Camera Type" = Camera_Type, "Offence Description" = Offence_Desc),
                                             y = Sum_Pen_Amt)) +
                                      geom_col() +
                                     xlab(input$var)+ 
                                      ylab("Total Penalty Amount ($)")+
      theme(axis.title = element_text(size = 16), plot.title = element_text(size=22),axis.text.y = element_text(size = 12),axis.text.x = element_text(angle = if(input$var != "Offence Description"){45} else {90}, vjust = 1, hjust=1, size = 12))+
      scale_color_brewer(palette = "Dark2")
  })
  
  output$plot2 <- renderPlot({ggmap(myMap) + geom_point(data = df_new, aes(x = long, y = lat),
                                                        alpha = .5, color="darkred", size = 3) + xlab("Longitude") + ylab("Latitude") + ggtitle("Map of traffic cams")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
