
## Install packages
require(lavaan)
require(stats)
require(Formula)
library(mgcv)
library(voxel)
library(knitr)
library(visreg)

## Load in data
data <- read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1032_from1601_oldImgPaths_20180829.csv")
meants <- read.csv("/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1032_cope.path.2m0/ageInYears_sex1m1_nbackRelMeanRMSMotion/fdr/easythresh/clusters_fslmeants.csv")
r2star1 <- merge(data,meants,by="bblid")

## Get necessary columns
r2star <- subset(r2star1, select=c("bblid", "sex1m1","ageInYears",  "nbackRelMeanRMSMotion", "externalizing_4factorv2", "precuneous") #, "RParietal", "RDlpfc", "Lpariental", "allClusters"))
r2star <- r2star[complete.cases(r2star), ]

## Set variables
r2star$sex <- as.factor(r2star$sex)
age <- r2star$ageInYears
reg <- r2star$precuneous
motion <- r2star$nbackRelMeanRMSMotion
sympt <- r2star$externalizing_4factorv2

## Regress covariates out
caudateGam <- gam(precuneous ~ ageInYears + nbackRelMeanRMSMotion, method="REML", data=r2star)
caudateResid <- resid(caudateGam)

accuracyGam <- gam(accuracy ~ sex, method="REML", data=r2star)
accuracyResid <- resid(accuracyGam)

sesGam <- gam(ses ~ sex, method="REML", data=r2star)
sesResid <- resid(sesGam)

## Standardize independent (X), dependent (Y), and mediating (M) variables
X <- as.data.frame(scale(sesResid))
Y <- as.data.frame(scale(accuracyResid)) 
M <- as.data.frame(scale(caudateResid))

Data <- data.frame(X=X, Y=Y, M=M)
Data <- data.frame(cbind(X,Y,M))
colnames(Data) <- c("X", "Y", "M")

# Set model
model <- ' # direct effect
Y ~ c*X
# mediator
M ~ a*X
Y ~ b*M
# indirect effect (a*b)
ab := a*b
# total effect
total := c + (a*b)
'

# Run on model
fit_sem <- sem(model, data = Data, se="bootstrap", bootstrap=10000)
summary(fit_sem, fit.measures=TRUE, standardize=TRUE, rsquare=TRUE)

## Calculate bootstrapped confidence intervals for the indirect (c') effect
boot.fit <- parameterEstimates(fit_sem, boot.ci.type="perc",level=0.95, ci=TRUE,standardized = TRUE)
boot.fit
