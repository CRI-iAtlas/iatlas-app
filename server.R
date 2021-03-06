################################################################################
# Options, default settings, and load packages
################################################################################
# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 100 * 1024^2)
options(shiny.usecairo = FALSE)

library(magrittr)

modules_tbl <- "module_config" %>%
  get_tsv_path() %>%
  readr::read_tsv(.) %>%
  dplyr::mutate(
    "link" = stringr::str_c("link_to_", .data$name),
    "image" = stringr::str_c("images/", .data$name, ".png"),
    "server_function_string" = stringr::str_c(.data$name, "_server"),
    "ui_function_string" = stringr::str_c(.data$name, "_ui"),
    "server_function" = purrr::map(.data$server_function_string, get),
    "ui_function" = purrr::map(.data$ui_function_string, get)
  )

analysis_modules_tbl <- dplyr::filter(modules_tbl, .data$type == "analysis")
ici_modules_tbl <- dplyr::filter(modules_tbl, .data$type == "ici")
tool_modules_tbl <- dplyr::filter(modules_tbl, .data$type == "tool")




################################################################################
# Begin Shiny Server definition.
################################################################################
shiny::shinyServer(function(input, output, session) {

  shiny::observe({
    query <- shiny::parseQueryString(session$clientData$url_search)
    if (!is.null(query[['module']])) {
      shinydashboard::updateTabItems(
        session,
        "explorertabs",
        query[['module']]
      )
    }
  })

  # Modules -------------------------------------------------------------------

  cohort_obj <- call_iatlas_module(
    "cohort_selection",
    cohort_selection_server,
    input,
    session
  )

  call_iatlas_module(
    "data_info",
    data_info_server,
    input,
    session
  )

  # Analysis Modules ----------------------------------------------------------

  analysis_modules_tbl %>%
    dplyr::select("name", "server_function") %>%
    purrr::pwalk(iatlas.app::call_iatlas_module, input, session, cohort_obj)

  # ICI Modules ----------------------------------------------------------

  ici_modules_tbl %>%
    dplyr::select("name", "server_function") %>%
    purrr::pwalk(iatlas.app::call_iatlas_module, input, session)

  # Tool Modules --------------------------------------------------------------

  tool_modules_tbl %>%
    dplyr::select("name", "server_function") %>%
    purrr::pwalk(iatlas.app::call_iatlas_module, input, session)

  # Sidebar Menu --------------------------------------------------------------

  analysis_module_menu_items <- shiny::reactive({
    analysis_modules_tbl %>%
      dplyr::select("text" = "display", "tabName" = "name") %>%
      purrr::pmap(shinydashboard::menuSubItem, icon = shiny::icon("cog"))
  })

  ici_module_menu_items <- shiny::reactive({
    ici_modules_tbl %>%
      dplyr::select("text" = "display", "tabName" = "name") %>%
      purrr::pmap(shinydashboard::menuSubItem, icon = shiny::icon("cog"))
  })

  tool_module_menu_items <- shiny::reactive({
    tool_modules_tbl %>%
      dplyr::select("text" = "display", "tabName" = "name") %>%
      purrr::pmap(shinydashboard::menuSubItem, icon = shiny::icon("cog"))
  })

  output$sidebar_menu <- shinydashboard::renderMenu({
    shinydashboard::sidebarMenu(
      id = "explorertabs",
      shinydashboard::menuItem(
        "iAtlas Explorer Home",
        tabName = "dashboard",
        icon = shiny::icon("dashboard")
      ),
      shinydashboard::menuItem(
        "Cohort Selection",
        tabName = "cohort_selection",
        icon = shiny::icon("cog")
      ),
      shinydashboard::menuItem(
        "Data Description",
        icon = shiny::icon("th-list"),
        tabName = "data_info"
      ),
      shinydashboard::menuItem(
        text = "Analysis Modules",
        icon = shiny::icon("bar-chart"),
        startExpanded = TRUE,
        analysis_module_menu_items()
      ),
      shinydashboard::menuItem(
        text = "ICI Modules",
        icon = shiny::icon("bar-chart"),
        startExpanded = TRUE,
        ici_module_menu_items()
      ),
      shinydashboard::menuItem(
        text = "iAtlas tools",
        icon = shiny::icon("wrench"),
        startExpanded = TRUE,
        tool_module_menu_items()
      )
    )
  })

  # Dashboard Body ------------------------------------------------------------

  readout_info_boxes <- shiny::reactive({
    readout_tbl <- dplyr::tibble(
      title = c(
        "Immune Readouts:",
        "Classes of Readouts:",
        "TCGA Cancers:",
        "TCGA Samples:"
      ),
      value = c(
        nrow(iatlas.api.client::query_features()),
        length(unique(iatlas.api.client::query_features()$class)),
        nrow(iatlas.api.client::query_tags(
          datasets = "TCGA", parent_tags = "TCGA_Study"
        )),
        11080
      ),
      icon = purrr::map(c("search", "filter", "flask", "users"), shiny::icon)
    )

    purrr::pmap(
      readout_tbl,
      shinydashboard::infoBox,
      width = 3,
      color = "black",
      fill = FALSE
    )
  })

  module_image_boxes <- shiny::reactive({
    lst <- purrr::pmap(
      list(
        title  = analysis_modules_tbl$display,
        linkId = analysis_modules_tbl$link,
        imgSrc = analysis_modules_tbl$image,
        boxText = analysis_modules_tbl$description
      ),
      iatlas.modules::imgLinkBox,
      width = 6,
      linkText = "Open Module"
    )

    row_tbl <- lst %>%
      dplyr::tibble("item" = .) %>%
      dplyr::mutate("row" = as.character(ceiling(dplyr::row_number() / 2))) %>%
      dplyr::group_by(.data$row) %>%
      dplyr::mutate("n" = as.character(dplyr::row_number())) %>%
      dplyr::ungroup() %>%
      tidyr::pivot_wider(names_from = "n", values_from = "item")

    func <- function(i, tbl){
      item1 <- tbl$`1`[[i]]
      item2 <- tbl$`2`[[i]]
      if(is.null(item2)){
        row_list <- shiny::tagList(item1)
      } else {
        row_list <- shiny::tagList(item1, item2)
      }
      shiny::fluidRow(row_list)
    }

    return(purrr::map(1:nrow(row_tbl), func, row_tbl))

  })

  module_tab_items <- shiny::reactive({
    modules_tbl %>%
      dplyr::select("name", "ui_function") %>%
      purrr::pmap(~shinydashboard::tabItem(tabName = .x, .y(.x)))
  })

  output$dashboard_body <- shiny::renderUI({
    shiny::req(readout_info_boxes(), module_image_boxes(), module_tab_items())
    tab_item <- list(shinydashboard::tabItem(
      tabName = "dashboard",
      iatlas.modules::titleBox("iAtlas Explorer — Home"),
      iatlas.modules::textBox(
        width = 12,
        shiny::includeMarkdown("inst/markdown/explore1.markdown")
      ),
      iatlas.modules::sectionBox(
        title = "What's Inside",
        shiny::fluidRow(readout_info_boxes())
      ),
      iatlas.modules::sectionBox(
        title = "Analysis Modules",
        iatlas.modules::messageBox(
          width = 12,
          shiny::includeMarkdown("inst/markdown/explore2.markdown")
        ),
        module_image_boxes()
      )
    ))
    do.call(
      shinydashboard::tabItems,
      c(tab_item, module_tab_items())
    )
  })

})


