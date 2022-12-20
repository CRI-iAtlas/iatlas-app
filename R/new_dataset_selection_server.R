new_dataset_selection_server <- function(id, cohort_obj){
  shiny::moduleServer(
    id,
    function(input, output, session) {

      sc_bubbleplot_server(
        "sc_bubbleplot",
        cohort_obj
      )

    }
  )
}



