create_barplot <- function(
  df,
  x_col = "x",
  y_col = "y",
  error_col = "error",
  key_col = NA,
  color_col = NA,
  label_col = NA,
  xlab = "",
  ylab = "",
  title = "",
  source_name = NULL,
  bar_colors = NULL,
  showlegend = T) {

  if(is.na(key_col)) key_col <- x_col
  if(is.na(color_col)) color_col <- x_col
  if(is.na(label_col)) label_col <- x_col

  if (is.null(bar_colors)) {
    bar_colors <- viridis::viridis_pal(option = "D")(dplyr::n_distinct(df[[color_col]]))
  }
  wrapr::let(
    alias = c(
      X = x_col,
      Y = y_col,
      KEY = key_col,
      COLOR = color_col,
      ERROR = error_col,
      LABEL = label_col),
    plotly::plot_ly(
      df,
      x = ~X,
      y = ~Y,
      color = ~COLOR,
      text = ~LABEL,
      textposition = 'none',
      key = ~KEY,
      type = 'bar',
      source = source_name,
      colors = bar_colors,
      error_y = list(
        array = ~ERROR,
        color = 'black',
        thickness = 1),
      hoverinfo = 'text',
      showlegend = showlegend
    )) %>%
    plotly::layout(
      legend = list(orientation = 'h', x = 0, y = 1),
      title = title,
      xaxis = list(title = xlab),
      yaxis = list(title = ylab)
    ) %>%
    format_plotly()

}

create_barplot_horizontal <- function(df,
                            x_col = "x",
                            y_col = "y",
                            error_col = "error",
                            key_col = NA,
                            color_col = NA,
                            label_col = NA,
                            order_by = NULL,
                            xlab = "",
                            ylab = "",
                            title = "",
                            showLegend = TRUE,
                            legendTitle = " ",
                            source_name = NULL,
                            bar_colors = NULL){
  if(is.na(key_col)) key_col <- x_col
  if(is.na(color_col)) color_col <- x_col
  if(is.na(label_col)) label_col <- x_col

  if (is.null(bar_colors)) {
    bar_colors <- viridis::viridis_pal(option = "D")(dplyr::n_distinct(df[[color_col]]))
  }
  wrapr::let(
    alias = c(
      X = x_col,
      Y = y_col,
      KEY = key_col,
      COLOR = color_col,
      ERROR = error_col,
      LABEL = label_col),
    plotly::plot_ly(
      df,
      x = ~X,
      y = ~Y,
      color = ~COLOR,
      text = ~LABEL,
      textposition = 'none',
      key = ~KEY,
      type = 'bar',
      source = source_name,
      colors = bar_colors,
      orientation = 'h',
      error_x = list(
        visible = T,
        type = "data",
        array = ~ERROR,
        color = 'black',
        thickness = 1),
      hoverinfo = 'text'
    )) %>%
    plotly::layout(
      title = title,
      xaxis = list(title = xlab),
      yaxis = list(title = ylab,
                   categoryorder = "array",
                   categoryarray = ~order_by),
      showlegend = showLegend,
      legend = list(orientation = 'h', x = 0, y = 1,
                    title = list(text = legendTitle)
        )
    ) %>%
    format_plotly()

}
