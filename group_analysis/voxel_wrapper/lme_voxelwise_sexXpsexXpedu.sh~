

subjDataName="/data/jux/BBL/projects/exec_extern_sex/inputData/data_agg/nback_n939_from1601_oldImgPaths_pedumelt_20180905.rds"
OutDirRoot="/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/voxel_wrapper/testScript"
namePaths="cope.path.2m0"
maskName="/data/jux/BBL/projects/exec_extern_sex/oldData/n971_frac2back_across_mask.nii.gz"
smooth=0
inclusionName="categorical_include"
subjID="bblid"
covsFormula="~sex1m1*psex*peduYearsDemean+ageInYearsDemean+nbackRelMeanRMSMotionDemean"
randomFormula="~(1|bblid)"
ncores=10
logfile="/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/voxel_wrapper/testScript/logs"
errfile="/data/jux/BBL/projects/exec_extern_sex/results/nback/voxelwise_analyses/voxel_wrapper/testScript/logs"

qsub -V -S /share/apps/R/R-3.1.1/bin/Rscript -cwd -o ${logfile} -e ${errfile} -binding linear:10 -pe unihost 10 -l h_vmem=6.5G,s_vmem=6.0G /data/joy/BBL/applications/groupAnalysis/gamm4_voxelwise.R -c $subjDataName -o $OutDirRoot -p $namePaths -m $maskName -i $inclusionName -u $subjID -f $covsFormula -e $randomFormula -n 10 -s 0

#qsub -V -S /share/apps/R/R-3.1.1/bin/Rscript -cwd -o ${logfile} -e ${errfile} -binding linear:10 -pe unihost 10 -l h_vmem=6.5G,s_vmem=6.0G /data/joy/BBL/applications/groupAnalysis/gamm4_voxelwise.R -c $subjDataName -o $OutDirRoot -p $namePaths -m $maskName -s 0 -i $inclusionName -u $subjID -f $covsFormula -a none -k 10 -n 10 -r $randomFormula -n 10 -s 0
