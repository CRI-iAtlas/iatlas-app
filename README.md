# Work-In-Progress

The shiny-iatlas repository is being migrated into two new repositories:

- iatlas-app (this repository) - for all the shiny-app R code
- iatlas-data - for all the iatlas-related data, DB-creation and DB-populating code

# iAtlas-App

The iAtlas app is an interactive web portal that provides multiple analysis modules to visualize and explore immune response characterizations across cancer types. The app is hosted on shinyapps.io at [https://isb-cgc.shinyapps.io/shiny-iatlas/](https://isb-cgc.shinyapps.io/shiny-iatlas/) and can also be accessed via the main CRI iAtlas page at [http://www.cri-iatlas.org/](http://www.cri-iatlas.org/).

The portal is built entirely in **R** and **Shiny** using the **RStudio** development environment. Layout and interactivity within the portal are achieved by heavy use of the following packages:

- [shinydashboard](https://rstudio.github.io/shinydashboard/)
- [plotly](https://plot.ly/r/)
- [crosstalk](https://rstudio.github.io/crosstalk/)

## Install

### Requirements

- R: https://www.r-project.org/ - v3.6.2

- RStudio: https://rstudio.com/products/rstudio/download

- Docker: https://www.docker.com/products/docker-desktop

  Ensure that the location of the repository is shared via docker:

  - Mac: https://docs.docker.com/docker-for-mac/#file-sharing

  - Windows: https://docs.microsoft.com/en-us/archive/blogs/stevelasker/configuring-docker-for-windows-volumes

- git-lfs: https://git-lfs.github.com

  For installation on the various platforms, please see this [git-lfs wiki](https://github.com/git-lfs/git-lfs/wiki/Installation)

  Some feather files are _very_ large. `git-lfs` is used to store these files.

  **Please note**: `git lfs install` _must_ be executed within the repository directory immediately after cloning the repo.

- libpq (postgres): https://www.postgresql.org/download/

- lib cairo: https://www.cairographics.org/ (only required for iAtlas client)

- gfortran (libgfortran): usually installed with gcc

### MacOS Install instructions

Install package manager: [HomeBrew](https://brew.sh/) (or [MacPorts](https://www.macports.org/) or your package manager of choice)

Then:

- xcode-select --install
- brew install R
- brew install cairo
- brew install git-lfs
- brew install postgres
- download and install RStudio: https://rstudio.com/products/rstudio/download
- download and install Docker: https://www.docker.com/products/docker-desktop

### Initialize R Packages, Database and run App

To run the app locally:

1. Clone this repository

1. Open `shiny-iatlas.Rproj`

1. Install packages. In the RStudio console, run:

   ```R
   renv::restore()
   ```

   This may take some time to complete - get something nice to drink :)

1. Build the database locally with the following:

   1. Make the database function available by executing the following in the R console:

      ```R
      source("iatlas_db.R")
      ```

   1. Build the database by executing the following in the R console:

      ```R
      build_iatlas_db(reset = "reset")
      ```

1. Start the app by running:

   ```R
   shiny::runApp()
   ```

## Branches: Staging & Master

We recommend the following workflow. When you are starting feature or project:

```shell
# checkout and get the latest from staging
git checkout staging
git pull

# create your new branch
git checkout -b feature/my-new-feature
# 'git checkout -b' is the same as:
# > git branch feature/my-new-feature
# > git checkout feature/my-new-feature

# do your work and commit your changes

# Keep up to date with changes on staging by others:
git checkout staging
git pull
git checkout feature/my-new-feature
git merge staging

# Ready to commit to staging?
git checkout staging
git pull # should be no changes, otherwise, update your branch as above
git merge feature/my-new-feature
git push
```

Once you update staging, our GitLab CI/CD will automatically deploy your changes to the staging server. Note: It can take 10-15 minutes to update.

* Staging Server: https://isb-cgc.shinyapps.io/iatlas-staging/

Once you validate everything is working in staging, the staging branch can be merged into master and then deployed to production. (TODO: expand on the production deployment process)

## Installing and Upgrading Packages

This project uses [renv](https://rstudio.github.io/renv/reference/install.html) to manage packages. The definitive list of required packages and versions is stored in the `renv.lock` file.

When adding any new dependencies to the application, they may be added using (where "useful_package" is the name of the package to add):

```R
# install a package
renv::install("useful_package")

# update the renv.lock file
renv::snapshot()
```

Git works will with renv. Once you validate the package should be kept, `git add renv.lock` to the repo and everyone else will automatically install it when they git-pull and re-open their R session or run renv::restore.

If you decide you don't want to include the package, just `git checkout renv.lock` to reset your dependencies to the point before you made changes.

To remove an installed package, run (where "useful_package" is the name of the package to remove):

```R
renv::remove("useful_package")
renv::snapshot()
```

And git-commit it once you are sure you want to keep the changes.


### Upgrading Packages

You can use renv::upgrade("package-name") to upgrade a package, but it'll always update to the very latest uniless you manually tell it otherwise.

* IMPORTANT: A few of the packages we currently use don't work with the latest versions, so **don't use renv::update to update all packages.**
* Known upgrade-problems:
  - don't upgrade shinycssloaders to v0.3.0
  - don't upgrade plotly to v4.9.2

### Installing Packages and RsConnect

This application is deployed using rsconnect::deployApp(). As of the current version (0.8.16-9000), rsconnect does not support using the renv.lock file to determin which packages to deploy. Instead, it uses its own till (rsconnect::appDependencies) to detect your app's dependencies from the R source files and the DESCRIPTION file. The good news is it will generally get the correct version, since it'll use the current version you have installed and renv manages that tightly. The bad news is sometimes it won't detect you need a package. Here's how you solve that problem:

* If a package is missing after you push to the staging branch and check the staging server, add that the package name to the `Imports:` section of the DESCRIPTION file.


## Deployment

The first time you deploy, go through the Deployment-Setup instructions. Afterwards, you can deploy with one line.

### Deployment Setup (First-Time-Only)

You'll need to set up your credentials for shinyapps.io. You can get your codes from:

- [https://www.shinyapps.io/admin/#/tokens](https://www.shinyapps.io/admin/#/tokens)

Paste and evaluate your tokens in the RStudio console. They look like this:

```R
# shinyapps.io example credentials
rsconnect::setAccountInfo(
  name='shiny-iatlas',
  token='xxx',
  secret='yyy'
)
```

### Deploy with RsConnect

Once your account info is set up, you can deploy with:

```R
rsconnect::deployApp()
```

## Data

Input data for the Shiny-iAtlas portal were accessed from multiple remote sources, including **Synapse**, the **ISB Cancer Genomics Cloud**, and **Google Drive**. For convenience, we have created locally cached versions of dataframe objects as **`feather`** files in the `data2` folder:

- `driver_mutations1.feather`
- `driver_mutations2.feather`
- `driver_mutations3.feather`
- `driver_mutations4.feather`
- `driver_mutations5.feather`
- `driver_results1.feather`
- `driver_results2.feather`
- `feature_values_long.feather`
- `features.feather`
- `groups.feather`
- `immunomodulator_expr.feather`
- `immunomodulators.feather`
- `io_target_expr1.feather`
- `io_target_expr2.feather`
- `io_target_expr3.feather`
- `io_target_expr4.feather`
- `io_targets.feather`
- `til_image_links.feather`

## Configuration and Environment Variables

The database connection is configured in the `config.yml` file. We use the [config package](https://github.com/rstudio/config) to load the correct config. See init.R for exactly how this is done. You can also override the config by setting these environment variables:

```
DB_NAME=XYZ
DB_HOST=XYZ
DB_PORT=123
DB_USER=XYZ
DB_PW=XYZ
```

WARNING! `config.yml` is part of the *public* git repository. Do NOT put sensitive passwords or keys in `config.yml`. Use environment variables for any passwords or keys you do not wish to share publicly.

## Methods

While many of the results presented in tables and plots are taken directly from IRWG data (including the main **feature matrix** and various feature and group annotations), we compute some values internally. Unless otherwise noted, the following methods/tools were used to compute summary statistics:

### Correlation — Spearman's rank-order correlation

```R
stats::cor(x, y, method = "spearman", use = "pairwise.complete.obs")
```

### Concordance Index (CI)

Concordance indexes for survival endpoints with respect to different immune readouts were computed using a custom package developed by Tai-Hsien Ou Yang at Columbia University. The **concordanceIndex** package includes a single synonymous function that can be used as follows:

```R
concordanceIndex::concordanceIndex(predictions, observations)
```

... where `predictions` and `observations` are numerical vectors of the same length.

## Troubleshooting

## Startup

To check if 'startup::startup()' ran successfully, type in `DB_HOST` and see if it is set to a non-blank value. For example:

```R
> DB_HOST
[1] "localhost"
```

> Note: You can also check your Global Environment under the "Environment" tab in the upper-right corner of the RStudio session.

The following should all be set: `DB_HOST`, `DB_NAME`, `DB_PORT`, `DB_PW` and `DB_USER`. If none of them are set, startup probably didn't succeed. The first thing to check what `.REnviron.d` folder startup is finding. Run:

```R
startup::startup(debug=TRUE)
```

Skip the first half of the output until you see this line:

- `x.xxxs: startup::startup()-specific processing...`

Just below you should see it loading the `./.Renviron.d` and later `./.Rprofile.d`. If yours says anything different than dot-slash-dot-Renviron-dot-d, startup is loading the wrong files.

- If you ran `startup::install` at some point, startup may have created these folders in your user directory. They are probably empty or simply the default values. If so, you can trash them. Then re-run startup with debug=TRUE and see if it works.

- Otherwise, you may need to check your R startup path and see why startup is finding the wrong files. Read more about it here: [https://cran.r-project.org/web/packages/startup/vignettes/startup-intro.html](https://cran.r-project.org/web/packages/startup/vignettes/startup-intro.html)

The tail end of your output should look like this:

```bash
0.005s: startup::startup()-specific processing ...
0.006s: Found startup directory ‘./.Renviron.d’.
0.010s: Processing 1 Renviron files ...
0.012s:  - ‘./.Renviron.d/rstudio=TRUE/.Renviron’ (1 lines; 8 bytes) setting 1 environment variables (‘ENV’)
0.013s: Processing 1 Renviron files ... done
0.016s: Found startup directory ‘./.Rprofile.d’.
0.019s: Processing 1 Rprofile files ...
0.020s:  - ‘./.Rprofile.d/ENV=dev.R’ (5 code lines; 264 bytes)
0.021s: Processing 1 Rprofile files ... done
0.022s: - unloading the ‘startup’ package
0.023s: - Search path: ‘.GlobalEnv’, ‘tools:rstudio’, ‘package:stats’, ‘package:graphics’, ‘package:grDevices’, ‘package:datasets’, ‘renv:shims’, ‘package:utils’, ‘package:methods’, ‘Autoloads’, ‘package:base’
0.023s: - Loaded namespaces: ‘compiler’, ‘graphics’, ‘tools’, ‘utils’, ‘grDevices’, ‘stats’, ‘datasets’, ‘methods’, ‘renv’, ‘base’
0.023s: startup::startup()-specific processing ... done
0.023s: The following will be processed next by R:
0.023s: - R_HISTFILE: ‘’
0.024s: - ‘./.Rhistory’ (0 lines; 0 bytes)
0.039s: - .First(): no such function on search()
0.039s: - Remaining packages per R_DEFAULT_PACKAGES to be attached by base::.First.sys() (in order):
```

## Database

- If you are initializing the database with `build_iatlas_db` and having a problem where it fails to connect after creating the tables, check that you are not running Postgress locally, outside of docker.