FROM php:7.3-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libyaml-dev \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install opcache \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-install zip

## Set "C.UTF-8" for UTF-8 Support. (e.g. Japanese.)
ENV LC_ALL C.UTF-8

# Configure Apache
#COPY etc/apache2/sites-available/grav.conf /etc/apache2/sites-available/grav.conf
RUN a2enmod rewrite expires && a2dissite 000-default && a2ensite grav

# Install GRAV (Default version: 1.4.2).
# If you want to install other version of GRAV,
# you can change this value by docker-compose.yml.
ARG GRAV_VERSION=1.4.2
RUN git clone -b ${GRAV_VERSION} https://github.com/getgrav/grav.git /var/www/html
RUN /var/www/html/bin/grav install
RUN /var/www/html/bin/gpm install admin -y

# Create New User.
# For more information, see https://github.com/getgrav/grav-plugin-login
ARG ADMIN_USER=admin
ARG ADMIN_PASSWORD=0Gravity
ARG ADMIN_EMAIL=admin@example.com
ARG ADMIN_PERMISSIONS=b
ARG ADMIN_FULLNAME="Sandra Bullock"
ARG ADMIN_TITLE=Administrator
RUN /var/www/html/bin/plugin login newuser \
  --user="${ADMIN_USER}" \
  --password="${ADMIN_PASSWORD}" \
  --email="${ADMIN_EMAIL}" \
  --permissions="${ADMIN_PERMISSIONS}" \
  --fullname="${ADMIN_FULLNAME}" \
  --title="${ADMIN_TITLE}"

# Change the owner of GRAV files because GRAV runs as "www-data" user.
RUN chown -R www-data:www-data /var/www/html
