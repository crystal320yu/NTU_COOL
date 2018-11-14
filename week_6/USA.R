library(XML)
library(acs)
library(shiny)
library(shinythemes)
library(choroplethr)
library(choroplethrMaps)

data('df_state_demographics')
map_data <- df_state_demographics

map_data$value = map_data[, 2]

state_choropleth(df = map_data,
                 title = colnames(map_data)[2], 
                 num_colors = 7)

ui <- fluidPage(title = 'My First App!',
                theme = shinythemes::shinytheme('flatly'),
                
                sidebarLayout(
                  sidebarPanel(width = 3,
                               sliderInput("num_colors",
                                           label = "Number of colors:",
                                           min = 1,
                                           max = 9,
                                           value = 7),
                               selectInput("select", 
                                           label = "Select Demographic:", 
                                           choices = colnames(map_data)[2:9], 
                                           selected = 1)),
                  
                  mainPanel(width = 9, 
                            tabsetPanel( 
                              tabPanel(title = 'Output Map', 
                                       plotOutput(outputId = "map")),
                              tabPanel(title = 'Data Table', 
                                       dataTableOutput(outputId = 'table'))))))
server <- function(input, output) {
  
  output$map <- renderPlot({
    
    map_data$value = map_data[, input$select]
    
    state_choropleth(map_data,
                     title = input$select, 
                     num_colors = input$num_colors)
  })
  
  output$table <- renderDataTable({
    
    map_data[order(map_data[input$select]), ]
  })
}
