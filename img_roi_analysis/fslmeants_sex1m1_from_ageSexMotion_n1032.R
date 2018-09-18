subj.data <- read.csv("/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n1032_from1601_oldImgPaths_20180829.csv")


mask1 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1032_cope.path.2m0/ageInYears_sex1m1_nbackRelMeanRMSMotion/fdr/easythresh/zstat3_2.69_1_precuneous.nii.gz"
mask2 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1032_cope.path.2m0/ageInYears_sex1m1_nbackRelMeanRMSMotion/fdr/easythresh/zstat3_2.69_1_RParietal.nii.gz"
mask3 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1032_cope.path.2m0/ageInYears_sex1m1_nbackRelMeanRMSMotion/fdr/easythresh/zstat3_2.69_1_RDlpfc.nii.gz"
mask4 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1032_cope.path.2m0/ageInYears_sex1m1_nbackRelMeanRMSMotion/fdr/easythresh/zstat3_2.69_1_LParietal.nii.gz"
mask5 <- "/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1032_cope.path.2m0/ageInYears_sex1m1_nbackRelMeanRMSMotion/fdr/easythresh/cluster_mask_zstat3_2.69_1_bin.nii.gz"


output.mat<-matrix(0,1021,5)
output.mat<-data.frame(output.mat)
f2b.copes <- subj.data$cope.path.2m0

for (i in 1:length(f2b.copes)){
  print(f2b.copes[i])
  cope.name <- f2b.copes[i]
  output.mat[i,1] <- subj.data[i,2]
  system(paste("fslmaths",cope.name,"-mas",mask1,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslmeants -i /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -o /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,2]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask2,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslmeants -i /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -o /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,3]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask3,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslmeants -i /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -o /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,4]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask4,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslmeants -i /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -o /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,5]<- output[1,1]
  system(paste("fslmaths",cope.name,"-mas",mask5,"/data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz",sep=" "))
  system(paste("fslmeants -i /data/jux/BBL/projects/exec_extern_sex/tmp/zstatmasked.nii.gz -o /data/jux/BBL/projects/exec_extern_sex/tmp/output"))
  output<-read.table("/data/jux/BBL/projects/exec_extern_sex/tmp/output")
  output.mat[i,5]<- output[1,1]
}



colnames(output.mat)<- c("bblid", "precuneous", "RParietal", "RDlpfc", "Lpariental", "allClusters")

write.table(output.mat,file="/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/n1032_cope.path.2m0/ageInYears_sex1m1_nbackRelMeanRMSMotion/fdr/easythresh/clusters_fslmeants.csv",row.names=FALSE ,col.names=TRUE ,sep=",")
