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

ENV PATH=$PATH:/opt/TinyTeX/bin/x86_64-linux/ \
	S6_VERSION=v1.21.7.0 \
	RSTUDIO_VERSION=1.3.1093 \
	PATH=/usr/lib/rstudio-server/bin:$PATH \

RUN curl -LO -# "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb \
  && rm texlive-local.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for rJava
    #default-jdk \
    ## Nice Google fonts
    fonts-roboto \
    ## used by some base R plots
    ghostscript \
    ## used to build rJava and other packages
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    ## system dependency of hunspell (devtools)
    libhunspell-dev \
    ## system dependency of hadley/pkgdown
    libmagick++-dev \
    ## rdf, for redland / linked data
    librdf0-dev \
    ## for V8-based javascript wrappers
    libv8-dev \
    ## R CMD Check wants qpdf to check pdf sizes, or throws a Warning
    qpdf \
    ## For building PDF manuals
    texinfo \
    ## for git via ssh key
    ssh \
 	## just because
    less \
    vim \
 	## parallelization
    libzmq3-dev \
    libopenmpi-dev \
	# for updating package mgcv
	gfortran \
	# For devtools
	libgit2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

ADD files/* /scripts/

RUN /scripts/install_tinitex.sh
RUN Rscript /scripts/install_bioc.R
RUN Rscript /scripts/install_extras.R

# Install RStudio Server
RUN /scripts/install_rstudio.sh && \
	/scripts/install_pandoc.sh

