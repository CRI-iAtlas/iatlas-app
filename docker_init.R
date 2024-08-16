print("STARTING iATLAS")

devtools::load_all(devtools::as.package(".")$path)
cat(crayon::blue("SUCCESS: iatlas.app is ready to go.\n"))
cat(crayon::blue(paste0("For more info, open README.md\n")))

shiny::runApp(appDir='.', port=3838, host="0.0.0.0", launch.browser = FALSE)
