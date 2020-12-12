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
	
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& apt-get install -yq --no-install-recommends \
		ca-certificates \
		curl \
        wget \		
		sudo \
		locales \
		fonts-liberation \
		run-one \
		# MRO dependencies that don't sort themselves out on their own:
		less \
		libgomp1 \
		libpango-1.0-0 \
		libxt6 \
		libsm6 \
		# Needed for making C/C++ packages:
		make \
		cmake \
        automake \
		g++ \
        git \
        gfortran \
		build-essential \
		sudo \
		# misc libs
		libtinfo5 \
        libpq-dev \
        libffi-dev \
        libxrender1 \		
        libtool \
        libboost-program-options-dev \
        libcurl4-openssl-dev \
        libxml2-dev \
        libssl-dev \
		# extras
		locate \
		mc \
		vim \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

 	
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    BASH_ENV=/etc/profile \
    SHELL=/bin/bash \
    MRO_VERSION=4.0.2 \
    R_HOME=/opt/microsoft/ropen/$MRO_VERSION/lib64/R \
    PATH=/opt/conda/bin:$PATH \
    CONDARC=/opt/conda/.condarc \
	CONDA_DIR=/opt/conda \    
    NB_USER=docker \
    NB_UID=1000 \
    NB_GID=100 \
    HOME=/home/$NB_USER

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY files/fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME   

WORKDIR /home/$NB_USER

## Donwload and install MRO & MKL
COPY files/Rprofile.site $R_HOME/etc/Rprofile.site
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/Ubuntu/microsoft-r-open-$MRO_VERSION.tar.gz \
	&& tar -xzf microsoft-r-open-$MRO_VERSION.tar.gz\
	&& dpkg --install microsoft-r-open/deb/microsoft-r-open-mro-$MRO_VERSION.deb \
    && dpkg --install microsoft-r-open/deb/microsoft-r-open-mkl-$MRO_VERSION.deb \
    && rm microsoft-r-open-*.tar.gz \
	&& rm -r microsoft-r-open

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
    rm -rf ~/.cache/pip && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER    

# Install IRKernel
COPY files/install_IRKernel.R /tmp
RUN Rscript /tmp/install_IRKernel.R


# We aren't running a GUI, so force matplotlib to use
# the non-interactive "Agg" backend for graphics.
# Run matplotlib once to build the font cache.
ENV MATPLOTLIBRC=${HOME}/.config/matplotlib/matplotlibrc
RUN mkdir -p ${HOME}/.config/matplotlib && \
    echo "backend      : Agg" > ${HOME}/.config/matplotlib/matplotlibrc && \
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


# Runtime
EXPOSE 8888

# Configure container startup
COPY files/start/* /usr/local/bin/
COPY files/jupyter_notebook_config.py /etc/jupyter/
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
