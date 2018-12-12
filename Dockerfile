FROM semoss/docker-tomcat

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
	&& ( apt-key adv --keyserver keys.gnupg.net --no-tty --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' || apt-key adv --keyserver keyserver.pgp.com --no-tty --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' || apt-key adv --keyserver pgp.mit.edu --no-tty --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' ) \
	&& add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian stretch-cran35/' \
	&& apt-get update \
	&& apt-get install -y r-base \
	&& R CMD javareconf \
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& cp -f docker-r/Rserve.conf /etc/Rserve.conf \
	&& apt install -y libssl-dev \
	&& apt-get install -y libcurl4-openssl-dev \
	&& apt-get install -y libxml2-dev \
	&& echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' >> /etc/R/Rprofile.site \
	&& rm -r docker-r \
	&& apt-get clean all

WORKDIR /opt

CMD ["bash"]
