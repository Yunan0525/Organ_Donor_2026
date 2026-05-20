library(dplyr)

library(readr)

library(stringr)

library(tidyr)



base_dir <- "/work/users/y/u/yunan/organ_donor/assemble/between_section/May01"



dbcan_dir <- file.path(base_dir, "dbcan_out")

out_dir <- file.path(base_dir, "results")

dir.create(out_dir, showWarnings = FALSE)



files <- list.files(

  dbcan_dir,

  pattern = "dbCAN_hmm_results\\.tsv$",

  recursive = TRUE,

  full.names = TRUE

)



all_cazy <- lapply(files, function(f) {

  df <- read_tsv(f, show_col_types = FALSE)



  folder <- basename(dirname(f))

  file_base <- str_remove(folder, "_dbcan$")

  sample <- str_extract(file_base, "ODIWGS[0-9]+")



  df %>%

    mutate(

      FileBase = file_base,

      Sample = sample,

      CAZy_subfamily = str_remove(`HMM Name`, "\\.hmm$"),

      CAZy_family = str_extract(CAZy_subfamily, "^[A-Z]+[0-9]+")

    )

}) %>%

  bind_rows()



write_csv(all_cazy, file.path(out_dir, "all_dbcan_hmm_results.csv"))



# Count CAZyme families per strain

cazy_family_count <- all_cazy %>%

  count(FileBase, Sample, CAZy_family, name = "Count")



write_csv(cazy_family_count, file.path(out_dir, "cazy_family_long.csv"))



# Wide matrix: strain x CAZy family

cazy_family_matrix <- cazy_family_count %>%

  pivot_wider(

    names_from = CAZy_family,

    values_from = Count,

    values_fill = 0

  )



write_csv(cazy_family_matrix, file.path(out_dir, "cazy_family_matrix.csv"))



# Also create subfamily matrix

cazy_subfamily_count <- all_cazy %>%

  count(FileBase, Sample, CAZy_subfamily, name = "Count")



cazy_subfamily_matrix <- cazy_subfamily_count %>%

  pivot_wider(

    names_from = CAZy_subfamily,

    values_from = Count,

    values_fill = 0

  )



write_csv(cazy_subfamily_matrix, file.path(out_dir, "cazy_subfamily_matrix.csv"))



cat("Done!\n")

cat("Merged files:", length(files), "\n")

cat("Total CAZyme hits:", nrow(all_cazy), "\n")
