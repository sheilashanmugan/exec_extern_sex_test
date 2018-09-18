
#Read in csvs
data_demo <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_demographics_go1_20161212.csv", header = TRUE) #n=1629
data_bifactor <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_goassess_itemwise_bifactor_scores_20161219.csv", header = TRUE) #n1601
data_corrtraits <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_goassess_itemwise_corrtraits_scores_20161219.csv", header=TRUE) #n1601
data_psychsum <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_goassess_psych_summary_vars_20131014.csv", header=TRUE) #n1601
data_nbackbehav <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_nbackBehavior_from_20160207_dataRelease_20161027.csv", header=TRUE)#n1601
data_nbackqa <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_NbackQAData_20170427.csv", header = TRUE) #n1601
data_health <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_health_20170421.csv", header = TRUE) #n1601
data_t1 <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/n1601_t1QaData_20170306.csv", header = TRUE) #n1601
    #path from trellow board (/data/joy/BBL/studies/pnc/n1601_dataFreeze/neuroimaging/t1struct/n1601_t1QaData_20170306.csv) 
    ##not the same as path from wiki, which does not exist (/data/joy/BBL/studies/pnc/n1601_dataFreeze2016/neuroimaging/t1struct/n1601_t1QaData_v2.csv)


#read in csvs of cope and varcope paths
## from ls -d /data/joy/BBL/studies/pnc/processedData/nback/xcpdocker_201809/*/*/norm/*[[:digit:]]_contrast4* > cope4_2-0_paths_NEW.csv
data_copes <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/cope4_2-0_paths_NEW.csv", header = FALSE) #n2267
names(data_copes) <- "cope.path.2m0"

# more cope4_2-0_paths_NEW.csv | perl -pe 's/(.*)norm(.*)/$2/' | perl -pe 's/(.*)x(.*)/$2/' |perl -pe 's/(.*)_contrast4(.*)/$1/' > cope4_scanids_NEW.csv
data_copes_scanid <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/cope4_scanids_NEW.csv", header = FALSE)

##from ls -d /data/joy/BBL/studies/pnc/processedData/nback/xcpdocker_201809/*/*/task/copes/*varcope4* > varcope4_2-0_paths_NEW.csv
names(data_copes_scanid) <- "scanid"

data_cope_paths <- cbind(data_copes, data_copes_scanid)

data_varcopes <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/varcope4_2-0_paths_NEW.csv", header = FALSE) #n2267
names(data_varcopes) <- "varcope.path.2m0"

#more more varcope4_2-0_paths_NEW.csv | perl -pe 's/(.*)varcopes(.*)/$2/' | perl -pe 's/(.*)x(.*)/$2/' |perl -pe 's/(.*)_varcope4(.*)/$1/' > varcope4_scanids_NEW.csv
data_varcopes_scanid <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/varcope4_scanids_NEW.csv", header = FALSE)
names(data_varcopes_scanid) <- "scanid"

data_varcope_paths <- cbind(data_varcopes, data_varcopes_scanid)

#sigchange
#ls -d /data/joy/BBL/studies/pnc/processedData/nback/xcpdocker_201809/*/*/norm/*change_contrast4* > sigchange4_2-0_paths_NEW.csv
data_sigch <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/sigchange4_2-0_paths_NEW.csv", header = FALSE) #n2267
names(data_sigch) <- "sigchange.path.2m0"

#more sigchange4_2-0_paths_NEW.csv |  perl -pe 's/(.*)norm(.*)/$2/' | perl -pe 's/(.*)x(.*)/$2/' |perl -pe 's/(.*)_sigchange(.*)/$1/' > sigchange4_scanids_NEW.csv
data_sigch_scanid <-read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/sigchange4_scanids_NEW.csv", header = FALSE)
names(data_sigch_scanid) <- "scanid"

data_sigch_paths <- cbind(data_sigch, data_sigch_scanid)



#Merge csvs
data1 <- merge(data_demo, data_bifactor, by =c("scanid", "bblid"), all = TRUE) #n1629
data2 <- merge(data1, data_corrtraits, by =c("scanid", "bblid"), all = TRUE)  #n1629
data3 <- merge(data2, data_psychsum, by =c("scanid", "bblid"), all = TRUE) #n1629
data4 <- merge(data3, data_nbackbehav, by =c("scanid", "bblid"), all = TRUE) #n1629
data5 <- merge(data4, data_nbackqa, by =c("scanid", "bblid"), all = TRUE) #n1629
data6 <- merge(data5, data_health, by =c("scanid", "bblid"), all = TRUE) #n1629
data7 <- merge(data6, data_t1, by =c("scanid", "bblid"), all = TRUE) #n1629
data8 <- merge(data7, data_cope_paths, by ="scanid", all = TRUE) #n2402
data9a <- merge(data8, data_varcope_paths, by ="scanid", all = TRUE) #n2402
data9 <- merge(data9a, data_sigch_paths, by ="scanid", all = TRUE) #n2402

#Apply exclusion criteria
#1) Subject level exclusion: health exclude
data10 <- subset(data9, healthExcludev2 == 0) #n1447

#2) Stuctural imaging exclude: t1Exclude
data11 <- subset(data10, t1Exclude == 0) #n1396

#3) Modality-specific exclusions: nbackExcludeVoxelwise
data12 <- subset(data11, nbackExcludeVoxelwise == 0) #n1200

#4) Behavioral data exclusion: Per trello board, >7 non-response on 0-back (1154). Not the same as on wiki (> 6; 1146)
data13 <- subset(data12, nbackBehZerobackAllNrCount < 8) #n1154

#check for NA
table(data13$ageAtScan1, exclude = NULL) #0
table(data13$sex, exclude = NULL) #0

#add column with age in years
data13$ageInYears <- data13$ageAtScan1/12
#make sex 0/1
data13$sex01 <- ifelse(data13$sex==1, 0,1)
data13$sex01 <- as.factor(data13$sex01)
data13$sex1m1 <- ifelse(data13$sex==1, 1,-1) 
#write.csv(data13, file = "/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1154_from1601_20180827.csv")

#subset by missing vars
data14<- subset(data13, externalizing_4factorv2 != "NA") #n=1153
data15<- subset(data14, cope.path.2m0 != "NA") #n=1153
data16a<- subset(data15, varcope.path.2m0 != "NA") #n=1153

#remove subs w diff oriendation?
#Require(Hmisc)
exclist <- c("7422", "7623", "7631", "7999", "8108", "8159", "8177", "8223", "8309", "8464")
data16 <- subset(data16a, !(scanid %in% exclist))

write.csv(data16, file = "/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1112_from1601_newImgPaths_20180910.csv")
