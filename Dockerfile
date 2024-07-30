#ARG R_VERSION
#FROM r-base:${R_VERSION}
FROM r-base:latest

# Install supporting packages
RUN apt -y update
RUN apt -y install libpq-dev postgresql-client libcurl4-openssl-dev libssl-dev libxml2-dev gettext-base curl r-cran-xml libv8-dev cmake libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

# Creating the home dir
RUN mkdir -p /home/iatlas-app
# COPY renv.lock .
# COPY renv/activate.R renv/activate.R
ADD . /home/iatlas-app
WORKDIR /home/iatlas-app

# Resolve dependencies
# renv::restore()
# install(type='binary')
ENV DOCKERBUILD 1
RUN R -e "source(\"renv/activate.R\"); renv::restore()"

# Expose port
EXPOSE 3838

# Run the app
# CMD ["R", "-e", "shiny::runApp('/home/iatlas-app', host='0.0.0.0', port=3838)"]

# helpful commands:
# sudo systemctl start docker
# docker compose up --build -d  # must have v2 compose
# docker compose watch          # docker is updated when source is updated
# docker system prune
# docker system prune -af  --filter "until=$((30*24))h"
