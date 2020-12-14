# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
ARG PARENT_DOCKER
FROM "$PARENT_DOCKER"

ENV PATH=/opt/conda/bin:$PATH \
    CONDARC=/opt/conda/.condarc \
	CONDA_DIR=/opt/conda

	
RUN echo "CXX14 = g++ -std=c++1y -Wno-unused-variable -Wno-unused-function -fPIC" >> ~/.R/Makevars

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& apt-get install -yq --no-install-recommends \
	libmpfr-dev \
	tcl8.6-dev tk8.6-dev \
	libudunits2-dev \
	libproj-dev \
	libfribidi-dev \
	libharfbuzz-dev \
	aptitude \
	libgsl-dev \
	&& aptitude install -yq gdal-bin proj-bin libgdal-dev libproj-dev \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* \
	&& apt-get autoremove

WORKDIR /home/$DOCKER_USER

## Download and install Miniconda
COPY files/environment.yml /tmp/environment.yml
RUN curl -LO -# https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda3-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-latest-Linux-x86_64.sh &&\ 
	echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda update --quiet --yes conda && \
    conda env update -f /tmp/environment.yml -n base && \    
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \    
    jupyter notebook --generate-config && \    
    conda clean --all -f -y && \
    rm -rf ~/.cache/pip

# We aren't running a GUI, so force matplotlib to use
# the non-interactive "Agg" backend for graphics.
# Run matplotlib once to build the font cache.
ENV MATPLOTLIBRC=/home/$DOCKER_USER/.config/matplotlib/matplotlibrc
RUN mkdir -p /home/$DOCKER_USER/.config/matplotlib && \
    echo "backend      : Agg" > /home/$DOCKER_USER/.config/matplotlib/matplotlibrc && \
    python -c "import matplotlib.pyplot"

# Enable widgetsnbextension for jupyter widgets.
# See https://ipywidgets.readthedocs.io/en/stable/user_install.html.
# This enables the extension in the conda environment. The conda-forge version
# does this upon installation, but the default channel version doesn't seem to,
# so we'll run this (again) just in case.
RUN jupyter nbextension enable --py widgetsnbextension

# Instruct joblib to use disk for temporary files. Joblib defaults to
# /shm when that directory is present. In the Docker container, /shm is
# present but defaults to 64 MB.
# https://github.com/joblib/joblib/blob/0.11/joblib/parallel.py#L328L342
ENV JOBLIB_TEMP_FOLDER=/tmp


# Install R packages
# COPY files/install_genomics.R /tmp
# RUN Rscript /tmp/install_genomics.R

# RUN Rscript -e 'devtools::install_github("shmohammadi86/ACTIONet", ref = "R-release")'

RUN Rscript -e 'devtools::install_github("IRkernel/IRkernel")' && \
	jupyter kernelspec install /opt/microsoft/ropen/$MRO_VERSION/lib64/R/site-library/IRkernel/kernelspec --name 'R'
