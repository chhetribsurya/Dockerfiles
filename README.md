# Bioinformatics Docker Containers for HPC Environments

A comprehensive collection of Docker containers designed for bioinformatics analysis workflows, optimized for both local development and High-Performance Computing (HPC) environments using Docker and Singularity.

## 📋 Table of Contents

- [Overview](#overview)
- [Container Types](#container-types)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Usage](#detailed-usage)
  - [Base Python Environment](#base-python-environment)
  - [R Environment](#r-environment)
  - [Genomic Annotation Environment](#genomic-annotation-environment)
  - [RStudio Environments](#rstudio-environments)
  - [WGCNA Enrichment Environment](#wgcna-enrichment-environment)
  - [FRAGLE Environment](#fragle-environment)
- [HPC Usage with Singularity](#hpc-usage-with-singularity)
- [Advanced Configuration](#advanced-configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🎯 Overview

This repository contains specialized Docker containers for bioinformatics analysis:

- **Base Python Environment**: Core Python packages for data analysis
- **R Environment**: Basic R with essential packages
- **Genomic Annotation Environment**: R-based genomic annotation tools
- **RStudio Environments**: Interactive RStudio servers for analysis
- **WGCNA Enrichment Environment**: Gene co-expression and enrichment analysis
- **FRAGLE Environment**: Fragment Length Analysis for genomic data

All containers are designed to work seamlessly with both Docker and Singularity, making them ideal for HPC environments.

## 🐳 Container Types

| Container | Purpose | Base Image | Key Packages |
|-----------|---------|------------|--------------|
| `base_python` | Data analysis | Python 3.9 | pandas, numpy, matplotlib, seaborn, scipy |
| `r_dockerfile` | Basic R analysis | Bioconductor R 4.3.2 | readr, dplyr, BiocManager |
| `genomic_annotation` | Genomic annotation | Bioconductor R 4.3.2 | ChIPseeker, GenomicRanges, AnnotationDbi |
| `enrich_env_rstudio` | Interactive enrichment analysis | RStudio 4.3.1 | clusterProfiler, org.Hs.eg.db, enrichplot |
| `wgcna_enrich_randomForrest` | WGCNA + Random Forest | RStudio 4.3.1 | WGCNA, randomForest, clusterProfiler |
| `wgcna_enrich` | Command-line enrichment | R 4.3.1 | clusterProfiler, WGCNA, enrichment tools |
| `fragle` | Fragment Length Analysis | Python-based | SNAP-FRAGLE, fragment analysis tools |

## 📋 Prerequisites

### For Docker Usage
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (optional)
sudo usermod -aG docker $USER
```

### For Singularity Usage (HPC)
```bash
# Check if Singularity is available
singularity --version

# If not available, contact your HPC administrator
```

### For SLURM Usage (HPC)
```bash
# Check SLURM availability
sinfo

# Check your partitions
sinfo -s
```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd dockerfiles
```

### 2. Build All Containers
```bash
# Build base Python container
docker build -t base_python:latest base_python/

# Build R container
docker build -t r_env:latest r_dockerfile/

# Build genomic annotation container
docker build -t genomic_annotation:latest genomic_annotation/

# Build RStudio containers
docker build -t enrich_env_rstudio:latest r_studio/enrich_env_rstudio/
docker build -t wgcna_enrich_rstudio:latest r_studio/wgcna_enrich_randomForrest/

# Build WGCNA enrichment container
docker build -t wgcna_enrich:latest wgcna_enrich/

# Pull FRAGLE container (pre-built)
docker pull prc992/snap-fragle:v1
```

### 3. Run Your First Container
```bash
# Run Python container
docker run --rm -it base_python:latest python -c "import pandas; print('Hello from pandas!')"

# Run R container
docker run --rm -it r_env:latest R -e "library(dplyr); print('Hello from dplyr!')"

# Test FRAGLE container
docker run --rm -it prc992/snap-fragle:v1 python -c "print('FRAGLE container ready!')"
```

## 📖 Detailed Usage

### Base Python Environment

**Purpose**: Core Python environment for data analysis and visualization.

**Key Features**:
- Python 3.9
- pandas 1.5.3
- numpy 1.23.5
- matplotlib 3.7.0
- seaborn 0.12.2
- scipy 1.10.0

#### Docker Usage
```bash
# Build the container
docker build -t base_python:latest base_python/

# Run interactive Python session
docker run --rm -it -v "$PWD:/workspace" -w /workspace base_python:latest python

# Run a Python script
docker run --rm -v "$PWD:/workspace" -w /workspace base_python:latest python your_script.py

# Run Jupyter notebook (if needed)
docker run --rm -it -p 8888:8888 -v "$PWD:/workspace" -w /workspace base_python:latest \
  pip install jupyter && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

#### Singularity Usage (HPC)
```bash
# Pull the container
singularity pull base_python.sif docker://your-registry/base_python:latest

# Run Python script
singularity exec base_python.sif python your_script.py

# Interactive session
singularity shell base_python.sif
```

### R Environment

**Purpose**: Basic R environment with essential packages for data manipulation.

**Key Features**:
- R 4.3.2 (Bioconductor)
- readr, dplyr
- BiocManager 3.18
- rtracklayer, GenomicRanges, AnnotationDbi

#### Docker Usage
```bash
# Build the container
docker build -t r_env:latest r_dockerfile/

# Run R script
docker run --rm -v "$PWD:/workspace" -w /workspace r_env:latest Rscript your_script.R

# Interactive R session
docker run --rm -it -v "$PWD:/workspace" -w /workspace r_env:latest R

# Run with specific R command
docker run --rm -v "$PWD:/workspace" -w /workspace r_env:latest \
  R -e "library(dplyr); library(readr); print('R environment ready!')"
```

#### Singularity Usage (HPC)
```bash
# Pull the container
singularity pull r_env.sif docker://your-registry/r_env:latest

# Run R script
singularity exec r_env.sif Rscript your_script.R

# Interactive session
singularity shell r_env.sif
```

### Genomic Annotation Environment

**Purpose**: Specialized R environment for genomic annotation and analysis.

**Key Features**:
- R 4.3.2 (Bioconductor)
- ChIPseeker for ChIP-seq analysis
- GenomicRanges for genomic data manipulation
- AnnotationDbi for annotation databases
- org.Hs.eg.db for human gene annotations

#### Docker Usage
```bash
# Build the container
docker build -t genomic_annotation:latest genomic_annotation/

# Run annotation script
docker run --rm -v "$PWD:/workspace" -w /workspace genomic_annotation:latest \
  Rscript annotation_script.R

# Interactive session with genomic tools
docker run --rm -it -v "$PWD:/workspace" -w /workspace genomic_annotation:latest R
```

#### Example Annotation Script
```r
# Load required libraries
library(ChIPseeker)
library(GenomicRanges)
library(AnnotationDbi)
library(org.Hs.eg.db)

# Example: Annotate peaks
peaks <- readPeakFile("your_peaks.bed")
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
peakAnno <- annotatePeak(peaks, TxDb=txdb, annoDb="org.Hs.eg.db")
```

### RStudio Environments

#### Enrichment Analysis RStudio

**Purpose**: Interactive RStudio environment for gene enrichment analysis.

**Key Features**:
- RStudio Server 4.3.1
- clusterProfiler for GO/KEGG enrichment
- org.Hs.eg.db for human annotations
- enrichplot for visualization
- gprofiler2 for additional enrichment

#### Docker Usage
```bash
# Build the container
docker build -t enrich_env_rstudio:latest r_studio/enrich_env_rstudio/

# Run RStudio server
docker run -d --rm \
  -e PASSWORD=your_password \
  -p 8787:8787 \
  -v "$PWD:/home/rstudio/workspace" \
  enrich_env_rstudio:latest

# Access at http://localhost:8787
# Username: rstudio
# Password: your_password
```

#### WGCNA + Random Forest RStudio

**Purpose**: Advanced RStudio environment for gene co-expression and machine learning.

**Key Features**:
- RStudio Server 4.3.1
- WGCNA for gene co-expression analysis
- randomForest for machine learning
- clusterProfiler for enrichment
- Additional visualization packages

#### Docker Usage
```bash
# Build the container
docker build -t wgcna_enrich_rstudio:latest r_studio/wgcna_enrich_randomForrest/

# Run RStudio server
docker run -d --rm \
  -e PASSWORD=your_password \
  -p 8788:8787 \
  -v "$PWD:/home/rstudio/workspace" \
  wgcna_enrich_rstudio:latest

# Access at http://localhost:8788
# Username: rstudio
# Password: your_password
```

### WGCNA Enrichment Environment

**Purpose**: Command-line environment for automated gene co-expression and enrichment analysis.

**Key Features**:
- R 4.3.1
- WGCNA for co-expression analysis
- clusterProfiler for enrichment
- Automated analysis pipeline

#### Docker Usage
```bash
# Build the container
docker build -t wgcna_enrich:latest wgcna_enrich/

# Run enrichment analysis
docker run --rm \
  -v "$PWD/data:/analysis/data" \
  -v "$PWD/run_enrichment.R:/analysis/run_enrichment.R" \
  wgcna_enrich:latest Rscript /analysis/run_enrichment.R

# Interactive R session
docker run --rm -it \
  -v "$PWD:/analysis" \
  -w /analysis \
  wgcna_enrich:latest R
```

#### Example Data Structure
```
data/
├── wgcna_modules_results.rds    # WGCNA results
├── enrichment_analysis_results/ # Output directory
│   ├── GO_enrichment_*.csv      # GO enrichment results
│   ├── HP_enrichment_*.csv      # Human phenotype results
│   ├── GO_plot_*.pdf           # GO enrichment plots
│   └── HP_plot_*.pdf           # HP enrichment plots
└── significant_genes/           # Gene lists
    └── significant_genes_*.csv
```

### FRAGLE Environment

**Purpose**: Fragment Length Analysis for genomic data using the SNAP-FRAGLE tool.

**Key Features**:
- Python-based fragment analysis
- SNAP-FRAGLE for comprehensive fragment length analysis
- Optimized for HPC environments with SLURM
- Multi-threaded processing support
- Automated input/output folder management

#### Docker Usage
```bash
# Pull the SNAP-FRAGLE Docker image
docker pull prc992/snap-fragle:v1

# Run FRAGLE analysis
docker run --rm \
  -v "$PWD/input:/mnt/I_Folder" \
  -v "$PWD/output:/mnt/O_Folder" \
  prc992/snap-fragle:v1 \
  python /usr/src/app/main.py \
    --input /mnt/I_Folder \
    --output /mnt/O_Folder \
    --mode R \
    --cpu 8 \
    --threads 8

# Interactive Python session
docker run --rm -it \
  -v "$PWD:/workspace" \
  -w /workspace \
  prc992/snap-fragle:v1 python
```

#### Singularity Usage (HPC)
```bash
# Pull the container as Singularity image
singularity pull fragle.sif docker://prc992/snap-fragle:v1

# Run FRAGLE analysis
singularity exec \
  --pwd /usr/src/app \
  --bind "$PWD/input:/mnt/I_Folder" \
  --bind "$PWD/output:/mnt/O_Folder" \
  fragle.sif \
  python /usr/src/app/main.py \
    --input /mnt/I_Folder \
    --output /mnt/O_Folder \
    --mode R \
    --cpu 8 \
    --threads 8
```

#### SLURM Job Submission

The repository includes a pre-configured SLURM job script (`fragle/run_fragle.sh`) for easy HPC deployment:

```bash
# Make the script executable
chmod +x fragle/run_fragle.sh

# Submit the job
sbatch fragle/run_fragle.sh

# Or submit with custom parameters
sbatch --partition=compute --mem=32G --cpus-per-task=16 fragle/run_fragle.sh
```

#### Customizing the FRAGLE Job Script

You can modify the `fragle/run_fragle.sh` script to suit your specific needs:

```bash
# Edit the configuration section
INPUT_FOLDER="/path/to/your/input/data"
OUTPUT_FOLDER="/path/to/your/output/directory"
CPU=$SLURM_CPUS_PER_TASK  # Uses SLURM allocation
DOCKER_IMAGE="docker://prc992/snap-fragle:v1"

# The script automatically:
# - Loads Singularity module
# - Sets up input/output bindings
# - Runs FRAGLE with optimal parameters
# - Provides detailed logging
```

#### Example Data Structure
```
input/
├── sample1.bam          # Input BAM files
├── sample2.bam
└── sample3.bam

output/
├── fragment_lengths/    # Fragment length analysis results
├── quality_metrics/     # Quality assessment files
└── reports/            # Analysis reports
```

#### FRAGLE Parameters

The tool supports various parameters for customization:

- `--input`: Input folder containing BAM files
- `--output`: Output folder for results
- `--mode`: Analysis mode (R for regular analysis)
- `--cpu`: Number of CPU cores to use
- `--threads`: Number of threads for processing

#### Monitoring and Logs

```bash
# Check job status
squeue -u $USER

# Monitor job logs
tail -f slurm-*.out
tail -f slurm-*.err

# Check resource usage
seff <job_id>
```

## 🖥️ HPC Usage with Singularity

### Running Containers with Singularity

Singularity supports two main approaches for running containers:

#### 1. Direct Docker URI (Recommended for Quick Testing)

Singularity can run Docker images directly without converting them to `.sif` files first. This is convenient for quick testing and development:

```bash
# Run directly from Docker Hub (no .sif file needed)
singularity exec docker://prc992/snap-fragle:v1 python -c "print('Hello from FRAGLE!')"

# Run with volume mounting
singularity exec \
  --bind "$PWD/input:/mnt/I_Folder" \
  --bind "$PWD/output:/mnt/O_Folder" \
  docker://prc992/snap-fragle:v1 \
  python /usr/src/app/main.py --input /mnt/I_Folder --output /mnt/O_Folder

# Run R container directly
singularity exec docker://your-registry/r_env:latest R -e "print('Hello from R!')"

# Run Python container directly
singularity exec docker://your-registry/base_python:latest python -c "import pandas; print('Hello from pandas!')"
```

**Advantages of Direct Docker URI:**
- No need to download and store `.sif` files
- Always uses the latest version from Docker Hub
- Saves disk space
- Faster setup for testing

**Disadvantages:**
- Requires internet connection for each run
- Slower startup time (downloads image each time)
- May fail if Docker Hub is unavailable
- Not suitable for offline HPC environments

#### 2. Converted Singularity Images (.sif files)

For production HPC environments, it's recommended to convert Docker images to Singularity format:

```bash
# Pull Docker images as Singularity images
singularity pull base_python.sif docker://your-registry/base_python:latest
singularity pull r_env.sif docker://your-registry/r_env:latest
singularity pull genomic_annotation.sif docker://your-registry/genomic_annotation:latest
singularity pull enrich_rstudio.sif docker://your-registry/enrich_env_rstudio:latest
singularity pull wgcna_rstudio.sif docker://your-registry/wgcna_enrich_rstudio:latest
singularity pull wgcna_enrich.sif docker://your-registry/wgcna_enrich:latest
singularity pull fragle.sif docker://prc992/snap-fragle:v1

# Run using .sif files
singularity exec base_python.sif python your_script.py
singularity exec r_env.sif Rscript your_script.R
singularity exec fragle.sif python /usr/src/app/main.py
```

**Advantages of .sif files:**
- Faster startup time
- Works offline (no internet required)
- More reliable for production environments
- Better performance
- Version control (specific image versions)

**Disadvantages:**
- Requires initial download and storage space
- Need to manually update when new versions are available

### When to Use Each Approach

| Use Case | Recommended Approach | Reason |
|----------|---------------------|---------|
| Quick testing/development | Direct Docker URI | Fast setup, no storage needed |
| Production HPC jobs | .sif files | Reliability, performance |
| Offline environments | .sif files | No internet dependency |
| Frequent image updates | Direct Docker URI | Always latest version |
| Large-scale batch processing | .sif files | Consistent performance |

### Setting Up Singularity Images

For production environments, convert your Docker images to Singularity format:

```bash
# Pull Docker images as Singularity images
singularity pull base_python.sif docker://your-registry/base_python:latest
singularity pull r_env.sif docker://your-registry/r_env:latest
singularity pull genomic_annotation.sif docker://your-registry/genomic_annotation:latest
singularity pull enrich_rstudio.sif docker://your-registry/enrich_env_rstudio:latest
singularity pull wgcna_rstudio.sif docker://your-registry/wgcna_enrich_rstudio:latest
singularity pull wgcna_enrich.sif docker://your-registry/wgcna_enrich:latest
singularity pull fragle.sif docker://prc992/snap-fragle:v1
```

### Running RStudio on HPC

#### Using the Provided Scripts

The repository includes automated scripts for running RStudio with Singularity:

```bash
# Make scripts executable
chmod +x r_studio/enrich_env_rstudio/run_rstudio_singularity_withlog_v2.sh
chmod +x r_studio/wgcna_enrich_randomForrest/run_rstudio_singularity_withlog_v2.sh

# Run locally
./r_studio/enrich_env_rstudio/run_rstudio_singularity_withlog_v2.sh --local

# Run via SLURM
./r_studio/enrich_env_rstudio/run_rstudio_singularity_withlog_v2.sh --slurm \
  --partition=interactive --cpus=4 --mem=16G --time=04:00:00
```

#### Manual SLURM Submission

```bash
#!/bin/bash
#SBATCH --job-name=rstudio_singularity
#SBATCH --partition=interactive
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=rstudio_%j.out
#SBATCH --error=rstudio_%j.err

# Load Singularity module (if needed)
module load singularity

# Set up environment
export USER=rstudio
export PASSWORD=rstudio
export PORT=8787

# Run RStudio (using .sif file for production)
singularity exec \
  --cleanenv \
  --bind "$HOME:/home/$USER" \
  enrich_rstudio.sif \
  bash -c "
    export USER=$USER
    export PASSWORD=$PASSWORD
    export HOME=/home/$USER
    rserver --server-user \$USER \
            --www-port $PORT \
            --auth-none=0 \
            --auth-pam-helper-path=pam-helper \
            --secure-cookie-key-file=/tmp/rstudio-cookie-key
  "
```

### SSH Tunneling for Remote Access

```bash
# Create SSH tunnel to access RStudio
ssh -N -L 8787:localhost:8787 username@your-hpc-cluster.edu

# Then access RStudio at http://localhost:8787
```

### Batch Processing with SLURM

#### Python Analysis Job
```bash
#!/bin/bash
#SBATCH --job-name=python_analysis
#SBATCH --partition=compute
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=python_%j.out
#SBATCH --error=python_%j.err

# Load modules
module load singularity

# Run Python analysis (using .sif file for production)
singularity exec base_python.sif python your_analysis_script.py

# Alternative: Run directly from Docker URI (for testing)
# singularity exec docker://your-registry/base_python:latest python your_analysis_script.py
```

#### R Analysis Job
```bash
#!/bin/bash
#SBATCH --job-name=r_analysis
#SBATCH --partition=compute
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=r_%j.out
#SBATCH --error=r_%j.err

# Load modules
module load singularity

# Run R analysis (using .sif file for production)
singularity exec r_env.sif Rscript your_r_script.R

# Alternative: Run directly from Docker URI (for testing)
# singularity exec docker://your-registry/r_env:latest Rscript your_r_script.R
```

#### WGCNA Enrichment Job
```bash
#!/bin/bash
#SBATCH --job-name=wgcna_enrichment
#SBATCH --partition=compute
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --output=wgcna_%j.out
#SBATCH --error=wgcna_%j.err

# Load modules
module load singularity

# Run WGCNA enrichment analysis (using .sif file for production)
singularity exec wgcna_enrich.sif Rscript run_enrichment.R

# Alternative: Run directly from Docker URI (for testing)
# singularity exec docker://your-registry/wgcna_enrich:latest Rscript run_enrichment.R
```

#### FRAGLE Analysis Job
```bash
#!/bin/bash
#SBATCH --job-name=fragle_analysis
#SBATCH --partition=compute
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=fragle_%j.out
#SBATCH --error=fragle_%j.err

# Load modules
module load singularity

# Set up paths
INPUT_FOLDER="/path/to/your/input/data"
OUTPUT_FOLDER="/path/to/your/output/directory"

# Run FRAGLE analysis (using .sif file for production)
singularity exec \
  --pwd /usr/src/app \
  --bind "$INPUT_FOLDER":/mnt/I_Folder \
  --bind "$OUTPUT_FOLDER":/mnt/O_Folder \
  fragle.sif \
  python /usr/src/app/main.py \
    --input /mnt/I_Folder \
    --output /mnt/O_Folder \
    --mode R \
    --cpu $SLURM_CPUS_PER_TASK \
    --threads $SLURM_CPUS_PER_TASK

# Alternative: Run directly from Docker URI (for testing)
# singularity exec \
#   --pwd /usr/src/app \
#   --bind "$INPUT_FOLDER":/mnt/I_Folder \
#   --bind "$OUTPUT_FOLDER":/mnt/O_Folder \
#   docker://prc992/snap-fragle:v1 \
#   python /usr/src/app/main.py \
#     --input /mnt/I_Folder \
#     --output /mnt/O_Folder \
#     --mode R \
#     --cpu $SLURM_CPUS_PER_TASK \
#     --threads $SLURM_CPUS_PER_TASK
```

## ⚙️ Advanced Configuration

### Customizing Container Images

#### Adding Custom Packages

```dockerfile
# Example: Adding custom R packages
FROM your-base-image

# Install additional R packages
RUN R -e "install.packages(c('your_package1', 'your_package2'), repos='https://cran.r-project.org/')"
RUN R -e "BiocManager::install(c('your_bioc_package1', 'your_bioc_package2'), ask=FALSE)"
```

#### Environment Variables

```bash
# Set environment variables for containers
export R_LIBS_USER=/path/to/custom/r/packages
export PYTHONPATH=/path/to/custom/python/packages

# Use in container
docker run --rm -e R_LIBS_USER=$R_LIBS_USER -e PYTHONPATH=$PYTHONPATH your-container
```

### Volume Mounting Strategies

#### Data Organization
```bash
# Recommended directory structure
project/
├── data/           # Input data
├── scripts/        # Analysis scripts
├── results/        # Output results
├── logs/          # Log files
└── containers/    # Singularity images
```

#### Mounting Strategy
```bash
# Mount specific directories
singularity exec \
  --bind "$PWD/data:/analysis/data" \
  --bind "$PWD/scripts:/analysis/scripts" \
  --bind "$PWD/results:/analysis/results" \
  your-container.sif your-command
```

### Resource Management

#### Memory and CPU Limits
```bash
# Docker resource limits
docker run --rm \
  --memory=16g \
  --cpus=4 \
  your-container

# SLURM resource requests
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
```

#### Storage Considerations
```bash
# Check available storage
df -h

# Use scratch directories for temporary files
export TMPDIR=/scratch/$USER/tmp
mkdir -p $TMPDIR
```

## 🔧 Troubleshooting

### Common Issues

#### Permission Problems
```bash
# Fix file permissions
chmod -R 755 your_data_directory

# Use appropriate user mapping
docker run --rm -u $(id -u):$(id -g) your-container
```

#### Memory Issues
```bash
# Increase memory allocation
docker run --rm --memory=32g your-container

# Monitor memory usage
singularity exec your-container.sif free -h
```

#### Network Issues
```bash
# Check network connectivity
singularity exec your-container.sif ping google.com

# Use host networking if needed
docker run --rm --network=host your-container
```

#### Package Installation Issues
```bash
# Update package repositories
singularity exec your-container.sif apt-get update

# Install missing system dependencies
singularity exec your-container.sif apt-get install -y missing-package
```

### Debugging Commands

```bash
# Inspect container contents
singularity shell your-container.sif
ls -la /usr/local/lib/R/site-library/

# Check R package versions
singularity exec your-container.sif R -e "sessionInfo()"

# Check Python package versions
singularity exec your-container.sif python -c "import pandas; print(pandas.__version__)"
```

### Log Files

```bash
# Check RStudio logs
tail -f ~/rstudio_singularity_*.log

# Check SLURM job logs
tail -f slurm-*.out
tail -f slurm-*.err
```

## 🤝 Contributing

### Adding New Containers

1. Create a new directory for your container
2. Add a `Dockerfile` with clear documentation
3. Include example usage scripts
4. Update this README with container information
5. Test with both Docker and Singularity

### Container Guidelines

- Use specific version tags for reproducibility
- Include comprehensive package lists
- Document all environment variables
- Provide example data and scripts
- Test on both local and HPC environments

### Testing Checklist

- [ ] Container builds successfully
- [ ] All packages install correctly
- [ ] Example scripts run without errors
- [ ] Works with both Docker and Singularity
- [ ] Resource usage is reasonable
- [ ] Documentation is complete

## 📚 Additional Resources

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [SLURM Documentation](https://slurm.schedmd.com/documentation.html)
- [Bioconductor Documentation](https://bioconductor.org/help/)

### Related Tools
- [Rocker Project](https://www.rocker-project.org/) - R Docker images
- [Bioconductor Docker](https://bioconductor.org/help/docker/) - Bioconductor containers
- [Singularity Hub](https://singularity-hub.org/) - Container registry

### Support
- Check the issues page for known problems
- Create a new issue for bugs or feature requests

---

**Note**: This documentation assumes you have appropriate permissions and access to your HPC system. Always check with your system administrators for specific policies and configurations. 
