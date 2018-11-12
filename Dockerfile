FROM tbanach/docker-tomcat

LABEL maintainer="semoss@semoss.org"

RUN apt-get update \
	&& apt install -y r-base \
	&& R CMD javareconf \
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& cp -f docker-r/Rprofile.site /etc/R/Rprofile.site \
	&& cp -f docker-r/Rserve.conf /etc/Rserve.conf \
	&& Rscript docker-r/Packages.R \
	&& rm -r docker-r \
	&& apt-get clean all





	&& apt-get install -y software-properties-common \
	# Need Java for rJava
	&& apt-get install -y  openjdk-8-jdk \
	&& apt install -y wget \
	&& apt install -y git \
	&& apt install -y procps \
	&& apt install -y r-base \
	&& R CMD javareconf \
	&& mkdir /opt/semosshome \
	# the open SSL libraries dont come pre-installed with debian
	&& apt install -y libssl-dev \
	&& apt install -y libcurl4-openssl-dev \
	&& apt install -y vim \
	&& cd /opt/semosshome \
	&& git clone https://github.com/prabhuk12/dockR \
	# to ensure it doesn't ask for CRAN
	&& cp /opt/semosshome/dockR/Rprofile.site /etc/R/Rprofile.site \
	&& cp /opt/semosshome/dockR/Rserve.conf /etc \
	&& Rscript /opt/semosshome/dockR/Packages.R \
	&& apt-get clean all

WORKDIR /opt/semosshome/dockR

CMD ["Rscript", "start.R"]