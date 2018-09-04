
#data copied from /data/joy/BBL/studies/pnc/n9498_dataFreeze/
data_demo <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n9498_dataFreeze/n9498_demographics_go1_20161212.csv", header = TRUE) #n=9498
data_bifactor <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n9498_dataFreeze/n9498_goassess_itemwise_bifactor_scores_20161219.csv", header = TRUE) #n9350
data_corrtraits <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n9498_dataFreeze/n9498_goassess_itemwise_corrtraits_scores_20161219.csv", header=TRUE) #n9350
data_psychsum <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n9498_dataFreeze/n9498_diagnosis_dxpmr_20161014.csv", header=TRUE) 
#data_nbackbehav <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_nbackBehavior_from_20160207_dataRelease_20161027.csv", header=TRUE)#n1601
data_cnb <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n9498_dataFreeze/n9498_cnb_zscores_fr_20170202.csv", header = TRUE) #n=9498
data_health <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n9498_dataFreeze/n9498_health_20170405.csv", header = TRUE) #n=9498



#Merge csvs
data1 <- merge(data_demo, data_bifactor, by =c( "bblid"), all = TRUE) 
data2 <- merge(data1, data_corrtraits, by =c("bblid"), all = TRUE)  
data3 <- merge(data2, data_psychsum, by =c("bblid"), all = TRUE) 
#data4 <- merge(data3, data_nbackbehav, by =c( "bblid"), all = TRUE) 
data5 <- merge(data3, data_cnb, by =c("bblid"), all = TRUE)
data6 <- merge(data5, data_health, by =c( "bblid"), all = TRUE) 



#Apply exclusion criteria
#for age x sex
data7 <- subset(data6, medicalratingExclude == 0) #n7151
data8<- subset(data7, externalizing_4factorv2 != "NA") #n=7053

write.csv(data8, file = "/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/n7053_from9498_20180829.csv")


#) for mfedu
data7 <- subset(data6, medicalratingExclude == 0) #n7151
data8<- subset(data7, medu1 != "NA") #n=7046
data9<- subset(data8, fedu1 != "NA") #n=6543
data10<- subset(data9, externalizing_4factorv2 != "NA") #n=6469

write.csv(data10, file = "/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/n6469_from9498_20180829.csv")



