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
        libpangocairo-1.0-0 \
		libcairo2-dev \
		libsqlite3-dev \
		libmariadbd-dev \
		libmariadbclient-dev \
		libpq-dev \
		libssh2-1-dev \
		unixodbc-dev \
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
    DOCKER_USER=docker \
    DOCKER_UID=1000 \
    DOCKER_GID=100 \
    HOME=/home/$DOCKER_USER

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $DOCKER_UID $DOCKER_USER && \
    chmod g+w /etc/passwd

WORKDIR /home/$DOCKER_USER

## Donwload and install MRO & MKL
COPY files/Rprofile.site $R_HOME/etc/Rprofile.site
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/Ubuntu/microsoft-r-open-$MRO_VERSION.tar.gz \
	&& tar -xzf microsoft-r-open-$MRO_VERSION.tar.gz\
	&& dpkg --install microsoft-r-open/deb/microsoft-r-open-mro-$MRO_VERSION.deb \
    && dpkg --install microsoft-r-open/deb/microsoft-r-open-mkl-$MRO_VERSION.deb \
    && rm microsoft-r-open-*.tar.gz \
	&& rm -r microsoft-r-open

RUN echo "export MKL_NUM_THREADS=\`nproc\`" >> ~/.bashrc && \
	echo "MKL_THREADING_LAYER=GNU" >> ~/.bashrc

CMD ["/usr/bin/R", "--no-save"]
