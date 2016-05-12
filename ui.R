## MDG Database -- Final Project ui

require(shiny)
require(dplyr)
require(ggplot2)
require(plotly)
require(googleVis)


## load series title data and datasets into app on ui side
source("./Util/series_title_data.R")
source("./Util/build_dataset.R")

## ui 
shinyUI(
    
    navbarPage(
        title = "Millenial Database Goals Data Explorer",
        
        tabPanel(
            title = "About",
            
            includeMarkdown("./Mkdwn/project_desc.Rmd")
            
        ),
        ## <---- GEOCHART TAB ---->
        tabPanel(
            title = "GeoChart",
            
            sidebarLayout(            # <---- GEO- INNER LAYOUT
                
                sidebarPanel(
                    
                    selectInput("series_geo",label="Choose MDG Indicator",choices= list(
                        series_all$tuberc_death,series_all$tuberc_inci,
                        series_all$co2,series_all$ozone_all,series_all$ozone_cfc,
                        series_all$slum,series_all$pop_und_nour
                        )
                    ),
                    sliderInput("year_geo", label="Year",value=2000, min=1990, max=2013),
                    HTML("<br><p><strong>NOTE</strong>: Slum population data is only available in select 
                        regions for 1990, 1995, 2000, 2005, 2007, 2009. </p><br><strong>NOTE</strong>: CO2 emissions data is only available up to 2011
                        worldwide.</p><br><strong>NOTE</strong>: Population under-nourished data is not available in 1990. </p>")
                    
                ),
                
                mainPanel(
                    
                    tags$h4(textOutput("year_post")),
                    
                    tags$h4(textOutput("series_post")),
                    
                    tabsetPanel(
                        
                        tabPanel(
                            title = "World",
                            htmlOutput("gvis_map_world")
                        ),
                        
                        tabPanel(
                            title = "Africa",
                            htmlOutput("gvis_map_africa")
                        ),
                        
                        tabPanel(
                            title = "Europe",
                            htmlOutput("gvis_map_europe")
                        ),
                        
                        tabPanel(
                            title = "North America",
                            htmlOutput("gvis_map_namerica")
                        ),
                        
                        tabPanel(
                            title = "Central America",
                            htmlOutput("gvis_map_camerica")
                        ),
                        
                        tabPanel(
                            title = "Carribean",
                            htmlOutput("gvis_map_carrib")
                        ),
                        
                        tabPanel(
                            title = "South America",
                            htmlOutput("gvis_map_samerica")
                        ),
                        
                        tabPanel(
                            title = "Asia",
                            htmlOutput("gvis_map_asia")
                        ),
                        tabPanel(
                            title = "Oceania",
                            htmlOutput("gvis_map_oceania")
                        ),
                        tags$h4(textOutput("yearly_max")),
                        tags$h4(textOutput("yearly_min"))
                    )
                )
            )
        ),
        
        
        ## <--- DATA EXPLORER --->
        tabPanel(
            title = "Data Explorer",
            
            tabsetPanel(
                
                tabPanel(
                    title = "Sparklines",
                    inputPanel(
                        selectInput("country_spark", label="Country", choices =levels(data$Country))
                    ),
                    
                    fluidRow(
                        column(width=4, plotOutput("tuberc_death")),
                        column(width=4, plotOutput("tuberc_inci")),
                        column(width=4, plotOutput("pop_und_nour"))
                    ),
                    
                    fluidRow(
                        column(width=3,plotOutput("ozone_all")),
                        column(width=3,plotOutput("ozone_cfc")),
                        column(width=3,plotOutput("co2")),
                        column(width=3,plotOutput("slum"))
                    )
                    
                ),
                
                
                tabPanel(
                    title = "Filter Chart",
                    sidebarPanel(
                        selectInput("series_filt",label = "Choose MDG Indicator",choices=levels(data$Series)),
                        selectInput("country1", label= "Country 1",choices=levels(data$Country)),
                        selectInput("country2", label= "Country 2",choices=c("<<Select Country>>",levels(data$Country))),
                        selectInput("country3", label= "Country 3",choices=c("<<Select Country>>",levels(data$Country))),
                        selectInput("country4", label= "Country 4",choices=c("<<Select Country>>",levels(data$Country))),
                        selectInput("country5", label= "Country 5",choices=c("<<Select Country>>",levels(data$Country)))
                        
                    ),
                    mainPanel(
                        tags$h4(textOutput("series_post2")),
                        plotOutput("filter_chart"),
                        HTML("<h4> Results </h4>"),
                        dataTableOutput("data_table")
                    )
                    
                )
            )
        ),
        
        
        ## <--- CORRELATION EXPLORER --->
        tabPanel(
            title = "Correlation Explorer (means)",
            
            sidebarLayout(
                
                sidebarPanel(
                    selectInput("x_axis", label="x axis",width = "100%", choices=levels(data$Series)),
                    selectInput("y_axis", label="y axis",width = "100%", choices=levels(data$Series))
          
                ),
                
                
                mainPanel(
                    plotlyOutput("scatter_plot")
                )
            )
        )
    )
)