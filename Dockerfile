FROM php:7.2.3-apache-stretch

# Install "git" and "lib*-dev" packages for GRAV installation.
# Also "sass" for compiling scss to css.
RUN apt-get update && apt-get install -y \
    git \
    libjpeg62-turbo-dev libpng-dev libfreetype6-dev \
    sass \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd zip

## Set "C.UTF-8" for UTF-8 Support. (e.g. Japanese.)
ENV LC_ALL C.UTF-8

# Configure Apache
COPY etc/apache2/sites-available/grav.conf /etc/apache2/sites-available/grav.conf
RUN a2enmod rewrite && a2dissite 000-default && a2ensite grav

# Install GRAV (Default version: 1.4.2).
# If you want to install other version of GRAV,
# you can change this value by docker-compose.yml.
ARG GRAV_VERSION=1.4.2
WORKDIR /var/www/grav
RUN git clone -b ${GRAV_VERSION} https://github.com/getgrav/grav.git /var/www/grav
RUN /var/www/grav/bin/grav install
RUN /var/www/grav/bin/gpm install admin -y

# Create New User. 
# For more information, see https://github.com/getgrav/grav-plugin-login
ARG ADMIN_USER=admin
ARG ADMIN_PASSWORD=0Gravity
ARG ADMIN_EMAIL=admin@example.com
ARG ADMIN_PERMISSIONS=b
ARG ADMIN_FULLNAME="Sandra Bullock"
ARG ADMIN_TITLE=Administrator
RUN /var/www/grav/bin/plugin login newuser \
  --user="${ADMIN_USER}" \
  --password="${ADMIN_PASSWORD}" \
  --email="${ADMIN_EMAIL}" \
  --permissions="${ADMIN_PERMISSIONS}" \
  --fullname="${ADMIN_FULLNAME}" \
  --title="${ADMIN_TITLE}"

# Change the owner of GRAV files because GRAV runs as "www-data" user.
RUN chown -R www-data:www-data /var/www/grav
