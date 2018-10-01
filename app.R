
# Import libraries
library(shiny)
library(dplyr)
library(leaflet)
library(googlesheets)
# Import related R scripts
source('global.R')

coord <- read.csv("route_coord.csv", header = T, stringsAsFactors = F)
leg1 <- coord %>%
  slice(1:2)
ferry1 <- coord %>%
  slice(3:4)
leg2 <- coord %>%
  slice(5:26)
ferry2 <- coord %>%
  slice(27:28)
leg3 <- coord %>%
  slice(29:34)
ferry3 <- coord %>%
  slice(35:36)
leg4 <- coord %>%
  slice(37:42)
ferry4 <- coord %>%
  slice(43:44)
leg5 <- coord %>%
  slice(45:56)
flight1 <- coord %>%
  slice(57:58)
leg6 <- coord %>%
  slice(59:72)
flight2 <- coord %>%
  slice(73:74)
leg7 <- coord %>%
  slice(75:82)

ui <- fluidPage(
  div(
    style = "position: fixed;
             top: 0;
             left: 0;
             right: 0;
             bottom: 0;
             overflow: hidden;
             padding: 0;",
  
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Spectral SC|Raleway|Exo 2');
                    body {background-color: white;};
                    "))
    ),
  
  # Leaflet map
  leafletOutput("mymap", width = "100%", height = "1100"),
  
  # Add title panel
  absolutePanel(id = "title_panel", class = "panel panel-default", fixed = TRUE,
                draggable = FALSE, top = 0, left = 0, right = 0, bottom = "auto",
                width = "100%", height = 90, 
                style = "background-color: white;
                         padding: 0 0px 0px 0px;
                         opacity: 0.65;",
                
                # App title
                tags$h3("Bicycling Across the World - Photo Journal",
                        style = "font-family: 'Exo 2';
                        font-weight: 800;
                        line-height: .7;
                        color: #0B212A;
                        text-align: center; 
                        padding: 0 0 0 0"),
                # Add sub title
                tags$h5("By David LiCause", 
                        style = "font-family: 'Exo 2';
                        font-weight: 500;
                        line-height: 1;
                        color: #0B212A;
                        text-align: center")
  )
  
))

server <- function(input, output) {
  
  data <- eventReactive(input$reload, {
    url <- NA # shareable google sheets link
    as.data.frame(gs_read(ss = ss, ws = 1)) %>% 
      mutate(content = paste("<img src = ", pic_link, " width='700'>", "<br/>", " <font size='4'>", caption, "</font>"))
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet(options = leafletOptions(zoomControl = TRUE)) %>%
      addTiles() %>% 
      setView(lng = 57, lat = 27.1750 , zoom = 4) %>%
      addPolylines(data = leg1, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Red', weight=2, dashArray=5) %>%
      addPolylines(data = ferry1, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Blue', weight=2, dashArray=5) %>%
      addPolylines(data = leg2, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Red', weight=2, dashArray=5) %>%
      addPolylines(data = ferry2, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Blue', weight=2, dashArray=5) %>%
      addPolylines(data = leg3, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Red', weight=2, dashArray=5) %>%
      addPolylines(data = ferry3, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Blue', weight=2, dashArray=5) %>%
      addPolylines(data = leg4, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Red', weight=2, dashArray=5) %>%
      addPolylines(data = ferry4, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Blue', weight=2, dashArray=5) %>%
      addPolylines(data = leg5, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Red', weight=2, dashArray=5) %>%
      addPolylines(data = flight1, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Blue', weight=2, dashArray=5) %>%
      addPolylines(data = leg6, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Red', weight=2, dashArray=5) %>%
      addPolylines(data = flight2, lng = ~longitude, lat = ~latitude, group = ~leg, 
                   color = 'Blue', weight=2, dashArray=5) %>%
      addPolylines(data = leg7, lng = ~longitude, lat = ~latitude, group = ~leg, 
                    color = 'Red', weight=2, dashArray=5)  %>%
      addAwesomeMarkers(lng= ~longitude, lat = ~latitude, popup = ~content, data = data(),
                        popupOptions = popupOptions(maxWidth=720, minWidth=720, maxHeight=1000)) 
  })
}

shinyApp(ui = ui, server = server)
