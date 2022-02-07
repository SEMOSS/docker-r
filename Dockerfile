#docker build . -t quay.io/semoss/docker-r:R4.1.2-debian11

ARG BASE_REGISTRY=quay.io
ARG BASE_IMAGE=semoss/docker-tomcat
ARG BASE_TAG=debian11

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
RUN apt-get -y update &&  apt -y upgrade \
	&& cd ~/ \
	&& apt-get install -y dirmngr \
	&& apt-get install -y software-properties-common \
	&& apt-get install -y apt-transport-https \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-key 'B8F25A8A73EACF41' \
	&& add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/' \
	&& apt-get update \
	&& apt-get -y install r-base-core=4.1.2-1~bullseyecran.0 --allow-downgrades linux-libc-dev- gcc-10- \
	&& apt-get -y install r-doc-html=4.1.2-1~bullseyecran.0 --allow-downgrades \
	&& R CMD javareconf \
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& cp -f docker-r/Rserv.conf /etc/Rserv.conf \
	&& apt install -y libssl-dev libcurl4-openssl-dev \
	&& echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' >> /etc/R/Rprofile.site \
	&& rm -r docker-r \
	&& cd /usr/lib/R \
	&& wget https://github.com/jgm/pandoc/releases/download/2.17.1.1/pandoc-2.17.1.1-linux-amd64.tar.gz \
	&& tar -xvf pandoc-2.17.1.1-linux-amd64.tar.gz \
	&& apt-get clean all

WORKDIR /opt

CMD ["bash"]
