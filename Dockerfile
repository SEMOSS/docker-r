#docker build . -t quay.io/semoss/docker-r:R4.2.1-debian11

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-tomcat
ARG BASE_TAG=debian11

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} 

LABEL maintainer="semoss@semoss.org"

ENV R_HOME=/usr/lib/R
ENV R_LIBS_SITE=/usr/local/lib/R/site-library
ENV RSTUDIO_PANDOC=/usr/lib/R/pandoc-2.17.1.1/bin
ENV PATH=$PATH:$R_HOME/bin:$R_LIBRARY:$RSTUDIO_PANDOC

# Install R
# 	(https://www.digitalocean.com/community/tutorials/how-to-install-r-on-debian-9)
# Reconfigure java for rJava
# Configure Rserve
# Install the following (needed for RCurl):
#	libssl-dev
#	libcurl4-openssl-dev
#	libxml2-dev
RUN apt-get -y update &&  apt -y upgrade \
	&& cd ~/ \
	&& apt-get install -y dirmngr software-properties-common apt-transport-https libssl-dev libcurl4-openssl-dev\
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& cd docker-r \
	&& git checkout R4.2.1-debian11  \
	&& chmod +x install_R.sh \
	&& /bin/bash install_R.sh \
	&& R CMD javareconf \
	&& cp -f Rserv.conf /etc/Rserv.conf \
	&& echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' >> /etc/R/Rprofile.site \
	&& cd .. \
	&& rm -r docker-r \
	&& cd /usr/lib/R \
	&& arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
    && wget "https://github.com/jgm/pandoc/releases/download/2.17.1.1/pandoc-2.17.1.1-linux-${arch}.tar.gz" \
	&& tar -xvf pandoc-2.17.1.1-linux-*.tar.gz \
	&& apt-get clean all

WORKDIR /opt

CMD ["bash"]
