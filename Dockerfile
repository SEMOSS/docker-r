#docker build . -t quay.io/semoss/docker-r:ubi8-rhel

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.8


FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} 

LABEL maintainer="semoss@semoss.org"

ENV R_VERSION=4.2.3
ENV R_LIBS_SITE=/opt/R/4.2.3/lib/R/library
ENV R_HOME=/opt/R
ENV RSTUDIO_PANDOC=/usr/lib/R/pandoc-2.17.1.1/bin
ENV PATH=$PATH:$R_HOME/$R_VERSION/bin:$R_LIBRARY:$RSTUDIO_PANDOC

# Install R
# 	(https://www.digitalocean.com/community/tutorials/how-to-install-r-on-debian-9)
# Reconfigure java for rJava
# Configure Rserve
# Install the following (needed for RCurl):
#	libssl-dev
#	libcurl4-openssl-dev
#	libxml2-dev
RUN cd ~/ \
	&& yum install -y less tk gcc bzip2-devel git gcc-c++ gcc-gfortran libSM libXmu libXt                  \
	libcurl-devel libicu-devel libtiff make openblas-threads pango pcre2-devel   \
	tcl xz-devel zip zlib-devel \
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& cd docker-r \
	&& git checkout ubi8  \
	&& chmod +x install_R.sh \
	&& /bin/bash install_R.sh \
	# && R CMD javareconf \
	&& cp -f Rserv.conf /etc/Rserv.conf \
	&& echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' > /opt/R/${R_VERSION}/lib/R/etc/Rprofile.site \
	&& cd .. \
	&& rm -r docker-r
# && cd /usr/lib/R \
# && arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
# && wget "https://github.com/jgm/pandoc/releases/download/2.17.1.1/pandoc-2.17.1.1-linux-${arch}.tar.gz" \
# && tar -xvf pandoc-2.17.1.1-linux-*.tar.gz 

WORKDIR /opt

CMD ["bash"]