#!/bin/bash

## run command:
## for x in `/bin/ls *q.gz` ; do bash fastqc.sh $x; done

## set variable names
FASTQfile=`echo $1`
NAME=`basename $1 .fq.gz`

## add required modules
# module add fastqc #managed by conda

cat > $NAME.tempscript.sh << EOF
#!/bin/bash -l
#SBATCH --job-name $NAME.fastqc
#SBATCH --output=$NAME.fastqc.out
#SBATCH --mail-user jchap14@stanford.edu
#SBATCH --mail-type=ALL
# Request run time & memory
#SBATCH --time=5:00:00
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL
#SBATCH --account=mpsnyder

echo "STARTING fastqc"
fastqc ./$FASTQfile
# rm "$(echo $NAME)_fastqc.zip"
EOF

## qsub then remove the tempscript
sbatch $NAME.tempscript.sh #scg
sleep 1
rm $NAME.tempscript.sh
