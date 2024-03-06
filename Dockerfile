#docker build . -t quay.io/semoss/docker-r:ubi8-rhel

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as builder

LABEL maintainer="semoss@semoss.org"
ENV R_VERSION=4.2.3
ENV R_LIBS_SITE=/opt/R/4.2.3/lib/R/library
ENV R_HOME=/opt/R/4.2.3
ENV RSTUDIO_PANDOC=/usr/lib/R/pandoc-2.17.1.1/bin

ENV PATH=$PATH:$R_HOME/bin:$R_LIBRARY:$RSTUDIO_PANDOC
RUN printenv | grep -E '^(R_VERSION|R_LIBS_SITE|R_HOME|RSTUDIO_PANDOC)=' | awk '{print "export " $0}' > /opt/set_env.env

COPY install_R.sh Rserv.conf /root/

RUN cd ~/ \
	&& yum install -y less tk gcc bzip2-devel git gcc-c++ gcc-gfortran libSM libXmu libXt \
	libcurl-devel libicu-devel libtiff make openblas-threads pango pcre2-devel \
	tcl xz-devel zip zlib-devel \
	&& chmod +x install_R.sh \
	&& /bin/bash install_R.sh \
	&& cp -f Rserv.conf /etc/Rserv.conf \
	&& echo 'options(repos = c(CRAN = "http://cloud.r-project.org/"))' > /opt/R/${R_VERSION}/lib/R/etc/Rprofile.site

RUN echo 'if [ -f /opt/set_env.env ]; then set -o allexport; source /opt/set_env.env; set +o allexport; fi' > /etc/profile.d/env.sh

FROM scratch AS final
COPY --from=builder / /
WORKDIR /opt
CMD ["bash"]
