# Contributing to CRI-iAtlas

Welcome, and thanks for your interest in contributing to the Cancer Research Institute (CRI) iAtlas!

If you would like to contribute code changes please follow these steps:

1. Search the issues list in the repo. Consider opening an issue related to the suggested feature.
2. Create a personal fork and commit new code development to personal branches in that fork.
3. Propose changes via pull request of personal branches.


In case the intended contribution consists of a new module, please refer to the following steps to include shortcuts of new modules in the Explore Section of CRI-iAtlas.

## Procedures for Starting a New iAtlas Module

Procedures to include a new module in the initial page of the Explore Section of the current version of the portal CRI-iAtlas. 

This procedure lists the files that need to be updated or started, as well as the functions to call, when applicable. There is no reference to a specific line to update, as this can change over time. 

### Steps

#### 1. Add module information at `inst/tsv/module_config.tsv`:

| display       | name       | type     | description               |
|---------------|------------|----------|---------------------------|
| My New Module | new_module | analysis | Description of new module |


- display: name displayed in the module selection menus.
- name: name used for internal reference (see steps 2, 3, and 4). 
- type: defines in which area of the Explore section of iAtlas the new module will be added to. Possible values: analysis, ici, tool, other.
- description: module description added in the main page of the Explore section in iAtlas.

#### 2. Create a `new_module_ui.R` and `new_module_server.R` in the `R` folder:

Please note that the name of these files should be in the format `[name]_ui.R` and `[name]_server.R`, where [name] is the *name* attribute added in (1).

#### 3.Format `new_module_ui.R`:

```
new_module_ui <- function(id) {

  ns <- shiny::NS(id)

# UI elements
}
```

#### 4.Format `new_module_server.R`:

If your module has *type = analysis*, the cohort object will be a required argument.

```
new_module_server <- function(id, cohort_obj){
  shiny::moduleServer(
    id,
    function(input, output, session) {

#in case you want to call a submodule and use the cohort_obj, use the call_module_server() function
      call_module_server(
       "desired_id" ,
        cohort_obj, ... )
    }
  )
}
```

For the other module types (tool and ici), `cohort_obj` is not a required input.

```
new_module_server <- function(id){

  shiny::moduleServer(
    id,
    function(input, output, session) {
      # code
    }
  )
}
```
