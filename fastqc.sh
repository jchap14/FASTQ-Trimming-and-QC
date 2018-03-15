#!/bin/bash

## run command:
## for x in `/bin/ls *.R1.fq.gz` ; do bash fastqc.sh $x; done

## set variable names
FASTQfile=`echo $1`
name=`basename $1 .fq.gz`

## add required modules
module add fastqc

cat > $name.tempscript.sh << EOF
#!/bin/bash
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00
#$ -N $name.fastQC

echo "STARTING fastqc"
fastqc ./$FASTQfile
rm "$(echo $name)_fastqc.zip"
EOF

## qsub then remove the tempscript & useless zipfile
qsub $name.tempscript.sh 
sleep 1
rm $name.tempscript.sh
