new_dataset_selection_server <- function(id, cohort_obj){

  shiny::moduleServer(
    id,
    function(input, output, session) {
        ns <- session$ns

        datasets <- data.frame(
          v2 = shinyInput(checkboxInput, 8, 'v2_', value = TRUE),
          name = c('TCGA', 'PCAWG', "Chen 2016 - SKCM, Anti-CTLA4", 'Choueiri 2016 - KIRC, PD-1', 'Gide 2019 - SKCM, PD-1 +/- CTLA4', 'Choueiri 2016 - KIRC, PD-1', 'Gide 2019 - SKCM, PD-1 +/- CTLA4', "Chen 2016 - SKCM, Anti-CTLA4"),
          type = c('Cancer Genomics' , 'Cancer Genomics', 'Immunotherapy', 'Immunotherapy', 'Immunotherapy', 'RNA-Seq','RNA-Seq', "Nanostring"))


        output$interactionUI <- DT::renderDT(
          ioresponse_data$dataset_df %>%
            dplyr::select(Dataset, Samples, Patients, Study, Antibody, `Sequencing Method`),
          server = FALSE,
          escape = FALSE,
          rownames = FALSE,
          options = list(
            dom = 'Pfrtip',
            searchPanes = list(layout = "columns-1")

          ),
          extensions = c('Select', 'SearchPanes'),
          selection = 'none'
        )
    }
  )
}
