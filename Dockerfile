ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-tomcat
ARG BASE_TAG=9.0.48

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} 

LABEL maintainer="semoss@semoss.org"

# Install R
# 	(https://www.digitalocean.com/community/tutorials/how-to-install-r-on-debian-9)
# Reconfigure java for rJava
# Configure Rserve
# Install the following (needed for RCurl):
#	libssl-dev
#	libcurl4-openssl-dev
#	libxml2-dev
RUN apt-get update \
	&& cd ~/ \
	&& apt-get install -y dirmngr \
	&& apt-get install -y software-properties-common \
	&& apt-get install -y apt-transport-https \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 'FCAE2A0E115C3D8A' \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-key 'B8F25A8A73EACF41' \
	&& add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran40/' \
	&& apt-get update \
	&& apt-get -y install r-base-core=4.1.0-1~bustercran.0 --allow-downgrades  linux-libc-dev- gcc-8- \
	&& apt-get -y install r-doc-html=4.1.0-1~bustercran.0 --allow-downgrades \
	&& R CMD javareconf \
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& cp -f docker-r/Rserv.conf /etc/Rserv.conf \
	&& apt install -y libssl-dev \
	&& apt-get install -y libcurl4-openssl-dev \
	#&& apt-get install -y libxml2-dev \
	&& echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' >> /etc/R/Rprofile.site \
	&& rm -r docker-r \
	&& cd /usr/lib/R \
	&& wget https://github.com/jgm/pandoc/releases/download/2.17.1.1/pandoc-2.17.1.1-linux-amd64.tar.gz \
	&& tar -xvf pandoc-2.17.1.1-linux-amd64.tar.gz \
	&& apt-get clean all

WORKDIR /opt

CMD ["bash"]
