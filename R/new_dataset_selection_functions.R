library(shinyWidgets)

generateAwesomeOptions2 <- function (inputId, choices, selected, inline, status, flag = FALSE) {

  # if input is a list, flag will be set to `TRUE` by the calling function
  if (flag) {

    options <-  mapply(choices, names(choices), FUN = function(lchoices, lname) {

      lchoices <- shinyWidgets:::choicesWithNames(lchoices)

      tags$div(
        tags$a(lname, href = paste0("#", lname), style = "margin-bottom: 10px;"),

        mapply(lchoices, names(lchoices), FUN = function(value, name) {

          inputTag <- tags$input(type = "checkbox", name = inputId,
                                 value = value, id = paste0(inputId, value))
          if (value %in% selected)
            inputTag$attribs$checked <- "checked"
          if (inline) {
            tags$div(class = paste0("awesome-checkbox checkbox-inline checkbox-",
                                    status), inputTag, tags$label(name, `for` = paste0(inputId,
                                                                                       value)))
          }
          # flag is not set `TRUE` this will create the normal checkboxes
          else {
            tags$div(class = paste0("awesome-checkbox checkbox-",
                                    status), inputTag, tags$label(name, `for` = paste0(inputId,
                                                                                       value)))
          }
        }, SIMPLIFY = FALSE, USE.NAMES = FALSE)
      )

    }, SIMPLIFY = FALSE, USE.NAMES = FALSE)} else {

      options <- mapply(choices, names(choices), FUN = function(value,
                                                                name) {
        inputTag <- tags$input(type = "checkbox", name = inputId,
                               value = value, id = paste0(inputId, value))
        if (value %in% selected)
          inputTag$attribs$checked <- "checked"
        if (inline) {
          tags$div(class = paste0("awesome-checkbox checkbox-inline checkbox-",
                                  status), inputTag, tags$label(name, `for` = paste0(inputId,
                                                                                     value)))
        }
        else {
          tags$div(class = paste0("awesome-checkbox checkbox-",
                                  status), inputTag, tags$label(name, `for` = paste0(inputId,
                                                                                     value)))
        }
      }, SIMPLIFY = FALSE, USE.NAMES = FALSE)


    }

  tags$div(class = "shiny-options-group", options)


}

awesomeCheckboxGroup2 <- function (inputId, label, choices, selected = NULL, inline = FALSE,
                                   status = "primary", width = NULL) {
  if(!is.list(choices)) {

    choices <- shinyWidgets:::choicesWithNames(choices)
    selected <- shiny::restoreInput(id = inputId, default = selected)
    if (!is.null(selected))
      selected <- shinyWidgets:::validateSelected(selected, choices, inputId)
    options <- generateAwesomeOptions2(inputId, choices, selected,
                                       inline, status = status)

  } else {
    choices2 <- unlist(unname(choices))
    choices2 <- shinyWidgets:::choicesWithNames(choices2)
    selected <- shiny::restoreInput(id = inputId, default = selected)

    if (!is.null(selected))
      selected <- shinyWidgets:::validateSelected(selected, choices2, inputId)
    options <- generateAwesomeOptions2(inputId, choices, selected,
                                       inline, status = status, flag = TRUE)
  }

  divClass <- "form-group shiny-input-container shiny-input-checkboxgroup awesome-bootstrap-checkbox"
  if (inline)
    divClass <- paste(divClass, "shiny-input-container-inline")
  awesomeTag <- tags$div(id = inputId, style = if (!is.null(width))
    paste0("width: ", validateCssUnit(width), ";"), class = divClass,
    tags$label(label, `for` = inputId, style = "margin-bottom: 10px;"),
    options)
  shinyWidgets:::attachShinyWidgetsDep(awesomeTag, "awesome")
}


get_listed_boxes_with_headers <- function(named_list_of_datasets, session){
  ns <- session$ns
  lapply(seq_along(named_list_of_datasets), function(i){
    shiny::checkboxGroupInput(
      inputId  = ns(named_list_of_datasets[i]),
      label    = names(named_list_of_datasets[i]),
      choices  = named_list_of_datasets[[i]]#,
      # selected = default_datasets()
    )
  })
}

paste_dataset_level_titles <- function(named_list_of_datasets){
  paste(
    sapply(seq_along(named_list_of_datasets), function(i){
      paste0(
        "shiny::tags$li(shiny::tags$a(href = ",
        paste0("'#",  names(named_list_of_datasets[i])),
        "', '",
        names(named_list_of_datasets[i]),
          "'))"
      )
  }), collapse = ",")
}
get_table_of_contents <- function(named_list_of_datasets){
  all_datasets <- paste_dataset_level_titles(named_list_of_datasets)
  paste0(
    "shiny::tags$div(
      id = 'toc_container',
      shiny::tags$p(
        class = 'toc_title',
        'Contents'
      ),
      shiny::tags$ul(
        class = 'toc_list',",
    all_datasets,
     #paste_dataset_level_titles(named_list_of_datasets),
      ")
    )"
  )
}
