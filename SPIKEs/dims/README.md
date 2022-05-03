# DIMS

This directory contains information related to mod_dims which can be found [here](https://github.com/beetlebugorg/mod_dims/)

## What is DIMS

Dims is a webservice which allows for dynamic image manipulation.

### Dependencies

- Apache: Dims is installed and configured ontop of Apache
- ImageMagick 6.6.x: Used for image manipulation
- libcurl 7.18.x: Used to fetch remote images

## Lesson Learned

- Dims will need to run ontop of Apache
- The apache container for Brightspot is proxying request based on path.
- A custom docker image will need to be built to support Apache Dims.

### Example Apache config file

Apache configuration is located in /etc/apache2/config-enabled/

```sh
ServerName localhost

AllowEncodedSlashes NoDecode

RequestHeader setifempty "X-Forwarded-Proto" expr=%{REQUEST_SCHEME}

ProxyPreserveHost On
ProxyPassMatch ^/dims.* !
ProxyPassMatch ^/storage.* !
ProxyPassMatch ^/server-status.* !
ProxyPassMatch ^/.well-known.* !
ProxyPass / ${TOMCAT_URL} retry=0
ProxyPassReverse / ${TOMCAT_URL}

LogLevel warn
LogFormat "%h \"%{FORWARDED_IP}e\" \"%{X-Forwarded-For}i\" %u %t \"%r\" %>s %D \"%{Referer}i\" \"%{User-Agent}i\" %b %V" psd_combined
CustomLog /proc/self/fd/1 psd_combined
ErrorLog /proc/self/fd/1

# Set content-encoding: gzip header for .gz.js and .gz.css

RewriteEngine On
RewriteRule ^/storage.*\.gz\.(js|css)(\?.*)?$ - [ENV=SET_CEGZ:true]
Header set "Content-Encoding" "gzip" env=SET_CEGZ

DocumentRoot /var/www/localhost/htdocs/

<Location /storage/.cache>
    Require all denied
</Location>

<VirtualHost *:443>
  SSLEngine on
  SSLCertificateFile "/etc/apache2/ssl/server.crt"
  SSLCertificateKeyFile "/etc/apache2/ssl/server.key"

  RewriteRule ^/storage.*\.gz\.(js|css)(\?.*)?$ - [ENV=SET_CEGZ:true]
  Header set "Content-Encoding" "gzip" env=SET_CEGZ
</VirtualHost>
```

## Conclusion

It appears as though DIMS is required for Brightspot CMS. Images in the UI fail to load and this is believed to be due to the fact that DIMS is currently not being used.
At the end of the spike I have found myself coming to the conclusion that a custom Apache image will need to be built. Apache appears to ProxyPass requests for `/` to the Brightspot container. 
Looking at the default container used by mod_dims it appears as though Brightspot has built a custom image ontop of this container and have added custom configuration. When trying to integrate
the brightspot DIMS container, which is not production ready we are running into a problem where it is appending an additional /cms to the url which is causing the routing to fail. I believe before
attempting to tackle DIMS configuration we need to build an apache container and focus on just routing `/` to the Brightspot container. Once this is working we can then attempt to set the DIMS configuration
in `context.xml`.
