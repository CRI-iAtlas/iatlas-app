#add checkboxes to DT table with datasets
shinyInput = function(FUN, len, id, ...) {
  inputs = character(len)
  for (i in seq_len(len)) {
    inputs[i] = as.character(FUN(paste0(id, i), label = NULL, ...))
  }
  inputs
}
