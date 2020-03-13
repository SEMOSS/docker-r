FROM semoss/docker-tomcat:user

LABEL maintainer="semoss@semoss.org"

ENV R_LIBS_USER=/home/semoss/R/x86_64-pc-linux-gnu-library/3.5

# Install R
# 	(https://www.digitalocean.com/community/tutorials/how-to-install-r-on-debian-9)
# Reconfigure java for rJava
# Configure Rserve
# Install the following (needed for RCurl):
#	libssl-dev
#	libcurl4-openssl-dev
#	libxml2-dev
RUN sudo apt-get update \
	&& cd ~/ \
	&& sudo apt-get install -y dirmngr \
	&& sudo apt-get install -y software-properties-common \
	&& sudo apt-get install -y apt-transport-https \
	&& ( sudo apt-key adv --keyserver keys.gnupg.net --no-tty --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' || sudo apt-key adv --keyserver keyserver.pgp.com --no-tty --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' || sudo apt-key adv --keyserver pgp.mit.edu --no-tty --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' ) \
	&& sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian stretch-cran35/' \
	&& sudo apt-get update \
	&& sudo apt-get -y install r-base-core=3.5.2-1~stretchcran.0 --allow-downgrades \
	&& sudo apt-get -y install r-doc-html=3.5.2-1~stretchcran.0 --allow-downgrades \
	&& sudo apt-get -y install r-base-dev=3.5.2-1~stretchcran.0 --allow-downgrades \
	&& sudo R CMD javareconf \
	&& git clone https://github.com/SEMOSS/docker-r.git \
	&& sudo cp -f docker-r/Rserv.conf /etc/Rserv.conf \
	&& sudo apt install -y libssl-dev \
	&& sudo apt-get install -y libcurl4-openssl-dev \
	&& sudo apt-get install -y libxml2-dev \
	#&& sudo echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' >> /etc/R/Rprofile.site \
	&& sudo rm -r docker-r \
	&& sudo apt-get clean all \
	&& mkdir /home/semoss/R /home/semoss/R/x86_64-pc-linux-gnu-library /home/semoss/R/x86_64-pc-linux-gnu-library/3.5
	##&& mkdir ~/R/x86_64-pc-linux-gnu-library/3.5

WORKDIR /home/semoss

CMD ["bash"]
