########PARAMETERS
subj.data <- read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n939_from1601_oldImgPaths_20180829.csv")


###ALL COVARIATES
variables<-c( "sex1m1", "fedu1", "ageInYears", "nbackRelMeanRMSMotion") 
lin.mod<-"~   sex1m1*fedu1 + sex1m1 + fedu1 + ageInYears + nbackRelMeanRMSMotion" 
int <- "sexXfedu"
###


#image.exclude<-"nback_excluded"  #imaging exclusion criteria
img<-"cope.path.2m0"  #this is the column in the RDS where have 
imgvc<-"varcope.path.2m0"
mask<-"/data/jux/BBL/projects/exec_extern_sex/oldData/n971_frac2back_across_mask.nii.gz" #copied from 
outroot<-"/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses"
smoothing<-0
##############


#data16<- subset(subj.data, sex1m1 == "-1")
data16 <- subj.data
data16$ageInYears_demean <- (data16$ageInYears - mean(data16$ageInYears))
data16$sex1m1_demean <- (data16$sex1m1 - mean(data16$sex1m1))
data16$medu1_demean <- (data16$medu1 - mean(data16$medu1))
data16$fedu1_demean <- (data16$fedu1 - mean(data16$fedu1))
data16$nbackRelMeanRMSMotion_demean <- (data16$nbackRelMeanRMSMotion - mean(data16$nbackRelMeanRMSMotion))
data16$nbackBehAllDprime_demean <- (data16$nbackBehAllDprime - mean(data16$nbackBehAllDprime))

cols<-c("bblid",variables,img,imgvc)

#cat("subsetting data by",subject.include,'\n')
data.subset <-data16[,cols] 



#check that all cases complete
numsubj<-dim(data.subset)[1]
numcomplete<-sum(complete.cases(data.subset))

if (numcomplete != numsubj){
  cat("some data is missing!","\n")
  numsubj<-numcomplete
  data.subset<-data.subset[complete.cases(data.subset),]
} else {
  cat("all subjects have complete data","\n")
}

#get naming for and create output directory
subjcount<-paste("n",numsubj,sep="")
outname<-paste(subjcount,img,sep="_")

outdir<-paste(outroot,outname,sep="/")  #outdir is the base directory where the mask and 4d image are saved; these are model-invariant
if (smoothing>0){
  outdir<-paste(outdir,"smooth",smoothing,sep="_")
}
variables_collapsed<-paste(variables,collapse="_")
resultsdir<-paste(outdir,paste(int,variables_collapsed,sep="_"),sep="/")    #resutls dir is the subdirectory where the model and stats are saved; this can vary by model chosen
dir.create(outdir)
dir.create(resultsdir)
setwd(resultsdir)


#write out image and subject list to output directory for logging
bblid.list<-data.subset$bblid
image.list<-data.subset[[img]]
write.table(bblid.list,"bblids.txt",col.names=FALSE,row.names=FALSE,quote=FALSE)
write.table(image.list,"images.txt",col.names=FALSE,row.names=FALSE,quote=FALSE)

image.list.varcope<-data.subset[[imgvc]]
write.table(image.list.varcope,"images.varcope.txt",col.names=FALSE,row.names=FALSE,quote=FALSE)

## CREATE FSL DESIGN FILES ##
#############################
file<-resultsdir  #to be consistent w/ prior naming  #note this will put all files into resultsdir; copy certain ones like bblids, images, 4d file, mask back up
# design matrix is X
cat("\n","output directory is ",file,"\n")

X<-model.matrix(as.formula(lin.mod) , data=data.subset)
#suppressWarnings(X<-cbind(X, c(0,1))) # c(0,1) gets recycled truncated for odd number of rows.

# peak to peak heights. Don't think this is used for group analyses.
# ppheights<-apply(X,2,function(x) range(x)[2]-range(x)[1])


### CREATE DESIGN.MAT FILE ###
##############################
filet=file.path(file, 'design.mat')
cat('/NumWaves\t', (ncol(X)), '\n', sep='', append=F, file=filet)
cat('/NumPoints\t', (nrow(X)), '\n', sep='', append=T, file=filet)
#cat('/PPheights\t', ppheights, '\n\n', sep='\t', append=T, file=filet)
cat('/Matrix\n', sep='', append=T, file=filet)
write.table(X, row.names=F, col.names=F, append=T, file=filet)

###  CREATE THE CONTRASTS FILE ###
##################################
# diagonal contrast matrix. you would
# need to edit this if you had factors
# with more than 2 levels.
filet=file.path(file, 'design.con')
cat('/ContrastName1','\t',colnames(X)[1],'\n',append=F,file=filet,sep="")
for (i in seq(2,ncol(X))){
  cat('/ContrastName',i,'\t',colnames(X)[i],'\n',append=T,file=filet,sep="")
}
cat('/NumWaves\t', ncol(X), '\n', sep='', append=T, file=filet) # ifelse(is.na(gmc) | gmc==0, ncol(X), (ncol(X)+1))
cat('/NumContrasts\t', ncol(X), '\n', sep='', append=T, file=filet)
cat('/PPheights\t', paste(rep(1, ncol(X)),collapse='\t'), '\n\n', sep='', append=T, file=filet)
cat('/Matrix\n', sep='', append=T, file=filet)
write.table(diag(rep(1, ncol(X))) , row.names=F, col.names=F, append=T, file=filet)

### CREATE THE FTEST FILE ###
#############################
# diagonal contrast matrix, except the intercept.
filet=file.path(file, 'design.fts')
cat('/NumWaves\t', ncol(X), '\n', sep='', append=F, file=filet)
cat('/NumContrasts\t', (ncol(X)-1), '\n\n', sep='', append=T, file=filet)
cat('/Matrix\n', sep='', append=T, file=filet)
write.table(cbind(0,diag(rep(1, (ncol(X)-1) ))), row.names=F, col.names=F, append=T, file=filet)

### CREATE GRP FILE ###
#######################
# all the same group. Would have to modify this
# for more unequal group variances.
filet=file.path(file, 'design.grp')
cat('/NumWaves\t1\n', sep='', append=F, file=filet)
cat('/NumPoints\t', nrow(X), '\n', sep='', append=T, file=filet)
cat('/Matrix\n', sep='', append=T, file=filet)
cat(rep(1,nrow(X)),sep='\n', append=T, file=filet)

### COPY MASK AND THIS PROGRAM TO OUTPUT DIRECTORY ###
#######################
file.copy("/data/jux/BBL/projects/exec_extern_sex/scripts/group_analysis/group_analysis_age_sexXmfedu_20180902.R",resultsdir)
maskout<-paste(resultsdir,"mask.nii.gz",sep="/")
file.copy(mask,maskout)


### MERGE TO 4D FILE ###
#######################
merge.check<-Sys.glob("../fourdVarcope.nii.gz")
if (length(merge.check)>0){
  cat("\n","merged images present","\n")
  file.copy("../fourd.nii.gz",resultsdir)
  file.copy("../fourdVarcope.nii.gz",resultsdir)
} else {
  cat("\n", "now merging cope images","\n")
  system("fslmerge -t fourd $(cat images.txt)")
  
  cat("\n","now merging varcope images", "\n")
  system("fslmerge -t fourdVarcope $(cat images.varcope.txt)")
}

cat("\n", "now running flameo","\n")

system("flameo --cope=fourd.nii.gz --mask=mask.nii.gz --dm=design.mat --tc=design.con --cs=design.grp  --runmode=flame1 --varcope=fourdVarcope.nii.gz --ld=logdir")

#move general files back to higher level
system("mv mask.nii.gz ..")
system("mv fourd.nii.gz ..")
system("mv bblids.txt ..")
system("mv images.txt ..")

system("mv fourdVarcope.nii.gz ..")
system("mv images.varcope.txt ..")

#move images from logdir to resutlsdir
system("cp logdir/* .")
system("rm -rf logdir*")
