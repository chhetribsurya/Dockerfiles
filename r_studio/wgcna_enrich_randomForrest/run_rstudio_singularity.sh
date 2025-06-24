#!/bin/bash

# ------------------------------------------------------------------------------
# Script: run_rstudio_singularity.sh
# Purpose: Run RStudio Server via Singularity, locally or via SLURM with custom options
# ------------------------------------------------------------------------------

# -------------------- USER DEFAULTS (can be overridden via flags) -------------

DOCKER_IMAGE="docker://chhetribsurya/enrich_wgcna_env_rstudio:1.0"
SIF_FILE="enrich_wgcna_env_rstudio.sif"

RSTUDIO_USER="rstudio"
RSTUDIO_PASSWORD="rstudio"
RSTUDIO_PORT=8787

# Default SLURM options (can be overridden)
SLURM_PARTITION="interactive"
SLURM_CPUS=2
SLURM_MEM="8G"
SLURM_TIME="4:00:00"

# -------------------- FUNCTIONS ------------------------------------------------

pull_image() {
  if [[ ! -f "$SIF_FILE" ]]; then
    echo "📦 Pulling Docker image and converting to Singularity image..."
    singularity pull "$SIF_FILE" "$DOCKER_IMAGE"
  else
    echo "✅ Singularity image already exists: $SIF_FILE"
  fi
}

run_rstudio() {
  echo "🚀 Starting RStudio Server inside Singularity container..."
  singularity exec \
    --cleanenv \
    --bind "$HOME:/home/$RSTUDIO_USER" \
    "$SIF_FILE" \
    bash -c "
      export USER=$RSTUDIO_USER
      export PASSWORD=$RSTUDIO_PASSWORD
      export HOME=/home/$RSTUDIO_USER
      echo '🔐 RStudio login -> user: $RSTUDIO_USER | password: $RSTUDIO_PASSWORD'
      echo '🌐 Visit http://localhost:$RSTUDIO_PORT to access RStudio'
      rserver --server-user $RSTUDIO_USER --www-port $RSTUDIO_PORT \
              --auth-none=0 \
              --auth-pam-helper-path=pam-helper \
              --secure-cookie-key-file=/tmp/rstudio-cookie-key
    "
}

run_with_slurm() {
  echo "🧠 Submitting RStudio session via SLURM..."
  srun --pty \
       --job-name=rstudio_singularity \
       --partition="$SLURM_PARTITION" \
       --cpus-per-task="$SLURM_CPUS" \
       --mem="$SLURM_MEM" \
       --time="$SLURM_TIME" \
       bash -c "$(declare -f run_rstudio); run_rstudio"
}

print_help() {
  cat << EOF
Usage: $0 [--local | --slurm] [SLURM OPTIONS]

Modes:
  --local                 Run RStudio locally (default)
  --slurm                Run using SLURM scheduler

Optional SLURM overrides:
  --partition=<name>      SLURM partition (default: $SLURM_PARTITION)
  --cpus=<int>            Number of CPU cores (default: $SLURM_CPUS)
  --mem=<amount>          Memory (e.g., 8G, 16000M) (default: $SLURM_MEM)
  --time=<HH:MM:SS>       Time limit (default: $SLURM_TIME)

Examples:
  $0 --local
  $0 --slurm --partition=short --cpus=4 --mem=16G --time=02:00:00

EOF
  exit 0
}

# -------------------- PARSE ARGS ------------------------------------------------

MODE="local"
while [[ $# -gt 0 ]]; do
  case $1 in
    --local) MODE="local"; shift ;;
    --slurm) MODE="slurm"; shift ;;
    --partition=*) SLURM_PARTITION="${1#*=}"; shift ;;
    --cpus=*) SLURM_CPUS="${1#*=}"; shift ;;
    --mem=*) SLURM_MEM="${1#*=}"; shift ;;
    --time=*) SLURM_TIME="${1#*=}"; shift ;;
    -h|--help) print_help ;;
    *) echo "❌ Unknown option: $1"; print_help ;;
  esac
done

# -------------------- RUN --------------------------------------------------------

pull_image

if [[ $MODE == "slurm" ]]; then
  run_with_slurm
else
  run_rstudio
fi

# -------------------- USAGE NOTES ------------------------------------------------
: <<'README'

✅ To Use:

Save the script:
  chmod +x run_rstudio_singularity.sh

Run it locally:
  ./run_rstudio_singularity.sh --local

Run it via SLURM (custom options supported):
  ./run_rstudio_singularity.sh --slurm --partition=short --cpus=4 --mem=16G --time=2:00:00

Visit in browser:
  http://localhost:8787

Login with:
  Username: rstudio
  Password: rstudio

📌 Notes:
- You can change the port by editing: RSTUDIO_PORT=8787
- You can change password here: RSTUDIO_PASSWORD="rstudio"
- If you're on a remote HPC system, tunnel port 8787:
    ssh -N -L 8787:localhost:8787 username@your-hpc.edu

README

