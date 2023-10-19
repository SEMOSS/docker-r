yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
cd /opt
curl -O https://cdn.rstudio.com/r/centos-8/pkgs/R-${R_VERSION}-1-1.x86_64.rpm
yum -y install R-${R_VERSION}-1-1.x86_64.rpm
/opt/R/${R_VERSION}/bin/R --version
ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R
ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript
rm R-${R_VERSION}-1-1.x86_64.rpm