new_dataset_selection_ui <- function(id){

    ns <- shiny::NS(id)
#
#     datasets <- list('Cancer Genomics' = c('TCGA', 'PCAWG'),
#                      'Immunotherapy' = c('Choueiri 2016 - KIRC, PD-1', 'Gide 2019 - SKCM, PD-1 +/- CTLA4'))


    tags$head(tags$style(HTML("css/table_of_contents.css")))


    shiny::tagList(
        iatlas.modules::titleBox(
            "iAtlas Explorer — Testing a new way to select datasets"
        ),
        iatlas.modules::textBox(
            width = 12,
            shiny::p("Test, test!")
        ),
        iatlas.modules::optionsBox(
            width = 3,
            column(
                width = 12,
                shiny::uiOutput(ns("datasets_toc"))

            )
        ),
        iatlas.modules::optionsBox(
            width = 9,
            # awesomeCheckboxGroup2(
            #     inputId = "somevalue",
            #     label = "",
            #     choices = datasets
            # ),
            shiny::uiOutput(ns("interactionUI"))
        )
    )
}
