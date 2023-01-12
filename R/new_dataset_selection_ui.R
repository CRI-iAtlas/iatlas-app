new_dataset_selection_ui <- function(id){

    ns <- shiny::NS(id)
#


    # tags$head(tags$style(HTML("css/table_of_contents.css")))


    shiny::tagList(
        iatlas.modules::titleBox(
            "iAtlas Explorer — Testing a new way to select datasets"
        ),
        iatlas.modules::textBox(
            width = 12,
            shiny::p("Test, test!")
        ),

        iatlas.modules::optionsBox(
            width = 12,
            DT::DTOutput(ns("interactionUI"))
        )
            # tags$div(
            #     class = "dtsp-verticalContainer",
            #     tags$div(class = "dtsp-verticalPanes"),
            #     tags$div(
            #         class = "container",
            #     )
            # )
        #)
    )
}
