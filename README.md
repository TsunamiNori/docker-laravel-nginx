# Docker PHP-FPM 7.3 & Nginx 1.18 & Laravel on Alpine Linux
Base PHP-FPM 7.3 & Nginx 1.18 & Laravel (with Composer) setup for Docker, build on [Alpine Linux](http://www.alpinelinux.org/).


## Usage

Start the Docker container:

    docker run -p 80:80 tsunaminori/laravel-nginx

Mount your own code to be served by PHP-FPM & Nginx

    docker run -p 80:80 -v /path/to/your/code:/var/www/html tsunaminori/laravel-nginx

## Configuration
In [config/](config/) you'll find the default configuration files for Nginx, PHP and PHP-FPM.
If you want to extend or customize that you can do so by mounting a configuration file in the correct folder;

Nginx configuration:

    docker run -v "`pwd`/nginx-server.conf:/etc/nginx/conf.d/server.conf" tsunaminori/laravel-nginx

PHP configuration:

    docker run -v "`pwd`/php-setting.ini:/etc/php7/conf.d/settings.ini" tsunaminori/laravel-nginx

PHP-FPM configuration:

    docker run -v "`pwd`/php-fpm-settings.conf:/etc/php7/php-fpm.d/server.conf" tsunaminori/laravel-nginx

_Note; Because `-v` requires an absolute path I've added `pwd` in the example to return the absolute path to the current directory
