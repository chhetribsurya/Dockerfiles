# run_enrichment.R

# Load required packages
if (!requireNamespace("clusterProfiler")) stop("clusterProfiler not installed")
if (!requireNamespace("org.Hs.eg.db")) stop("org.Hs.eg.db not installed")
if (!requireNamespace("gprofiler2")) stop("gprofiler2 not installed")
if (!requireNamespace("ggplot2")) stop("ggplot2 not installed")
if (!requireNamespace("dplyr")) stop("dplyr not installed")

library(clusterProfiler)
library(org.Hs.eg.db)
library(gprofiler2)
library(ggplot2)
library(dplyr)

# Set input/output paths
input_rds <- "data/wgcna_modules_results.rds"
output_dir <- "data/enrichment_analysis_results"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# Load WGCNA results
results <- readRDS(input_rds)

# Helper: extract genes
extract_genes <- function(genes_column) {
  unlist(strsplit(genes_column, ";\\s*"))
}

# Enrichment function
perform_enrichment_analysis <- function(gene_list, trait_name, output_dir) {
  message("Analyzing: ", trait_name)
  
  gene_symbols <- gene_list
  entrez_ids <- mapIds(org.Hs.eg.db, keys = gene_symbols, column = "ENTREZID",
                       keytype = "SYMBOL", multiVals = "first")
  entrez_ids <- entrez_ids[!is.na(entrez_ids)]
  
  if (length(entrez_ids) == 0) return(NULL)
  
  go_results <- enrichGO(gene = entrez_ids, OrgDb = org.Hs.eg.db, keyType = "ENTREZID",
                         ont = "ALL", pAdjustMethod = "BH", qvalueCutoff = 0.05)
  
  hp_results <- gost(query = gene_symbols, organism = "hsapiens",
                     sources = c("GO:BP", "GO:MF", "GO:CC", "HP"),
                     significant = FALSE)
  
  # Save GO results
  if (!is.null(go_results)) {
    go_file <- file.path(output_dir, paste0("GO_enrichment_", trait_name, ".csv"))
    write.csv(as.data.frame(go_results), file = go_file)
  }
  
  # Save HP results
  if (!is.null(hp_results) && nrow(hp_results$result) > 0) {
    hp_file <- file.path(output_dir, paste0("HP_enrichment_", trait_name, ".csv"))
    hp_results_flat <- hp_results$result %>%
      mutate(across(everything(), ~ifelse(is.list(.), sapply(., paste, collapse = ";"), .)))
    write.csv(hp_results_flat, file = hp_file, row.names = FALSE)
  }
  
  # Plot GO
  if (!is.null(go_results) && nrow(go_results@result) > 0) {
    go_plot <- dotplot(go_results) + ggtitle(paste("GO Enrichment for", trait_name))
    ggsave(file.path(output_dir, paste0("GO_plot_", trait_name, ".pdf")), go_plot)
  }
  
  # Plot HP
  if (!is.null(hp_results) && nrow(hp_results$result) > 0) {
    hp_data <- hp_results$result[1:10, ]
    hp_plot <- ggplot(hp_data, aes(x = term_name, y = p_value)) +
      geom_point() + coord_flip() + theme_bw() +
      ggtitle(paste("HP Enrichment for", trait_name))
    ggsave(file.path(output_dir, paste0("HP_plot_", trait_name, ".pdf")), hp_plot)
  }
  
  return(list(GO = go_results, HP = hp_results))
}

# Function to plot and save enrichment results
plot_enrichment_results <- function(enrichment_results, trait_name, output_dir) {
  if (is.null(enrichment_results[[trait_name]])) {
    message(paste("No enrichment results available for trait:", trait_name))
    return(NULL)
  }
  
  # Plot GO terms
  go_results <- enrichment_results[[trait_name]]$GO
  if (!is.null(go_results) && nrow(go_results@result) > 0) {

    # Plot top 10 results go_results@result[1:10,]
    #go_data <- go_results@result[1:10,]

    go_plot <- dotplot(go_results) + ggtitle(paste("GO Enrichment for", trait_name))
    go_plot_file <- file.path(output_dir, paste0("GO_plot_", trait_name, ".pdf"))
    ggsave(go_plot_file, plot = go_plot, device = "pdf")
    message(paste("GO enrichment plot saved for trait:", trait_name, "to", go_plot_file))
  }
  
  # Plot Human Phenotype terms
  hp_results <- enrichment_results[[trait_name]]$HP
  if (!is.null(hp_results) && nrow(hp_results$result) > 0) {

    # Plot top 10 results hp_results$result[1:10,]
    hp_data <- hp_results$result[1:10,]
    hp_plot <- ggplot(hp_data, aes(x = term_name, y = p_value)) +
      geom_point() +
      coord_flip() +
      ggtitle(paste("Human Phenotype Enrichment for", trait_name)) +
      theme_bw()
    hp_plot_file <- file.path(output_dir, paste0("HP_plot_", trait_name, ".pdf"))
    ggsave(hp_plot_file, plot = hp_plot, device = "pdf")
    message(paste("HP enrichment plot saved for trait:", trait_name, "to", hp_plot_file))
  }
}

output_dir_enrich <- "data/enrichment_analysis_results"

# Prepare list of gene sets
significant_genes_list <- list()
for (i in 1:nrow(results$top_traitmodules_genes$important_genes_df)) {
  trait_name <- results$top_traitmodules_genes$important_genes_df$Trait[i]
  genes <- extract_genes(results$top_traitmodules_genes$important_genes_df$Genes[i])
  significant_genes_list[[trait_name]] <- genes
}

# Define output directory for significant genes
significant_genes_dir <- file.path(output_dir_enrich, "significant_genes")
if (!dir.exists(significant_genes_dir)) {
  dir.create(significant_genes_dir, recursive = TRUE)
}

# Save each trait's gene list as a CSV
for (trait_name in names(significant_genes_list)) {
  genes <- significant_genes_list[[trait_name]]
  trait_file <- file.path(significant_genes_dir, paste0("significant_genes_", trait_name, ".csv"))
  write.csv(data.frame(Gene = genes), file = trait_file, row.names = FALSE)
}

# Save the entire list as an RDS
saveRDS(significant_genes_list, file = file.path(significant_genes_dir, "significant_genes_list.rds"))


# Run enrichment
enrichment_results <- list()
for (trait in names(significant_genes_list)) {
  enrichment_results[[trait]] <- perform_enrichment_analysis(significant_genes_list[[trait]], trait, output_dir)
}

# Save all results
saveRDS(enrichment_results, file = file.path(output_dir, "enrichment_results.rds"))

message("✅ Enrichment analysis completed successfully.")

