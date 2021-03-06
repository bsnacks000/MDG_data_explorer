## Utility functions for MDG app


make_geo_chart = function (dataset, region_code){
    
    ## makes each geochart based on unique closure and user specified region code
    
    return(
        gvisGeoChart(
            dataset, locationvar="Country", colorvar="n",  
            options= list(
                region=region_code, resolution="countries",displayMode="auto",
                height="450px", width="850px", colorAxis="{colors:['#99FF99', '#FF0000']}"
            )
        )
    )
}

make_sparklines = function(dataset, series, title, color){
    
    # makes the sparklines plots for data explorer
       
    dataset = dataset %>% filter(Series == series) # this might need to change -- long load time
    
    return(
        ggplot(dataset, aes(year, n)) + 
            geom_line(size=0.85, color = color) +
            theme(legend.position="none", 
                  axis.text.x=element_blank(),     # remove extraneous info for sparkline format
                  axis.text.y=element_blank(),
                  axis.title.y=element_blank()
                  ) +
            ggtitle(title)
        
    )
}


