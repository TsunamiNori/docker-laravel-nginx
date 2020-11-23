#!/bin/sh

(rm -rf /root/.composer || true)

cd /var/www/html && chmod 777 -R storage/* && (php artisan cache:clear || true) && (php artisan config:clear || true)

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

echo "Get the web first time"
sleep 5 &&  curl http://127.0.0.1/ >> /home/result.txt

exec "$@"