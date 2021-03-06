ici_clinical_outcomes_plot_server <- function(
  id
) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      ns <- session$ns

      output$survplot_op <- renderUI({

        clin_data <- ioresponse_data$feature_df %>%
          dplyr::filter(FeatureMatrixLabelTSV != "treatment_when_collected" & FeatureMatrixLabelTSV %in% ioresponse_data$categories_df$Category)

        var_choices_clin <- create_filtered_nested_list_by_class(feature_df = clin_data,
                                                                 filter_value = "Categorical",
                                                                 class_column = "Variable Class",
                                                                 internal_column = "FeatureMatrixLabelTSV",
                                                                 display_column = "FriendlyLabel",
                                                                 filter_column = "VariableType")

        var_choices_feat <- create_filtered_nested_list_by_class(feature_df = ioresponse_data$feature_df %>% dplyr::filter(`Variable Class` != "NA"),
                                                                 filter_value = "Numeric",
                                                                 class_column = "Variable Class",
                                                                 internal_column = "FeatureMatrixLabelTSV",
                                                                 display_column = "FriendlyLabel",
                                                                 filter_column = "VariableType")
        var_choices <- c(var_choices_clin, var_choices_feat)

        selectInput(
          ns("var1_surv"),
          "Variable",
          var_choices,
          selected = "IMPRES"
        )
      })

      datasets <- shiny::reactive({
        shiny::req(input$timevar)
        switch(
          input$timevar,
          "OS_time" = input$datasets,
          "PFI_time_1"= input$datasets[input$datasets %in% datasets_PFI]
        )
      })

      shiny::observeEvent(all_survival(),{

        if(length(all_survival())>0 & length(datasets()) != length(all_survival())){
          var_label <- convert_value_between_columns(
            input$var1_surv,
            ioresponse_data$feature_df,
            from_column = "FeatureMatrixLabelTSV",
            to_column = "FriendlyLabel"
          )
          output$notification <- renderUI({
            missing_datasets <- paste0(intersect(datasets(), names(all_survival())), collapse = ", ")
            helpText(
              paste("Annotation and/or more than one level for ", var_label, "is available for", missing_datasets, "."))
          })
        }
        if(length(datasets()) == length(all_survival()) | length(all_survival()) == 0){
          output$notification <- renderUI({
          })
        }
      })

      feature_df <- reactive({
        shiny::validate(need(!is.null(input$datasets), "Select at least one dataset."))
        shiny::req(input$var1_surv)

        ioresponse_data$fmx_df %>%
          dplyr::filter(Dataset %in% datasets() & treatment_when_collected == "Pre") %>%
          dplyr::select(Sample_ID, Dataset, treatment_when_collected, OS, OS_time, PFI_1, PFI_time_1, input$var1_surv)
      })

      all_survival <- reactive({
        shiny::req(input$var1_surv, !is.null(feature_df()), cancelOutput = T)
        sample_groups <- ioresponse_data$feature_df %>%
          dplyr::filter(VariableType == "Categorical") %>%
          dplyr::select(FeatureMatrixLabelTSV, FriendlyLabel) %>% as.vector()

        df <- purrr::map(.x = datasets(), df = feature_df(), .f= function(dataset, df){
          dataset_df <- df %>%
            dplyr::filter(Dataset == dataset)

          if(!all(is.na(dataset_df[[input$var1_surv]])) & dplyr::n_distinct(dataset_df[[input$var1_surv]])>1){

            surv_df <- build_survival_df(
              df = dataset_df,
              group_column = input$var1_surv,
              group_options = sample_groups$FeatureMatrixLabelTSV,
              time_column = input$timevar,
              k = input$divk,
              div_range = input$div_range
            )

            if(input$var1_surv %in% sample_groups$FeatureMatrixLabelTSV){#adding the friendly labels

              surv_df <- merge(surv_df, ioresponse_data$sample_group_df %>%
                                 dplyr::filter(Category == input$var1_surv) %>%
                                 dplyr::select(FeatureValue, FeatureLabel),
                               by.x = "variable", by.y = "FeatureValue")
              surv_df$variable <- NULL
              surv_df <- surv_df %>%
                dplyr::rename(variable = FeatureLabel)
            }
            surv_df
          }
        })

        names(df) <- datasets()
        Filter(Negate(is.null), df)
      })

      all_fit <- reactive({
        shiny::validate(need(length(all_survival())>0, "Variable not annotated in the selected dataset(s). Select other datasets or check ICI Datasets Overview for more information."))
        purrr::map(all_survival(), function(df) survival::survfit(survival::Surv(time, status) ~ variable, data = df))
      })

      all_kmplot <- reactive({
        sample_groups <- ioresponse_data$feature_df %>% dplyr::filter(VariableType == "Categorical") %>% dplyr::select(FeatureMatrixLabelTSV)

        if (input$var1_surv %in% sample_groups$FeatureMatrixLabelTSV) {
          group_colors <- (ioresponse_data$sample_group_df %>%
                             dplyr::filter(Category == input$var1_surv))$FeatureHex
          colors_labels <-(ioresponse_data$sample_group_df %>%
                             dplyr::filter(Category == input$var1_surv))$FeatureLabel

          names(group_colors) <- sapply(colors_labels, function(a) paste('variable=',a,sep=''))

        } else if(input$div_range == "median") {
          group_colors <- viridisLite::viridis(2)
        }else{
          group_colors <- viridisLite::viridis(input$divk)
        }

        create_kmplot(
          fit = all_fit(),
          df = all_survival(),
          confint = input$confint,
          risktable = input$risktable,
          title = names(all_survival()),
          group_colors = group_colors,
          facet = TRUE)
      })

      #the KM Plots are stored as a list, so a few adjustments are necessary to plot everything
      shiny::observe({
        output$plots <- renderUI({
          shiny::req(input$var1_surv)

          plot_output_list <-
            lapply(1:length(all_survival()), function(i) {
              plotname <- names(all_survival())[i]
              plotOutput(ns(plotname), height = 600)
            })
          do.call(tagList, plot_output_list)
        })
      })

      shiny::observe({
        lapply(1:length(datasets()), function(i){
          my_dataset <- names(all_survival())[i]
          output[[my_dataset]] <- shiny::renderPlot({
            shiny::req(input$var1_surv)
            all_kmplot()[i]
          })
        })
      })
    }
  )
}
