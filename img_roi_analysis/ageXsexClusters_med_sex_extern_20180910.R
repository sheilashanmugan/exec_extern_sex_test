library(lsmeans)
library(ggplot2)
library(reshape2)
require(utils)
library(boot)
library(stringr)


options("scipen"=10, "digits"=4)


data <- read.csv("/Users/sheilash/Desktop/projects/exec_extern_sex/InputData/data_agg/nback_n1032_from1601_oldImgPaths_20180829.csv")
meants <- read.csv("/Users/sheilash/Desktop/projects/exec_extern_sex/InputData/clusters_fslmeants.csv")
data2 <- merge(data,meants,by="bblid")




########## 
yvar <- "precuneous"
newdata3 <- subset(data2, select=c("bblid", yvar, "sex1m1","ageInYears", "nbackRelMeanRMSMotion", "externalizing_4factorv2"))
newdata3["yvar"] <- (newdata3[,2])
newdata3 <- newdata3[complete.cases(newdata3), ]

volume_estimate <- function(data, indices){
  newdata = data[indices, ]
  ##Step 1: fit the model to estimate the assoc between sex and the mediator (yvar).
  full.model <- lm(yvar ~ sex1m1+ ageInYears + nbackRelMeanRMSMotion, data=newdata)
  summary(full.model)
  ##save parameter a
  a <- summary(full.model)$coefficients[2,"Estimate"]
  
  ##Step 2: fit the model to estimate the assoc between the outcome (externalizing symp) and  the mediator (yvar), adjusted for sex
  full.model <- lm(externalizing_4factorv2 ~ yvar + sex1m1   + ageInYears + nbackRelMeanRMSMotion, data=newdata)
  summary(full.model)
  ##save parameter b
  b <- summary(full.model)$coefficients[2,"Estimate"]
  ##save c' as the regression coeff for sex1m1
  c_p <- summary(full.model)$coefficients[3,"Estimate"]
  
  
  ##Step 3: fit the model to estimate the "total effect of sex on the outcome (externalizing symp).  The coefficient for sex is the mediation parameter c.
  full.model <- lm(externalizing_4factorv2 ~ sex1m1   + ageInYears, data=newdata)
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
results_med
# these are from set seed 10
# ORDINARY NONPARAMETRIC BOOTSTRAP
# 
# 
# Call:
#   boot(data = newdata3, statistic = volume_estimate, R = 2000)
# 
# 
# Bootstrap Statistics :
#   original     bias    std. error
# t1*  0.024501  0.0000970    0.005504
# t2* -0.191494 -0.0092890    0.209074
# t3*  0.116521 -0.0002576    0.029450
# t4*  0.113159 -0.0007501    0.029294
# t5* -0.004692 -0.0004432    0.005553
# t6* -0.041461 -0.0094579    0.063547

plot(results_med, index = 1)
plot(results_med, index = 2)
plot(results_med, index = 3)

### teststat= avg(a*b)/std error(a*b)

#a t1
avg_ab <- results_med$t0[1]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t1.*$") # grab the line that starts with t1
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat 
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided 

#b t2
avg_ab <- results_med$t0[2]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t2.*$") # grab the line that starts with t2
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat #-0.9364
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided #0.349

#c_p t3
avg_ab <- results_med$t0[3]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t3.*$") # grab the line that starts with t3
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat # 3.888
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided # 0.0001011

#ratio of c' over c t6
confidence_interval_H = boot.ci(results_med, index = 6, conf = 0.95, type = 'bca')
confidence_interval_H

# BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
# Based on 2000 bootstrap replicates
# 
# CALL : 
#   boot.ci(boot.out = results_med, conf = 0.95, type = "bca", index = 6)
# 
# Intervals : 
#   Level       BCa          
# 95%   (-0.1978,  0.0391 )  
# Calculations and Intervals on Original Scale



###########################
yvar <- "RParietal"
newdata3 <- subset(data2, select=c("bblid", yvar, "sex1m1","ageInYears", "nbackRelMeanRMSMotion", "externalizing_4factorv2"))
newdata3["yvar"] <- (newdata3[,2])
newdata3 <- newdata3[complete.cases(newdata3), ]

volume_estimate <- function(data, indices){
  newdata = data[indices, ]
  ##Step 1: fit the model to estimate the assoc between sex and the mediator (yvar).
  full.model <- lm(yvar ~ sex1m1+ ageInYears + nbackRelMeanRMSMotion, data=newdata)
  summary(full.model)
  ##save parameter a
  a <- summary(full.model)$coefficients[2,"Estimate"]
  
  ##Step 2: fit the model to estimate the assoc between the outcome (externalizing symp) and  the mediator (yvar), adjusted for sex
  full.model <- lm(externalizing_4factorv2 ~ yvar + sex1m1   + ageInYears + nbackRelMeanRMSMotion, data=newdata)
  summary(full.model)
  ##save parameter b
  b <- summary(full.model)$coefficients[2,"Estimate"]
  ##save c' as the regression coeff for sex1m1
  c_p <- summary(full.model)$coefficients[3,"Estimate"]
  
  
  ##Step 3: fit the model to estimate the "total effect of sex on the outcome (externalizing symp).  The coefficient for sex is the mediation parameter c.
  full.model <- lm(externalizing_4factorv2 ~ sex1m1   + ageInYears, data=newdata)
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
results_med
# these are from set seed 10
# ORDINARY NONPARAMETRIC BOOTSTRAP
# 
# 
# Call:
#   boot(data = newdata3, statistic = volume_estimate, R = 2000)
# 
# 
# Bootstrap Statistics :
#   original      bias    std. error
# t1*  0.00567393  0.00005561    0.001715
# t2* -0.00765558 -0.00717296    0.639219
# t3*  0.11187290 -0.00048764    0.029145
# t4*  0.11315875 -0.00075008    0.029294
# t5* -0.00004344 -0.00021316    0.003874
# t6* -0.00038386 -0.00326606    0.040795

plot(results_med, index = 1)
plot(results_med, index = 2)
plot(results_med, index = 3)

### teststat= avg(a*b)/std error(a*b)

#a t1
avg_ab <- results_med$t0[1]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t1.*$") # grab the line that starts with t1
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat 
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided # 0.0009383

#b t2
avg_ab <- results_med$t0[2]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t2.*$") # grab the line that starts with t2
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat 
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided #0.9904

#c_p t3
avg_ab <- results_med$t0[3]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t3.*$") # grab the line that starts with t3
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat 
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided # 0.0001235

#ratio of c' over c t6
confidence_interval_H = boot.ci(results_med, index = 6, conf = 0.95, type = 'bca')
confidence_interval_H
# BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
# Based on 2000 bootstrap replicates
# 
# CALL : 
#   boot.ci(boot.out = results_med, conf = 0.95, type = "bca", index = 6)
# 
# Intervals : 
#   Level       BCa          
# 95%   (-0.098,  0.068 )  
# Calculations and Intervals on Original Scale






###########################
yvar <- "RDlpfc"
newdata3 <- subset(data2, select=c("bblid", yvar, "sex1m1","ageInYears", "nbackRelMeanRMSMotion", "externalizing_4factorv2"))
newdata3["yvar"] <- (newdata3[,2])
newdata3 <- newdata3[complete.cases(newdata3), ]

volume_estimate <- function(data, indices){
  newdata = data[indices, ]
  ##Step 1: fit the model to estimate the assoc between sex and the mediator (yvar).
  full.model <- lm(yvar ~ sex1m1+ ageInYears + nbackRelMeanRMSMotion, data=newdata)
  summary(full.model)
  ##save parameter a
  a <- summary(full.model)$coefficients[2,"Estimate"]
  
  ##Step 2: fit the model to estimate the assoc between the outcome (externalizing symp) and  the mediator (yvar), adjusted for sex
  full.model <- lm(externalizing_4factorv2 ~ yvar + sex1m1   + ageInYears + nbackRelMeanRMSMotion, data=newdata)
  summary(full.model)
  ##save parameter b
  b <- summary(full.model)$coefficients[2,"Estimate"]
  ##save c' as the regression coeff for sex1m1
  c_p <- summary(full.model)$coefficients[3,"Estimate"]
  
  
  ##Step 3: fit the model to estimate the "total effect of sex on the outcome (externalizing symp).  The coefficient for sex is the mediation parameter c.
  full.model <- lm(externalizing_4factorv2 ~ sex1m1   + ageInYears, data=newdata)
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
results_med
# these are from set seed 10
# ORDINARY NONPARAMETRIC BOOTSTRAP
# 
# 
# Call:
#   boot(data = newdata3, statistic = volume_estimate, R = 2000)
# 
# 
# Bootstrap Statistics :
#   original      bias    std. error
# t1*  0.002538 -0.00001632   0.0006755
# t2* -0.672024 -0.01972197   1.5476263
# t3*  0.113535 -0.00049440   0.0294472
# t4*  0.113159 -0.00075008   0.0292940
# t5* -0.001706 -0.00020640   0.0041694
# t6* -0.015073 -0.00382281   0.0438237

plot(results_med, index = 1)
plot(results_med, index = 2)
plot(results_med, index = 3)

### teststat= avg(a*b)/std error(a*b)

#a t1
avg_ab <- results_med$t0[1]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t1.*$") # grab the line that starts with t1
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat 
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided 

#b t2
avg_ab <- results_med$t0[2]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t2.*$") # grab the line that starts with t2
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat 
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided 

#c_p t3
avg_ab <- results_med$t0[3]
x <- capture.output(results_med) # store the output as text
x <- str_extract(x ,"^t3.*$") # grab the line that starts with t3
x <- x[!is.na(x)] # remove all the lines we don't need
se <- as.numeric(unlist(str_extract_all(x, '[0-9.]+$'))) # extract the final value (se)
stdErr_ab <- se
teststat = avg_ab/stdErr_ab
teststat 
pvalue2sided=2*pnorm(-abs(teststat))
pvalue2sided 

#ratio of c' over c t6
confidence_interval_H = boot.ci(results_med, index = 6, conf = 0.95, type = 'bca')
confidence_interval_H
# BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
# Based on 2000 bootstrap replicates
# 
# CALL : 
#   boot.ci(boot.out = results_med, conf = 0.95, type = "bca", index = 6)
# 
# Intervals : 
#   Level       BCa          
# 95%   (-0.1274,  0.0555 )  
# Calculations and Intervals on Original Scale
