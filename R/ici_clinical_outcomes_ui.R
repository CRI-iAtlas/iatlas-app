ici_clinical_outcomes_ui <- function(id){

  ns <- shiny::NS(id)

  shiny::tagList(
    titleBox(
      "iAtlas Explorer — Clinical Outcomes to Immune Checkpoint Inhibitors"
    ),
    textBox(
      width = 12,
      p("Plot survival curves based on immune characteristics and identify variables associated with outcome.")
    ),
    sectionBox(
      title = "Clinical Outcomes",
      ici_clinical_outcomes_plot_ui(ns("ici_clinical_outcomes_plot"))
    )
  )
}