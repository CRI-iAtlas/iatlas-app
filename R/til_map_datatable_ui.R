til_map_datatable_ui <- function(id) {

    ns <- shiny::NS(id)

    shiny::tagList(
        data_table_ui(
            ns("til_table"),
            message_html = shiny::includeMarkdown(
              get_markdown_path("tilmap_table")
            ),
        )
    )
}
