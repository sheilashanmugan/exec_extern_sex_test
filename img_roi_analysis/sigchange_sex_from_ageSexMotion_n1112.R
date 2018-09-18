subj.data <- read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1112_from1601_newImgPaths_20180910.csv")


mask1 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/cluster_mask_zstat3_309_1_LPrecentral.nii.gz"
mask2 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/cluster_mask_zstat3_309_1_RMFG.nii.gz"
mask3 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/cluster_mask_zstat3_309_1_RPrecentral.nii.gz"
mask4 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/cluster_mask_zstat3_309neg_1_Precuneous.nii.gz"
mask5 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/cluster_mask_zstat3neg_309_1_LCerebellum.nii.gz"
mask6 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/cluster_mask_zstat3neg_309_1_RDLPFC.nii.gz"
mask7 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/cluster_mask_zstat3neg_309_1_RSFG.nii.gz"
mask8 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/fdr/easythresh/cluster_mask_zstat3_3.19_1_bin.nii.gz"
mask9 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/fdr/easythresh/cluster_mask_zstat3neg_2.71_1_bin.nii.gz"



output.mat<-matrix(0,1021,12)
output.mat<-data.frame(output.mat)
f2b.copes <- subj.data$sigchange.path.2m0

for (i in 1:length(f2b.copes)){
  print(f2b.copes[i])
  cope.name <- f2b.copes[i]
  output.mat[i,1] <- subj.data[i,2]
  system(paste("fslmaths",cope.name,"-mas",mask1,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,2]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask2,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,3]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask3,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,4]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask4,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,5]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask5,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,6]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask6,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,7]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask7,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,8]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask8,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,9]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask9,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslstats /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -M > /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,10]<- output[1,1]
}



colnames(output.mat)<- c("bblid", "LPrecentral", "RMfg", "RPrecentral", "Precuneous", "LCerebellum", "RDlpfc", "RSfg", "allpos", "allneg")

write.table(output.mat,file="/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1112_cope.path.2m0/ageInYears_sex01_nbackRelMeanRMSMotion/easythresh/clusters_fslmeants.csv",row.names=FALSE ,col.names=TRUE ,sep=",")
