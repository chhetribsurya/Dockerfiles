#!/bin/bash
#SBATCH --job-name=run_fragle
#SBATCH --mem=16G
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=ALL
#SBATCH --output=%j-run_fragle.out
#SBATCH --error=%j-run_fragle.err
#SBATCH --time=02:00:00  # Set the time limit (2 Hours)

# ======= LOAD SINGULARITY MODULE =======
module load singularity/3.7.0

# ======= DEFAULT CONFIGURATION =======
INPUT_FOLDER="/data/baca/projects/SNAP/FRAGLE/InputTest"
OUTPUT_FOLDER="/data/baca/projects/SNAP/FRAGLE/OutputTest"
CPU=$SLURM_CPUS_PER_TASK
DOCKER_IMAGE="docker://prc992/snap-fragle:v1"

# ======= INFORMATION MESSAGE =======
echo "Running Fragle with the following parameters:"
echo "  Input folder   : $INPUT_FOLDER"
echo "  Output folder  : $OUTPUT_FOLDER"
echo "  CPUs           : $CPU"
echo "  Singularity image (from Docker Hub) : $DOCKER_IMAGE"
echo

# ======= SINGULARITY COMMAND =======
singularity exec \
  --pwd /usr/src/app \
  --bind "$INPUT_FOLDER":/mnt/I_Folder \
  --bind "$OUTPUT_FOLDER":/mnt/O_Folder \
  "$DOCKER_IMAGE" \
  python /usr/src/app/main.py --input /mnt/I_Folder --output /mnt/O_Folder --mode R --cpu "$CPU" --threads "$CPU"