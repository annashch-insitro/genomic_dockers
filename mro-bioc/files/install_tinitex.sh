Rscript -e 'install.packages("tinytex")' \
  && wget -qO- \
    "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
	&& mv ~/.TinyTeX /opt/TinyTeX \
	&& /opt/TinyTeX/bin/*/tlmgr path add \
	&& tlmgr install metafont mfware inconsolata tex ae parskip listings \
	&& tlmgr path add \
	&& Rscript -e "tinytex::r_texmf()" \
	&& chown -R root:staff /opt/TinyTeX \
	&& mkdir -p /opt/microsoft/ropen/$MRO_VERSION/lib64/R/site-library \
	&& chown -R root:staff /opt/microsoft/ropen/$MRO_VERSION/lib64/R/site-library \
	&& chmod -R g+w /opt/TinyTeX \
	&& chmod -R g+wx /opt/TinyTeX/bin \
	&& echo "PATH=${PATH}" >> /opt/microsoft/ropen/$MRO_VERSION/lib64/R/etc/Renviron \
	&& Rscript -e 'install.packages("PKI")'
