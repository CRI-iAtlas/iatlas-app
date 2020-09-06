cellimage_ui <- function(id){

    ns <- shiny::NS(id)

    shiny::tagList(
        iatlas.app::titleBox(
            "iAtlas Explorer — Cell-Interaction Diagram"
        ),
        iatlas.app::textBox(
            width = 12,
            "This module allows you to depict the estimated abundance of tumor cells and representative innate and adaptive cells in the microenvironment, along with the abundance of receptor and ligands mediating interactions between those cells."
        ),
        iatlas.app::sectionBox(
            title = "Cell-Interaction Diagram",
            module_ui(ns("cellimage_main"))
        )
    )
}