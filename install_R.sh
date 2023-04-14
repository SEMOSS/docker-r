arch=$(uname -m)
if [[ $arch == x86_64* ]]; then
    echo "X64 Architecture"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 'B8F25A8A73EACF41'
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key '51716619E084DAB9'
	add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/'
	apt-get update
	apt-get -y install r-base-core=4.2.3-1.2204.0 --allow-downgrades linux-libc-dev- gcc-10-
	apt-get -y install r-doc-html=4.2.3-1.2204.0 --allow-downgrades
elif  [[ $arch == arm* ]] || [[ $arch = aarch64 ]]; then
    echo "ARM Architecture"
    echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list
    apt-get update
    apt-get -y install r-base-core=4.2.2-1+b1 --allow-downgrades linux-libc-dev- gcc-10-
    apt-get -y install r-doc-html=4.2.2-1+b1 --allow-downgrades
    rm /etc/apt/sources.list.d/debian-unstable.list
    apt-get update
fi
