build_ecn_gene_choice_list <- function(){
  genes <- iatlasGraphQLClient::query_genes(gene_types = "extracellular_network") %>%
    dplyr::select("hgnc", "entrez") %>%
    dplyr::mutate("entrez" = stringr::str_c("gene:", .data$entrez)) %>%
    tibble::deframe(.)

  list(
    "Genesets" = c(
      "Extracellular Network Genes" = "geneset:extracellular_network",
      "Immunomodulator Genes" = "geneset:immunomodulator"
    ),
    "Genes" = genes
  )
}

build_ecn_celltype_choice_list <- function(){
  features <-
    iatlasGraphQLClient::query_features(
      feature_classes = "Immune Cell Proportion - Common Lymphoid and Myeloid Cell Derivative Class"
    ) %>%
    dplyr::select("display", "name") %>%
    tibble::deframe(.) %>%
    c("All" = "All", .)
}

get_selected_gene_ids <- function(gene_input_list){
  gene_inputs <- unlist(gene_input_list)
  if(is.null(gene_inputs)) return(NULL)
  genesets <- gene_inputs %>%
    purrr::keep(., stringr::str_detect(., "^geneset:")) %>%
    stringr::str_remove_all(., "^geneset:")
  if(length(genesets) != 0){
    geneset_genes <- genesets %>%
      iatlasGraphQLClient::query_genes(gene_types = .) %>%
      dplyr::pull("entrez")
  } else {
    geneset_genes <- c()
  }
  genes <- gene_inputs %>%
    purrr::keep(., stringr::str_detect(., "^gene:")) %>%
    stringr::str_remove_all(., "^gene:") %>%
    c(geneset_genes) %>%
    unique() %>%
    as.integer() %>%
    sort()
}

get_selected_celltypes <- function(celltype_input_list){
  celltype_input = unlist(celltype_input_list)
  if("All" %in% celltype_input) {
    celltypes <- iatlasGraphQLClient::query_features(
      feature_classes = "Immune Cell Proportion - Common Lymphoid and Myeloid Cell Derivative Class"
    ) %>%
      dplyr::pull("name")
  } else {
    celltypes <- celltype_input
  }
  return(celltypes)
}

get_gene_nodes <- function(
    stratify,
    dataset,
    genes,
    tags,
    stratified_tags,
    min_abundance
){
  n_tags <- find_n_tags(stratify)

  if(n_tags == 1){
    nodes <-
      iatlasGraphQLClient::query_nodes(
        datasets = dataset,
        network = "Extracellular Network",
        entrez = genes,
        tag1 = tags,
        n_tags = n_tags,
        min_score = min_abundance / 100
      )
  }else{
    nodes <-
      iatlasGraphQLClient::query_nodes(
        datasets = dataset,
        network = "Extracellular Network",
        entrez = genes,
        tag1 = stratified_tags,
        tag2 = tags,
        n_tags = n_tags,
        min_score = min_abundance / 100
      )
  }

  nodes <- nodes %>%
    dplyr::select(
      "label" = "node_label",
      "tags" = "tag_1_name",
      "node_name" = "node_name",
      "node_display" = "gene_hgnc",
      "node_friendly" = "gene_friendly_name",
      "score" = "node_score"
    ) %>%
    #filter_nodes_for_n_tags(n_tags) %>%
    dplyr::mutate(
      "node_friendly" = as.character(.data$node_friendly),
      "node_friendly" = dplyr::if_else(
        is.na(.data$node_friendly),
        .data$node_display,
        .data$node_friendly
      )
    )
  #if(stratify) nodes <- filter_nodes_with_tag_name(nodes, stratified_tags)
  unnest_nodes(nodes, stratify)
}

get_feature_nodes <- function(
    stratify,
    dataset,
    features,
    tags,
    stratified_tags,
    min_abundance
){
  n_tags <- find_n_tags(stratify)
  min_score <- min_abundance / 100

  if(n_tags == 1){
    nodes <-
      iatlasGraphQLClient::query_nodes(
        datasets = dataset,
        network = "Extracellular Network",
        features = features,
        tag1 = tags,
        n_tags = n_tags,
        min_score = min_abundance / 100
      )
  }else{
    nodes <-
      iatlasGraphQLClient::query_nodes(
        datasets = dataset,
        network = "Extracellular Network",
        features = features,
        tag1 = stratified_tags,
        tag2 = tags,
        n_tags = n_tags,
        min_score = min_abundance / 100
      )
  }

  nodes <- nodes %>%
    dplyr::select(
      "label" = "node_label",
      "tags" = "tag_1_name",
      "node_name" = "node_name",
      "node_display" = "feature_display",
      "node_friendly" = "feature_display",
      "score" = "node_score"
    )
  #if(stratify) nodes <- filter_nodes_with_tag_name(nodes, stratified_tags)

  nodes <- unnest_nodes(nodes, stratify)

  return(nodes)
}

find_n_tags <- function(stratify){
  if(stratify) return(2)
  else return(1)
}

filter_nodes_for_n_tags <- function(data, n_tags){
  dplyr::filter(
    data,
    purrr::map_lgl(purrr::map_int(.data$tags, nrow), ~ .x == n_tags)
  )
}

filter_nodes_with_tag_name <- function(data, names){
  dplyr::filter(
    data,
    purrr::map_lgl(
      purrr::map(.data$tags, dplyr::pull, "name"), ~ any(names %in% .x)
    )
  )
}

unnest_nodes <- function(data, stratify){
  if(nrow(data) == 0) {
    data <- data %>%
      dplyr::mutate("tag" = character()) %>%
      dplyr::select(
        "label",
        "node_name",
        "node_display",
        "node_friendly",
        "tag",
        "score"
      )
    return(data)
  }

  result <- data %>%
    tidyr::unnest("tags") %>%
    dplyr::select(
      "label",
      "node_name",
      "node_display",
      "node_friendly",
      "tag" = "tags",
      "score"
    )

  if(stratify){
    result <- dplyr::filter(
      result, .data$tag %in% c("C1", "C2", "C3", "C4", "C5", "C6")
    )
  }
  return(result)
}

get_edges <- function(nodes, min_concordance){
  nodes <- dplyr::select(
    nodes, "node_name", "node_display", "node_friendly", "tag"
  )

  node_names <- nodes %>%
    dplyr::pull("node_name") %>%
    unique()

  edges <-
    iatlasGraphQLClient::query_edges(
      min_score = min_concordance,
      node1 = node_names,
      node2 = node_names
    )

  if(nrow(edges) == 0) return(edges)

  edges %>%
    dplyr::select("node1", "node2", "score") %>%
    dplyr::inner_join(nodes, by = c("node1" = "node_name")) %>%
    dplyr::select(
      "score",
      "node_display1" = "node_display",
      "node_friendly1" = "node_friendly",
      "node1",
      "node2"
    ) %>%
    dplyr::inner_join(nodes, by = c("node2" = "node_name")) %>%
    dplyr::select(
      "score",
      "node_display1",
      "node_friendly1",
      "node_display2" = "node_display",
      "node_friendly2" = "node_friendly",
      "node1",
      "node2",
      "tag"
    )
}

filter_nodes <- function(nodes, edges){
  edges_nodes <-
    c(edges$node1, edges$node2) %>%
    unique()

  nodes %>%
    dplyr::filter(.data$node_name %in% edges_nodes) %>%
    dplyr::arrange("node_friendly") %>%
    dplyr::select(
      "id" = "node_friendly",
      "Type" = "label",
      "Node" = "node_display",
      "FriendlyName" = "node_friendly",
      "Group" = "tag",
      "Abundance" = "score"
    ) %>%
    dplyr::distinct() %>%
    as.data.frame()
}

create_graph_json <- function(edges, nodes){

  edges <- edges %>%
    dplyr::select(
      "source" = "node_friendly1",
      "target" = "node_friendly2",
      "interaction" = "tag",
      "score"
    ) %>%
    as.data.frame()

  nodes <- dplyr::select(nodes, "id", "Type", "FriendlyName") %>% dplyr::distinct()

  cyjShiny::dataFramesToJSON(edges, nodes)
}
