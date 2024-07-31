#ARG R_VERSION
#FROM r-base:${R_VERSION}
FROM r-base:4.4.1

# Install supporting packages
RUN apt -y update
RUN apt -y install libpq-dev postgresql-client libcurl4-openssl-dev libssl-dev libxml2-dev gettext-base curl r-cran-xml libv8-dev cmake libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"

# Creating the home dir
RUN mkdir -p /home/iatlas-app
WORKDIR /home/iatlas-app
COPY renv.lock .
#COPY renv/activate.R renv/activate.R

ENV RENV_PATHS_LIBRARY renv/library
RUN R -e "renv::restore()"

ADD . /home/iatlas-app

EXPOSE 3838

# Run the app
CMD ["R", "--vanilla", "-e", "source('init.R'); shiny::runApp('/home/iatlas-app/', host='0.0.0.0', port=3838)"]

# helpful commands:
# sudo systemctl start docker
# docker compose up --build -d  # must have v2 compose
# docker compose watch          # docker is updated when source is updated
# docker system prune
# docker system prune -af  --filter "until=$((30*24))h"
