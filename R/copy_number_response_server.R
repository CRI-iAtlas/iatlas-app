copy_number_response_server <- function(
  id,
  cohort_obj
) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      ns <- session$ns

      # group_tbl <- shiny::reactive({
      #   iatlas.app::query_tags(
      #     cohort_obj()$dataset,
      #     cohort_obj()$group_name
      #   )
      # })
      #
      # output$select_cn_group_ui <- shiny::renderUI({
      #   shiny::selectInput(
      #     inputId  = ns("group_choices"),
      #     label    = "Select Group Filter",
      #     choices  = iatlas.app::build_cnv_group_list(group_tbl()),
      #     selected = "All",
      #     multiple = T
      #   )
      # })
      #
      # output$response_option_ui <- shiny::renderUI({
      #   shiny::selectInput(
      #     inputId  = ns("response_variable"),
      #     label    = "Select or Search for Response Variable",
      #     choices = iatlas.app::create_nested_named_list(
      #       cohort_obj()$feature_tbl, values_col = "name"
      #     ),
      #     selected = "leukocyte_fraction"
      #   )
      # })
      #
      # gene_tbl  <- shiny::reactive(iatlas.app::build_cnv_gene_tbl())
      #
      # gene_set_tbl <- shiny::reactive(iatlas.app::query_gene_types())
      #
      # gene_choice_list <- shiny::reactive({
      #   shiny::req(gene_set_tbl(), gene_tbl())
      #   build_cnv_gene_list(gene_set_tbl(), gene_tbl())
      # })
      #
      # output$select_cn_gene_ui <- shiny::renderUI({
      #   shiny::selectInput(
      #     ns("gene_filter_choices"),
      #     "Select Gene Filter",
      #     choices = gene_choice_list(),
      #     selected = "All",
      #     multiple = T
      #   )
      # })
      #
      # gene_entrez_query <- shiny::reactive({
      #   shiny::req(input$gene_filter_choices)
      #   iatlas.app::get_cnv_entrez_query_from_filters(
      #     input$gene_filter_choices,
      #     gene_set_tbl(),
      #     gene_tbl()
      #   )
      # })
      #
      # groups <- shiny::reactive({
      #   shiny::req(input$group_choices)
      #   if ("All" %in% input$group_choices) return(group_tbl()$name)
      #   else return(input$group_choices)
      # })
      #
      # direction_query <- shiny::reactive({
      #   shiny::req(input$cn_dir_point_filter)
      #   if (input$cn_dir_point_filter == "All") return(list())
      #   else return(input$cn_dir_point_filter)
      # })
      #
      # result_tbl <- shiny::reactive({
      #
      #   shiny::req(
      #     groups(),
      #     gene_entrez_query(),
      #     input$response_variable,
      #     direction_query()
      #   )
      #
      #   result_tbl <- iatlas.app::query_copy_number_results(
      #     datasets = cohort_obj()$dataset,
      #     tags = groups(),
      #     genes = gene_entrez_query(),
      #     features = input$response_variable,
      #     direction = direction_query()
      #   )
      #   shiny::validate(need(
      #     all(!is.null(result_tbl), nrow(result_tbl) > 0),
      #     paste0(
      #       "Members in current selected groupings do not have ",
      #       "driver CNV results"
      #     )
      #   ))
      #   return(result_tbl)
      # })
      #
      # output$text <- shiny::renderText({
      #   shiny::req(result_tbl())
      #   create_cnv_results_string(result_tbl())
      # })
      #
      # output$cnvPlot <- plotly::renderPlotly({
      #   shiny::req(result_tbl())
      #   iatlas.app::create_histogram(
      #     dplyr::select(result_tbl(), x = t_stat),
      #     x_lab = 'T statistics, Positive if normal value higher',
      #     y_lab = 'Number of tests',
      #     title = 'Distribution of T statistics',
      #     source_name = "cnv_hist"
      #   )
      # })
      #
      # output$cnvtable <- DT::renderDataTable({
      #   shiny::req(result_tbl())
      #   DT::datatable(
      #     iatlas.app::build_cnv_dt_tbl(result_tbl()),
      #     extensions = 'Buttons', options = list(
      #       scrollY = '300px',
      #       paging = TRUE,
      #       scrollX = TRUE,
      #       dom = 'Bfrtip',
      #       buttons =
      #         list('copy', 'print',
      #              list(
      #                extend = 'collection',
      #                buttons = c('csv', 'excel', 'pdf'),
      #                text = 'Download')
      #         )
      #     )
      #   )
      # })

    }
  )
}
