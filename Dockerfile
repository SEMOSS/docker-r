FROM tbanach/docker-tomcat

LABEL maintainer="semoss@semoss.org"

# Install R
# Reconfigure java for rJava
# Configure Rserve
# Install the following (needed for RCurl):
#	libssl-dev
#	libcurl4-openssl-dev
#	libxml2-dev
# Install R packages
RUN apt-get update \
	&& apt-get install -y r-base \
	&& R CMD javareconf \
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& cp -f docker-r/Rserve.conf /etc/Rserve.conf \
	&& apt install -y libssl-dev \
	&& apt-get install -y libcurl4-openssl-dev \
	&& apt-get install -y libxml2-dev \
	&& echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' >> /etc/R/Rprofile.site \
	&& mkdir /opt/status \
	&& mkdir /opt/status/R \
	&& wget --no-check-certificate --output-document=~/AnomalyDetectionV1.0.0.tar.gz https://github.com/twitter/AnomalyDetection/archive/v1.0.0.tar.gz \
	&& Rscript docker-r/Packages.R \
	&& rm AnomalyDetectionv1.0.0.tar.gz \
	&& rm -r docker-r \
	&& apt-get clean all

WORKDIR ~/

CMD ["bash"]