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
RUN yum-config-manager --enable remi-php71

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
		php-intl \
		php-soap \
		php-gd \

		`# install the following PECL packages:` \
		php-pecl-memcached \
		php-pecl-mysql \
		php-pecl-xdebug \
		php-pecl-zip \
		php-pecl-amqp --nogpgcheck \
		php-pecl-apc \
		php-ssh2 \
		php-pecl-apcu \
		php-cli \

		`# Temporary workaround: one dependant package fails to install when building image (and the yum error is: Error unpacking rpm package httpd-2.4.6-40.el7.centos.x86_64` \
		|| true

# php-fpm
RUN yum -y install php-fpm
RUN rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm
RUN yum -y install nodejs npm jpegoptim
RUN npm install uglify-js -g
RUN npm install uglifycss -g
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php-fpm.d/www.conf
RUN sed -i 's/listen.allowed_clients = 127.0.0.1/;listen.allowed_clients = 127.0.0.1/g' /etc/php-fpm.d/www.conf

ADD docker/php/symfony.ini /etc/php.d/
ADD docker/php/symfony.ini /etc/php.d/

ADD docker/php/symfony.pool.conf /etc/php-fpm.d/www.conf

#ENV SYMFONY_ENV dev
#ENV ENVIRONMENT dev

RUN yum clean all
RUN rm -rf /tmp/*
RUN rm -rf /var/cache/*
