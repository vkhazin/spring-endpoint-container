# NginX reverse proxy for jenkins: https://gist.github.com/rdegges/913102
FQDN="jenkins.end-points.io"

sudo yum install nginx -y
sudo mkdir /etc/nginx/certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/key.key -out /etc/nginx/certs/cert.crt -subj "/C=CA/ST=Ontario/L=Concord/O=end-points.io/OU=DevOps/CN=$FQDN"

MAIN_CONFIG="user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    index   index.html index.htm;
}
"

CONFIG="upstream jenkins {
  server 127.0.0.1:8080 fail_timeout=0;
}

server {
  listen 80 default;
  server_name 127.0.0.1 $FQDN;
  rewrite ^ https://\$server_name\$request_uri? permanent;
}

server {
  listen 443 default ssl;
  server_name 127.0.0.1 $FQDN;

  ssl_certificate           /etc/nginx/certs/cert.crt;
  ssl_certificate_key       /etc/nginx/certs/key.key;

  ssl_session_timeout  5m;
  ssl_protocols  SSLv3 TLSv1;
  ssl_ciphers HIGH:!ADH:!MD5;
  ssl_prefer_server_ciphers on;

  location / {
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_redirect http:// https://;

    add_header Pragma \"no-cache\";

    proxy_pass http://jenkins;
  }
}
" 
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
echo "${MAIN_CONFIG}" | sudo tee /etc/nginx/nginx.conf
echo "${CONFIG}" | sudo tee /etc/nginx/conf.d/jenkins.conf

sudo service nginx restart
