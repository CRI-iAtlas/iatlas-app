new_dataset_selection_ui <- function(id){

    ns <- shiny::NS(id)

    datasets <- list('Cancer Genomics' = c('TCGA', 'PCAWG'),
                     'Immunotherapy' = c('Choueiri 2016 - KIRC, PD-1', 'Gide 2019 - SKCM, PD-1 +/- CTLA4'))

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

    css <- "
.chapter {
  color: black;
  text-align: left;
  font-family: Georgia;
  font-size: 20px;
}

.chapter-container {
  background-color: white;
  border-radius: 10px;
}

#toc_container {
  position: fixed;
  top: 0;
  background: #f9f9f9 none repeat scroll 0 0;
  border: 1px solid #aaa;
  display: table;
  font-size: 95%;
  margin-bottom: 1em;
  padding: 20px;
  width: auto;
}

.toc_title {
  font-weight: 700;
  text-align: center;
}

#toc_container li,
#toc_container ul,
#toc_container ul li {
  list-style: outside none none !important;
}
"

tags$head(tags$style(HTML(css)))


    shiny::tagList(
        iatlas.modules::titleBox(
            "iAtlas Explorer — Testing a new way to select datasets"
        ),
        iatlas.modules::textBox(
            width = 12,
            shiny::p("Test, test!")
        ),
        iatlas.modules::optionsBox(
            width = 3,
            column(
                width = 12,
                tags$div(
                    id = "toc_container",
                    tags$p(
                        class = "toc_title",
                        "Contents"
                    ),
                    tags$ul(
                        class = "toc_list",
                        tags$li(
                            tags$a(
                                href = "#introduction",
                                "Introduction"
                            )
                        ),
                        tags$li(
                            tags$a(
                                href = "#Immunotherapy",
                                "Immunotherapy"
                            )
                        )
                    )
                )
            )
        ),
        iatlas.modules::optionsBox(
            width = 9,
            awesomeCheckboxGroup2(
                inputId = "somevalue",
                label = "",
                choices = datasets
            )
        )
    )
}
