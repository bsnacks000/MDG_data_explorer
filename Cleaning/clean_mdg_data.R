library(tidyr)
library(dplyr)
library(stringr)

# This is the cleaning script for the MDG dataset...
# SET WORKING directory to this directory in order to output csv
# outputs mdg_master_cln.csv for use with the shiny app in the current directory


#TB data
data_death = read.csv("./Raw_data/mdg_tuberc_death.csv")
data_incidence = read.csv("./Raw_data/mdg_tuberc_incidence.csv")

#Environmental/health data
data_co2 = read.csv("./Raw_data/mdg_co2_emissions.csv")
data_ozone_all = read.csv("./Raw_data/mdg_ozone_all.csv")
data_ozone_cfc = read.csv("./Raw_data/mdg_ozone_cfc.csv")
data_slum = read.csv("./Raw_data/mdg_slum_pop.csv")
data_und_nourish = read.csv("./Raw_data/mdg_under_nourished_pop.csv")

# drop extra columns -- some csv error added extra cols...
data_co2 = data_co2[,-c(30,31,32)]
data_ozone_all = data_ozone_all[,-c(30,31,32)]
data_ozone_cfc = data_ozone_cfc[,-c(30,31,32)]
data_slum = data_slum[,-c(30,31,32)]
data_und_nourish = data_und_nourish[,-c(30,31,32)]

# function that builds out year, cleans data and set to numeric

clean_datasets = function(dataset){
    
    dataset = dataset %>% gather("year","n", 6:29)
    dataset[,"year"] = gsub("X","",dataset[,"year"])
    dataset$year = as.numeric(dataset$year)     
    dataset = dataset %>% select(-c(CountryCode, MDG, SeriesCode))  # remove these extra variables
    
    return(dataset)
    
}

data_death = clean_datasets(data_death)
data_incidence = clean_datasets(data_incidence)
data_co2 = clean_datasets(data_co2)
data_ozone_all = clean_datasets(data_ozone_all)
data_ozone_cfc = clean_datasets(data_ozone_cfc)
data_slum = clean_datasets(data_slum)
data_und_nourish = clean_datasets(data_und_nourish)

# filter only midpoints and remove extraneous columns for tb data
data_death = data_death %>% 
    filter(str_detect(data_death[,"Series"], "mid-point")) 

data_incidence = data_incidence %>% 
    filter(str_detect(data_incidence[, "Series"], "mid-point")) 

# Union to combine all into master clean long format

mdg_data_master = do.call("rbind",list(
    data_death,data_incidence, data_co2,data_ozone_all,data_ozone_cfc, data_slum,data_und_nourish)
)


# write clean csvs for project in current folder..
write.csv(mdg_data_master, file="./mdg_master_cln.csv", quote = TRUE, row.names=FALSE)
