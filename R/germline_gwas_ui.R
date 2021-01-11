germline_gwas_ui <- function(id){

    ns <- shiny::NS(id)
    shiny::tagList(
        messageBox(
            width = 12,
            shiny::p("GWAS were only performed on 33 immune traits that demonstrated nominally significant heritability (p < 0.05) in at least one ancestry group,
    since these were most likely to have significant genetic effects. "),
            shiny::p("The Manhattan plot below represents the -log10 p of the significant and suggestive GWAS hits by chromosomal position across the 33 immune
traits. Select an Immune Trait of interest to highlight the GWAS hits associated with this trait. You can also select a region of interest to narrow down the visualization."),
            shiny::p("Manuscript context: Figure 3A is reproduced with the 'See all chromosomes' option.
                     Figures 4A can be reproduced by selecting IFN 21978456 in 'Select Immune Features'.
              To generate Figure 4B, change the range of visualization to 'Select a region', Chromosome 2 and then select the coordinates by zooming in the plot or
              by manually updating the start and end of the region of interest. Similar procedures should be followed for
                     Figures 4E, 5B, 5D, S4D, S5A, S5C, S5E.")
        ),
        shiny::column(
          width = 2,
          optionsBox(
            width = 12,
            shiny::verticalLayout(
              shiny::uiOutput(ns("features")),
              shiny::checkboxInput(ns("only_selected"), "Display only selected feature(s)"),
              shiny:: conditionalPanel(
                condition = paste("" , paste0("input['", ns("only_selected"), "'] == false")),
                shiny::uiOutput(ns("to_exclude"))
              ),
              shiny::sliderInput(ns("yrange"), "Select range of -log10(p-values) to be included", min = 6, max = 30, value = c(6,12), step = 1),
              shiny::radioButtons(ns("selection"), "Select range of visualization", choices = c("See all chromosomes", "Select a region"), selected = "See all chromosomes")
           )
         )
        ),
        shiny::column(
          width = 10,
          iatlas.app::plotBox(
            width = 12,
            plotly::plotlyOutput(ns("mht_plot"), height = "300px") %>%
              shinycssloaders::withSpinner(.),
            shiny::conditionalPanel(paste0("input['", ns("selection"), "'] == 'Select a region'"),
                                    igvShiny::igvShinyOutput(ns('igv_plot')) %>%
                                      shinycssloaders::withSpinner(.)
            )
          ),
          shiny::fluidRow(
            shiny::column(
              width = 3,
              iatlas.app::optionsBox(
                width = 12,
                shiny::uiOutput(ns("search_snp"))
              )
            ),
            shiny::column(
              width = 5,
              iatlas.app::messageBox(
                width = 12,
                shiny::uiOutput(ns("links"))
              )
            ),
            shiny::column(
              width = 4,
              tableBox(
                width = 12,
                DT::DTOutput(ns("snp_tbl"))
              )
            )
          ),
          iatlas.app::messageBox(
            width = 12,
            shiny::p("Brief explanation of colocalization analysis.")
          ),
          shiny::fluidRow(
            column(
              width = 6,
              tableBox(
                width = 12,
                DT::DTOutput(ns("colocalization_tcga")) %>%
                  shinycssloaders::withSpinner(.),
                shiny::uiOutput(ns("tcga_colocalization_plot"))
              )
            ),
            column(
              width = 6,
              tableBox(
                width = 12,
                div(style = "overflow-y: scroll",
                    DT::DTOutput(ns("colocalization_gtex")) %>%
                      shinycssloaders::withSpinner(.)
                ),
                shiny::uiOutput(ns("gtex_colocalization_plot"))
              )
            )
          )
        )
)
}