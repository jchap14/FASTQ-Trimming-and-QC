#!/bin/bash
##### Trim FASTQs for quality & adaptors. FASTQC output generated also

##### for x in `/bin/ls *.untrimmed.R1.fq.gz` ; do bash TrimGalore.sh $x; done

## add modules
module add trim_galore
module add fastqc

## define variables
read1=`echo $1`
NAME=`basename $1 .untrimmed.R1.fq.gz`

## write a tempscript to be looped over
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.Trim
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

########################################### Trim low quality bases and adaptors from reads
###### note --trim1 option can be used for ATAC-seq data trimming, as it helps with Bowtie
echo "STARTING TRIM_GALORE"
trim_galore -q 25 --paired --fastqc --stringency 1 ./$read1 ./$NAME.untrimmed.R2.fq.gz
echo "change NAMEs to .trim.gz"
mv $NAME.untrimmed.R1_val_1.fq.gz $NAME.trim.R1.fq.gz
mv $NAME.untrimmed.R2_val_2.fq.gz $NAME.trim.R2.fq.gz
echo "Moving trimming reports to ./Trimming_outputs/"
mkdir Trimming_outputs/
mv $NAME.untrimmed.R1.fq.gz_trimming_report.txt ./Trimming_outputs/
mv $NAME.untrimmed.R2.fq.gz_trimming_report.txt ./Trimming_outputs/
echo "Moving FASTQC reports to ./FASTQC/"
mkdir FASTQC/
mv $NAME.untrimmed.R1_val_1_fastqc.html ./FASTQC/
mv $NAME.untrimmed.R2_val_2_fastqc.html ./FASTQC/
EOF

## qsub then remove the tempscript
qsub $NAME.tempscript.sh 
sleep 1
rm $NAME.tempscript.sh
