FROM centos:7

# update yum
RUN yum -y update --nogpgcheck; yum clean all
RUN yum -y install yum-utils

# Install some must-haves
RUN yum -y install epel-release --nogpgcheck
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget --nogpgcheck
RUN yum -y install git --nogpgcheck
RUN yum -y install vim --nogpgcheck

# install remi repo
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm
RUN yum-config-manager --enable remi-php70

RUN yum install ImageMagick ImageMagick-devel ImageMagick-perl -y

# install php7
# breaking it down to see where dockerhub dies.
RUN \
	yum -y install \
		php php-common \
		php-mbstring \
		php-mcrypt \
		php-devel \
		php-xml \
		php-mysqlnd \
		php-pdo \
		php-opcache --nogpgcheck \
		php-bcmath \
    php-imagick \

		`# install the following PECL packages:` \
		php-pecl-memcached \
		php-pecl-mysql \
		php-pecl-xdebug \
		php-pecl-zip \
		php-pecl-amqp --nogpgcheck \

		`# Temporary workaround: one dependant package fails to install when building image (and the yum error is: Error unpacking rpm package httpd-2.4.6-40.el7.centos.x86_64` \
		|| true

# php-fpm
RUN yum -y install php-fpm
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

