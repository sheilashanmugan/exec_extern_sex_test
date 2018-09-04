#!/bin/bash

if [ ! -z ${1} ] && echo "Setting file: ${1}"
then
	echo " (at least 1 argument passed to script)"
	echo " "
else
	echo " "
	echo "Usage: FDR correct pos and neg of zstatX. Run in directory with zstat images. Arg 1 is number of zstat "
	echo " "
	echo " "
	exit 1
fi


num=$1


mkdir fdr -p
fslmaths zstat${num}.nii.gz -mul -1 zstat${num}neg.nii.gz 
cd fdr
fslmaths ../zstat${num}.nii.gz -ztop ztop${num}.nii.gz

fdr_th_p=$(fdr -i ztop${num}.nii.gz -m ../mask -q 0.05 | sed -n '2p') 
echo "p thresh for zstat${num}.nii.gz is ${fdr_th_p}"
if [ "${fdr_th_p}" > 0 ]
then
	fdr_th_p_z=$(ptoz ${fdr_th_p})
	fdr_th_p_z_r=$(printf %.2f ${fdr_th_p_z}) 
	fslmaths ../zstat${num}.nii.gz -thr ${fdr_th_p_z_r} zstat${num}_${fdr_th_p_z_r}.nii.gz
	mkdir -p easythresh
	cd easythresh
	easythresh ../../zstat${num}.nii.gz ../../mask.nii.gz ${fdr_th_p_z_r} 1 ../../zstat${num}.nii.gz zstat${num}_${fdr_th_p_z_r}_1
	cat cluster_zstat${num}_${fdr_th_p_z_r}_1.txt
	cd ..
fi


fslmaths ../zstat${num}neg.nii.gz -ztop ztop${num}neg.nii.gz
fdr_th_n=$(fdr -i ztop${num}neg.nii.gz -m ../mask -q 0.05 | sed -n '2p') 
echo "p thresh for zstat${num}neg.nii.gz is ${fdr_th_n}"
if [ "${fdr_th_n}" > 0 ]
then
	fdr_th_n_z=$(ptoz ${fdr_th_n})
	fdr_th_n_z_r=$(printf %.2f ${fdr_th_n_z}) 
	fslmaths ../zstat${num}neg.nii.gz -thr ${fdr_th_n_z_r} zstat${num}neg_${fdr_th_n_z_r}.nii.gz
	mkdir -p easythresh
	cd easythresh
	easythresh ../../zstat${num}neg.nii.gz ../../mask.nii.gz ${fdr_th_n_z_r} 1 ../../zstat${num}neg.nii.gz zstat${num}neg_${fdr_th_n_z_r}_1
	cat cluster_zstat${num}neg_${fdr_th_n_z_r}_1.txt	
	cd ..
fi


