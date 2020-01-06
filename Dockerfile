FROM php:7.3-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip zip libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libyaml-dev \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install opcache \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-install zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
		echo 'upload_max_filesize=128M'; \
		echo 'post_max_size=128M'; \
	} > /usr/local/etc/php/conf.d/php-recommended.ini

## Set "C.UTF-8" for UTF-8 Support. (e.g. Japanese.)
ENV LC_ALL C.UTF-8

# Configure Apache
#COPY etc/apache2/sites-available/grav.conf /etc/apache2/sites-available/grav.conf
RUN a2enmod rewrite expires
# && a2dissite 000-default && a2ensite grav


# Install grav
ARG GRAV_VERSION=latest
RUN curl -o grav-admin.zip -SL https://getgrav.org/download/core/grav-admin/${GRAV_VERSION} && \
    unzip grav-admin.zip -d /usr/src/ > /dev/null && \
    rm grav-admin.zip; \
    chown -R www-data:www-data /usr/src/grav-admin


# Create New User.
# For more information, see https://github.com/getgrav/grav-plugin-login
# ARG ADMIN_USER=dev
# ARG ADMIN_PASSWORD=Developer1
# ARG ADMIN_EMAIL=dev@dev.dev
# ARG ADMIN_PERMISSIONS=b
# ARG ADMIN_FULLNAME="Hagbard Cekube"
# ARG ADMIN_TITLE=God
# WORKDIR /var/www/html
# RUN /var/www/html/bin/plugin login newuser \
#   --user="${ADMIN_USER}" \
#   --password="${ADMIN_PASSWORD}" \
#   --email="${ADMIN_EMAIL}" \
#   --permissions="${ADMIN_PERMISSIONS}" \
#   --fullname="${ADMIN_FULLNAME}" \
#   --title="${ADMIN_TITLE}"



COPY docker-entrypoint.sh /usr/local/bin/

# WORKDIR is /var/www/html (inherited via "FROM php")
# "/entrypoint.sh" will populate it at container startup from /usr/src/matomo
VOLUME /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]