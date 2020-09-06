# TODO: remove when UI files are in main dir, fix bottom test
dir <- file.path(system.file("R", package = "iatlas.app"), "modules/ui/submodules")
source(file.path(dir, "tumor_microenvironment_type_fractions_ui.R"))
source(file.path(dir, "tumor_microenvironment_cell_proportions_ui.R"))

test_that("module isn't shown", {
  shiny::testServer(
    app = call_module_server2,
    args = list(
      "cohort_obj" = shiny::reactiveVal(pcawg_immune_subtype_cohort_obj),
      "server_function" = tumor_microenvironment_cell_proportions_server,
      "ui_function" = tumor_microenvironment_cell_proportions_ui,
      "test_function" = shiny::reactiveVal(show_ocp_submodule)
    ),
    expr = {
      expect_false(display_module())
      expect_type(output$ui, "list")
    }
  )
})

# test_that("module is shown", {
#   shiny::testServer(
#     app = call_module_server2,
#     args = list(
#       "cohort_obj" = shiny::reactiveVal(pcawg_immune_subtype_cohort_obj),
#       "server_function" = tumor_microenvironment_type_fractions_server,
#       "ui_function" = tumor_microenvironment_type_fractions_ui,
#       "test_function" = shiny::reactiveVal(show_ctf_submodule)
#     ),
#     expr = {
#       expect_true(display_module())
#       expect_type(output$ui, "list")
#     }
#   )
# })