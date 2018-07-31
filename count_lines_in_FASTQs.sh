#!/bin/bash

## run command:
## for x in `/bin/ls *q.gz` ; do bash count_lines_in_FASTQs.sh $x; done

## set variable names
FASTQfile=`echo $1`
NAME=`basename $1 .fastq.gz`

## add required modules
# module add fastqc

cat > $NAME.tempscript.sh << EOF
#!/bin/bash -l
#SBATCH --job-name $NAME.motifsFromBed
#SBATCH --output=$NAME.motifsFromBed.out
#SBATCH --mail-user jchap14@stanford.edu
#SBATCH --mail-type=ALL
# Request run time & memory
#SBATCH --time=5:00:00
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL
#SBATCH --account=mpsnyder

##### Run commands:
echo "STARTING fastqc"
fastqc ./$FASTQfile
rm "$(echo $name)_fastqc.zip"
EOF

## qsub then remove the tempscript & useless zipfile
qsub $name.tempscript.sh 
sleep 1
rm $name.tempscript.sh
