til_map_ui <- function(id) {

  ns <- shiny::NS(id)

  shiny::tagList(
    titleBox("iAtlas Explorer — TIL Maps"),
    textBox(
      width = 12,
      shiny::includeMarkdown(get_markdown_path("tilmap"))
    ),
    sectionBox(
      title = "Distributions",
      module_ui(ns("til_map_distributions"))
    ),
    sectionBox(
      title = "TIL Map Annotations",
      module_ui(ns("til_map_datatable"))
    )
  )
}