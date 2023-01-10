new_dataset_selection_server <- function(id, cohort_obj){

  shiny::moduleServer(
    id,
    function(input, output, session) {
        ns <- session$ns
        datasets <- list('Cancer Genomics' = c('TCGA', 'PCAWG'),
                         'Immunotherapy' = c('Choueiri 2016 - KIRC, PD-1', 'Gide 2019 - SKCM, PD-1 +/- CTLA4'))



        output$datasets_toc <- shiny::renderUI({
            tags$div(
              id = 'toc_container',
              tags$p(
                class = 'toc_title',
                'Contents'
              ),
              tags$ul(
                class = 'toc_list',
                #toc
                tags$li(tags$a(href = '#Cancer Genomics', 'Cancer Genomics')), tags$li(tags$a(href = '#Immunotherapy', 'Immunotherapy'))
                #lazyeval::lazy_eval(paste_dataset_level_titles(datasets))
                    )
            )


        })

        output$interactionUI <- shiny::renderUI({

          DT::datatable(ioresponse_data$dataset_df %>%
                           select(Dataset, Study, Antibody, Samples, Patients, `Sequencing Method`))

          # all_boxes <- get_listed_boxes_with_headers(datasets, session)
          # do.call(fluidRow, all_boxes)
        })
    }
  )
}
