## MDG Database -- Final Project ui

require(shiny)

## load series title data and datasets to build ui inputs
source("./Util/series_title_data.R")
source("./Util/build_dataset.R")

## ui 
shinyUI(
    
    navbarPage(
        title = "MDG Database",
        
        tabPanel(
            title = "About",
            
            HTML("<p>... Insert project info text in HTML ...</p>")
            
        ),
        ## <---- GEOCHART TAB ---->
        tabPanel(
            title = "GeoChart",
            
            sidebarLayout(            # <---- GEO- INNER LAYOUT
                
                sidebarPanel(
                    
                    selectInput("series_geo",label="MDG Target",choices= list(
                        series_all$tuberc_death,series_all$tuberc_inci,
                        series_all$co2,series_all$ozone_all,series_all$ozone_cfc,
                        series_all$slum,series_all$pop_und_nour
                        )
                    ),
                    sliderInput("year_geo", label="Year",value=2000, min=1990, max=2013)
                    
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
                        )
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
                        selectInput("series_filt",label = "MDG Target",choices=levels(data$Series)),
                        selectInput("country1", label= "Country 1",choices=levels(data$Country)),
                        selectInput("country2", label= "Country 2",choices=levels(data$Country)),
                        selectInput("country3", label= "Country 3",choices=levels(data$Country)),
                        selectInput("country4", label= "Country 4",choices=levels(data$Country)),
                        selectInput("country5", label= "Country 5",choices=levels(data$Country))
                        
                    ),
                    mainPanel(
                        plotlyOutput("filter_chart")    
                    )
                    
                )
            )
        ),
        
        tabPanel(
            title = "Correlation (means)",
            
            sidebarLayout(
                
                sidebarPanel(
                    selectInput("x_axis", label="x axis",width = "100%", choices=list(
                        series_all$tuberc_death, series_all$tuberc_inci
                        )
                    ),
                    
                    selectInput("y_axis", label="y axis",width = "100%", choices=list(
                        series_all$co2,series_all$ozone_all,series_all$ozone_cfc,series_all$slum,series_all$pop_und_nour
                        )
                    )  
                ),
                
                
                mainPanel(
                    plotlyOutput("scatter_plot")
                )
            )
        )
    )
)