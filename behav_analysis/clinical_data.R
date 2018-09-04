library(nlme)
library(lsmeans)
library(ggplot2)
library(reshape2)
require(utils)
library(scales)
library(plotrix)
data <- read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1154_from1601_20180827.csv")

data$sex <- as.factor(data$sex)
#1=Male; 2= Female
table(data$sex)

ggplot(data,aes(x=ageInYears, fill=sex)) + geom_histogram()+facet_grid(~sex)

     
            