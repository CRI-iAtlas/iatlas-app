ici_hazard_ratio_server <- function(
  id,
  cohort_obj
){
  shiny::moduleServer(
    id,
    function(input, output, session) {
      ici_hazard_ratio_main_server(
        "ici_hazard_ratio_main",
        cohort_obj
      )
    }
  )
}
