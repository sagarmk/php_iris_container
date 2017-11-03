# Ubuntu 14.04 with php 5.4 installed.
FROM ubuntu:14.04
MAINTAINER @sagarmankari


# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Our user in the container
USER root
WORKDIR /root

# Need to generate our locale.
RUN locale-gen de_DE de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE.UTF-8

# Enable PHP 5.4 repo and update apt-get
RUN echo "deb http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu precise main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update

# Install and Test PHP
RUN apt-get install --no-install-recommends -y \
		curl ca-certificates \
		php5-cli \
		php5-dev \
		php5-xdebug \
		php-apc \
		php5-json \
		php5-memcached php5-memcache \
		php5-mysql php5-pgsql \
		php5-sqlite php5-sybase php5-interbase php5-odbc \
		php5-mcrypt  \
		php5-ldap \
		php5-gmp  \
		php5-intl \
		php5-geoip \
		php5-imagick php5-gd \
		php5-imap \
		php5-curl \
		php5-svn \
		php5-ps \
		php5-ming \
		php5-enchant \
		php5-xsl \
		php5-xmlrpc \
		php5-tidy \
		php5-recode \
		php5-readline \
		php5-pspell \
		php-pear && \
		php --version && \
		php -m
		

# Install IRIS requirements
RUN	apt-get install zlib1g-dev libncurses5-dev && \
	wget -O  indri-5.4.tar.gz https://downloads.sourceforge.net/project/lemur/lemur/indri-5.4/indri-5.4.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flemur%2Ffiles%2Flemur%2Findri-5.4%2F&ts=1509711165&use_mirror=ayera && \
	tar -xvf indri-5.4.tar.gz && \
	cd indri-5.4 && \
	./configure && \
	make && \
	make install && \
	apt-get update && apt-get install mysql-server



# Tidy up
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install composer
RUN curl https://getcomposer.org/installer | php -- && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Allow mounting files
VOLUME ["/root"]

# PHP is our entry point
CMD ["/usr/bin/php"]
