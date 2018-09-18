library(lsmeans)
library(ggplot2)
library(reshape2)
require(utils)
library(boot)
library(stringr)
library(visreg)


options("scipen"=10, "digits"=4)


data <- read.csv("/Users/sheilash/Desktop/projects/exec_extern_sex/inputData/data_agg/connectivity/restNetworks_264PowerPNC_dataagg_20180913.csv")
data2 <- data
data2$sex01 <- as.factor(data2$sex01)


list1x <- grep("n3", names(data3), value = TRUE) # n3=cingulo_opercular_task_control
list2x <- grep("n5", names(data3), value = TRUE) # n5=DMN
list3x <- grep("n8", names(data3), value = TRUE) # n8=frontoparietal
list4x <- grep("n9", names(data3), value = TRUE) # n9=salience
list5x <- grep("n11", names(data3), value = TRUE) # n11=ventral attention
list6x <- grep("n12", names(data3), value = TRUE) # n12=dorsal attention
list7x <- grep("n13", names(data3), value = TRUE) # n13=cerebellar
list8x <- grep("AllOther", names(data3), value = TRUE) # between networkx and all other
listwithin <- grep("within", names(data3), value = TRUE)

#namelist <- c(list1x, list2x, list3x, list4x, list5x, list6x, list7x, list8x, "between_overall", "within_overall")
namelist <- c(listwithin, "between_overall")


list1a <- c("age", "sex01")
list1b <- c("motion", "ageX01") #interaction last here
list3 <- c(list1a, list1b)



for (i in 1:length(namelist)){
  yvar <- namelist[i]
  print(yvar)
  newdata3 <- subset(data2, select=c("bblid", yvar, "sex01","ageInYears", "restRelMeanRMSMotion", "externalizing_4factorv2"))
  newdata3["yvar"] <- (newdata3[,2])
  newdata3 <- newdata3[complete.cases(newdata3), ]
  
  volume_estimate <- function(data, indices){
    newdata = data[indices, ]
    ##Step 1: fit the model to estimate the assoc between sex and the mediator (yvar).
    full.model <- lm(yvar ~ sex01+ ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter a
    a <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 2: fit the model to estimate the assoc between the outcome (externalizing symp) and  the mediator (yvar), adjusted for sex
    full.model <- lm(externalizing_4factorv2 ~ yvar + sex01   + ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter b
    b <- summary(full.model)$coefficients[2,"Estimate"]
    ##save c' as the regression coeff for sex01
    c_p <- summary(full.model)$coefficients[3,"Estimate"]
    
    
    ##Step 3: fit the model to estimate the "total effect of sex on the outcome (externalizing symp).  The coefficient for sex is the mediation parameter c.
    full.model <- lm(externalizing_4factorv2 ~ sex01   + ageInYears, data=newdata)
    summary(full.model)
    c <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 4:  using estimates from steps 1-3 compute indirect_effect=a*b
    
    indirect_effect=a*b
    #ratio of indirect effect to total :  ratio=(a*b)/c
    ratio=(a*b)/c
    
    parameters_boot <- c(a, b,c_p, c, indirect_effect, ratio)
    return(parameters_boot)
    
  }
  set.seed(10)
  results_med = boot(data = newdata3, statistic = volume_estimate, R = 2000)
  print(results_med)
  
  #a t1
  print("tstat and p for a")
  avg_ab <- results_med$t0[1]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t1.*$") # grab the line that starts with t1
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #b t2
  print("tstat and p for b")
  avg_ab <- results_med$t0[2]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t2.*$") # grab the line that starts with t2
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #c_p t3
  print("tstat and p for c")
  avg_ab <- results_med$t0[3]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t3.*$") # grab the line that starts with t3
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #ratio of c' over c t6
  confidence_interval_H = boot.ci(results_med, index = 6, conf = 0.95, type = 'bca')
  print(confidence_interval_H)
  #95%   (-0.0784,  0.0871 )  
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")

}




for (i in 1:length(namelist)){
  yvar <- namelist[i]
  print(yvar)
  newdata3 <- subset(data2, select=c("bblid", yvar, "sex01","ageInYears", "restRelMeanRMSMotion", "externalizing_corrtraitsv2"))
  newdata3["yvar"] <- (newdata3[,2])
  newdata3 <- newdata3[complete.cases(newdata3), ]
  
  volume_estimate <- function(data, indices){
    newdata = data[indices, ]
    ##Step 1: fit the model to estimate the assoc between sex and the mediator (yvar).
    full.model <- lm(yvar ~ sex01+ ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter a
    a <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 2: fit the model to estimate the assoc between the outcome (externalizing symp) and  the mediator (yvar), adjusted for sex
    full.model <- lm(externalizing_corrtraitsv2 ~ yvar + sex01   + ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter b
    b <- summary(full.model)$coefficients[2,"Estimate"]
    ##save c' as the regression coeff for sex01
    c_p <- summary(full.model)$coefficients[3,"Estimate"]
    
    
    ##Step 3: fit the model to estimate the "total effect of sex on the outcome (externalizing symp).  The coefficient for sex is the mediation parameter c.
    full.model <- lm(externalizing_corrtraitsv2 ~ sex01   + ageInYears, data=newdata)
    summary(full.model)
    c <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 4:  using estimates from steps 1-3 compute indirect_effect=a*b
    
    indirect_effect=a*b
    #ratio of indirect effect to total :  ratio=(a*b)/c
    ratio=(a*b)/c
    
    parameters_boot <- c(a, b,c_p, c, indirect_effect, ratio)
    return(parameters_boot)
    
  }
  set.seed(10)
  results_med = boot(data = newdata3, statistic = volume_estimate, R = 2000)
  print(results_med)
  
  #a t1
  print("tstat and p for a")
  avg_ab <- results_med$t0[1]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t1.*$") # grab the line that starts with t1
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #b t2
  print("tstat and p for b")
  avg_ab <- results_med$t0[2]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t2.*$") # grab the line that starts with t2
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #c_p t3
  print("tstat and p for c")
  avg_ab <- results_med$t0[3]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t3.*$") # grab the line that starts with t3
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #ratio of c' over c t6
  confidence_interval_H = boot.ci(results_med, index = 6, conf = 0.95, type = 'bca')
  print(confidence_interval_H)
  #95%   (-0.0784,  0.0871 )  
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  
}















data <- read.csv("/Users/sheilash/Desktop/projects/exec_extern_sex/inputData/data_agg/connectivity/restNetworks_264PowerPNC_dataagg_20180913.csv")
data2 <- data
data2$sex01 <- as.factor(data2$sex01)


list1x <- grep("n3", names(data3), value = TRUE) # n3=cingulo_opercular_task_control
list2x <- grep("n5", names(data3), value = TRUE) # n5=DMN
list3x <- grep("n8", names(data3), value = TRUE) # n8=frontoparietal
list4x <- grep("n9", names(data3), value = TRUE) # n9=salience
list5x <- grep("n11", names(data3), value = TRUE) # n11=ventral attention
list6x <- grep("n12", names(data3), value = TRUE) # n12=dorsal attention
list7x <- grep("n13", names(data3), value = TRUE) # n13=cerebellar
list8x <- grep("AllOther", names(data3), value = TRUE) # between networkx and all other
listwithin <- grep("within", names(data3), value = TRUE)

#namelist <- c(list1x, list2x, list3x, list4x, list5x, list6x, list7x, list8x, "between_overall", "within_overall")
namelist <- c(list2x, "within_overall", "between_overall")


list1a <- c("age", "sex01")
list1b <- c("motion", "ageX01") #interaction last here
list3 <- c(list1a, list1b)



for (i in 1:length(namelist)){
  yvar <- namelist[i]
  print(yvar)
  newdata3 <- subset(data2, select=c("bblid", yvar, "sex01","ageInYears", "restRelMeanRMSMotion", "mood_4factorv2"))
  newdata3["yvar"] <- (newdata3[,2])
  newdata3 <- newdata3[complete.cases(newdata3), ]
  
  volume_estimate <- function(data, indices){
    newdata = data[indices, ]
    ##Step 1: fit the model to estimate the assoc between sex and the mediator (yvar).
    full.model <- lm(yvar ~ sex01+ ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter a
    a <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 2: fit the model to estimate the assoc between the outcome (externalizing symp) and  the mediator (yvar), adjusted for sex
    full.model <- lm(mood_4factorv2 ~ yvar + sex01   + ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter b
    b <- summary(full.model)$coefficients[2,"Estimate"]
    ##save c' as the regression coeff for sex01
    c_p <- summary(full.model)$coefficients[3,"Estimate"]
    
    
    ##Step 3: fit the model to estimate the "total effect of sex on the outcome (externalizing symp).  The coefficient for sex is the mediation parameter c.
    full.model <- lm(mood_4factorv2 ~ sex01   + ageInYears, data=newdata)
    summary(full.model)
    c <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 4:  using estimates from steps 1-3 compute indirect_effect=a*b
    
    indirect_effect=a*b
    #ratio of indirect effect to total :  ratio=(a*b)/c
    ratio=(a*b)/c
    
    parameters_boot <- c(a, b,c_p, c, indirect_effect, ratio)
    return(parameters_boot)
    
  }
  set.seed(10)
  results_med = boot(data = newdata3, statistic = volume_estimate, R = 2000)
  print(results_med)
  
  #a t1
  print("tstat and p for a")
  avg_ab <- results_med$t0[1]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t1.*$") # grab the line that starts with t1
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #b t2
  print("tstat and p for b")
  avg_ab <- results_med$t0[2]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t2.*$") # grab the line that starts with t2
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #c_p t3
  print("tstat and p for c")
  avg_ab <- results_med$t0[3]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t3.*$") # grab the line that starts with t3
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #ratio of c' over c t6
  confidence_interval_H = boot.ci(results_med, index = 6, conf = 0.95, type = 'bca')
  print(confidence_interval_H)
  #95%   (-0.0784,  0.0871 )  
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  
}











for (i in 1:length(namelist)){
  yvar <- namelist[i]
  print(yvar)
  newdata3 <- subset(data2, select=c("bblid", yvar, "sex01","ageInYears", "restRelMeanRMSMotion", "overall_psychopathology_4factorv2"))
  newdata3["yvar"] <- (newdata3[,2])
  newdata3 <- newdata3[complete.cases(newdata3), ]
  
  volume_estimate <- function(data, indices){
    newdata = data[indices, ]
    ##Step 1: fit the model to estimate the assoc between sex and the mediator (yvar).
    full.model <- lm(yvar ~ sex01+ ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter a
    a <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 2: fit the model to estimate the assoc between the outcome (externalizing symp) and  the mediator (yvar), adjusted for sex
    full.model <- lm(overall_psychopathology_4factorv2 ~ yvar + sex01   + ageInYears + restRelMeanRMSMotion, data=newdata)
    summary(full.model)
    ##save parameter b
    b <- summary(full.model)$coefficients[2,"Estimate"]
    ##save c' as the regression coeff for sex01
    c_p <- summary(full.model)$coefficients[3,"Estimate"]
    
    
    ##Step 3: fit the model to estimate the "total effect of sex on the outcome (externalizing symp).  The coefficient for sex is the mediation parameter c.
    full.model <- lm(overall_psychopathology_4factorv2 ~ sex01   + ageInYears, data=newdata)
    summary(full.model)
    c <- summary(full.model)$coefficients[2,"Estimate"]
    
    ##Step 4:  using estimates from steps 1-3 compute indirect_effect=a*b
    
    indirect_effect=a*b
    #ratio of indirect effect to total :  ratio=(a*b)/c
    ratio=(a*b)/c
    
    parameters_boot <- c(a, b,c_p, c, indirect_effect, ratio)
    return(parameters_boot)
    
  }
  set.seed(10)
  results_med = boot(data = newdata3, statistic = volume_estimate, R = 2000)
  print(results_med)
  
  #a t1
  print("tstat and p for a")
  avg_ab <- results_med$t0[1]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t1.*$") # grab the line that starts with t1
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #b t2
  print("tstat and p for b")
  avg_ab <- results_med$t0[2]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t2.*$") # grab the line that starts with t2
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #c_p t3
  print("tstat and p for c")
  avg_ab <- results_med$t0[3]
  x <- capture.output(results_med) # store the output as text
  x <- str_extract(x ,"^t3.*$") # grab the line that starts with t3
  x <- x[!is.na(x)] # remove all the lines we don't need
  se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
  stdErr_ab <- se
  teststat = avg_ab/stdErr_ab
  print(teststat) 
  pvalue2sided=2*pnorm(-abs(teststat))
  print(pvalue2sided) 
  
  #ratio of c' over c t6
  confidence_interval_H = boot.ci(results_med, index = 6, conf = 0.95, type = 'bca')
  print(confidence_interval_H)
  #95%   (-0.0784,  0.0871 )  
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  print("  ")
  
}
