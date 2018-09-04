
data_old <- readRDS("/data/jux/BBL/projects/exec_extern_sex/oldData/nbackFactors_n1601_subjData_20150506.rds")
data_new <- read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1051_from1601_20180831.csv") #after 4 level exclusion, subsetted for complete data for extern, medu, fedu


#reg_names <- names(data_old)[grep("nback_func", names(data_old))] #get the names of all the columns with factorv2 in the name
datao <- data_old[c(1,447:473)]           
dataon <- merge(datao, data_new, by="bblid")


write.csv(dataon, file = "/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1051_from1601_jneurosciROIs_20180831.csv")
