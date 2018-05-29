FROM fedora:latest
RUN dnf install \
        --quiet \
        --assumeyes \
        httpd \
    && dnf --quiet clean all
RUN { \
        echo 'CustomLog /proc/self/fd/1 common'; \
        echo 'ErrorLog /proc/self/fd/2' ; \
    } > /etc/httpd/conf.d/local.conf
# Only log to stdout/stderr
RUN sed --in-place '/^\s*CustomLog\s/d' /etc/httpd/conf/httpd.conf

# Data directory
RUN mkdir /var/www/data \
    && chown apache:apache /var/www/data

VOLUME /var/www/html

EXPOSE 80






CMD httpd -C "ServerName $HOSTNAME" -D FOREGROUND
