data = read.csv("./Data/mdg_master_cln.csv")
data = data[complete.cases(data),] # omit NA rows for summary
avg_master = data %>% group_by(Country, Series) %>% summarise(avg = mean(n))
