## MDG Database -- Final Project server

# load/install dependencies
require(shiny)
require(dplyr)
require(ggplot2)
require(plotly)
require(googleVis)
require(tidyr)


# load util functions
source("./Util/util_functions.R")


# server 
shinyServer(function(input, output){
    
    ## reactive_inputs_GEO::
    
    selected_data_geo = reactive({
        data %>% filter(Series == input$series_geo & year == input$year_geo)
    })
    
    ## outputs_GEO::
    
    output$year_post = renderText(
        paste("Year: ", input$year_geo)
    )
    
    output$series_post = renderText(
        paste("Series: ", input$series_geo)
    )
    
    
    output$gvis_map_world = renderGvis({
        make_geo_chart(selected_data_geo(), "world")
    })
    
    output$gvis_map_africa = renderGvis({
        make_geo_chart(selected_data_geo(), "002")
    })
    
    output$gvis_map_europe = renderGvis({
        make_geo_chart(selected_data_geo(), "150")
    })
    
    output$gvis_map_namerica = renderGvis({
        make_geo_chart(selected_data_geo(), "021")
    })
    
    output$gvis_map_camerica = renderGvis({
        make_geo_chart(selected_data_geo(), "013")
    })
    
    output$gvis_map_carrib = renderGvis({
        make_geo_chart(selected_data_geo(), "029")
    })
    
    output$gvis_map_samerica = renderGvis({
        make_geo_chart(selected_data_geo(), "005")
    })
    
    output$gvis_map_asia = renderGvis({
        make_geo_chart(selected_data_geo(), "142")
    })
    
    output$gvis_map_oceania = renderGvis({
        make_geo_chart(selected_data_geo(), "009")
    })
    
    
    ##------------------------------------------------------##
    ## inputs_DATA_EX::
    
    selected_countries = replicate(5,"")
    
    selected_data_filt = reactive({
        
        selected_countries[1] = input$country1 
        selected_countries[2] = input$country2 
        selected_countries[3] = input$country3    
        selected_countries[4] = input$country4
        selected_countries[5] = input$country5
        
        data %>% filter(Series == input$series_filt, Country %in% selected_countries)
        
    })
    
    selected_data_spark = reactive({
        data %>% filter(Country == input$country_spark)
    })
    
    ## outputs_DATA_EX::
    output$series_post2 = renderText(
        paste("Series: ", input$series_filt)
    )
    
    output$data_table = renderDataTable({
        selected_data_filt() %>% select(-Series) %>% spread(year,n)
    })
    

    output$filter_chart = renderPlot({
        
        ggplot(selected_data_filt(), aes(year, n, group=Country, color=Country)) + 
            geom_line(size=0.85) #+
            #theme(legend.position="none")
        
    })

    
    output$tuberc_death = renderPlot({
        make_sparklines(selected_data_spark(), series_all$tuberc_death, series_title$tuberc_death, "red")
    })
    
    output$tuberc_inci = renderPlot({
        make_sparklines(selected_data_spark(), series_all$tuberc_inci,series_title$tuberc_inci, "red")
    })
    
    output$co2 = renderPlot({
        make_sparklines(selected_data_spark(), series_all$co2, series_title$co2, "green")
    })
    
    output$ozone_all = renderPlot({
        make_sparklines(selected_data_spark(), series_all$ozone_all, series_title$ozone_all, "green")
    })
    
    output$ozone_cfc = renderPlot({
        make_sparklines(selected_data_spark(), series_all$ozone_cfc, series_title$ozone_cfc, "green")
    })
    
    output$slum = renderPlot({
        make_sparklines(selected_data_spark(), series_all$slum, series_title$slum, "blue")
    })
    
    output$pop_und_nour = renderPlot({
        make_sparklines(selected_data_spark(), series_all$pop_und_nour, series_title$pop_und_nour, "blue")
    })
    
    
    ## --------------------------------------------------------------##
    ## inputs_CORR::
    
    selected_data_corr = reactive({
        x_axis = avg_master %>% filter(Series == input$x_axis) %>% rename(x = avg)
        y_axis = avg_master %>% filter(Series == input$y_axis) %>% rename(y = avg)
        combined = left_join(x_axis, y_axis, by="Country")
        combined = combined[complete.cases(combined) & combined$y < 20000,]  # eliminate some outliers from the co2 data
    })
    
    
    ## outputs_CORR::
    
    output$scatter_plot = renderPlotly({
        x_label = as.character(selected_data_corr()$Series.x[1])  
        y_label = as.character(selected_data_corr()$Series.y[1])
        
        
        
        
        p = ggplot(selected_data_corr(), aes(x,y)) +
            geom_point(aes(colour = Country)) + 
            geom_smooth(method = "lm") + 
            theme(legend.position="none") +
            xlab(x_label) + 
            ylab(y_label) + 
            theme(axis.title.x = element_text(size = rel(0.75))) + 
            theme(axis.title.y = element_text(size = rel(0.75))) +
            theme(axis.text.x = element_text(size = rel(0.75))) +
            theme(axis.text.y = element_text(size = rel(0.75)))
            
        
        plot_out = ggplotly(p)
        plot_out
        
    })

})