#!/usr/bin/env bash

# NginX reverse proxy for jenkins: https://gist.github.com/rdegges/913102
FQDN="jenkins.end-points.io"

sudo yum install nginx -y
sudo mkdir /etc/nginx/certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/key.key -out /etc/nginx/certs/cert.crt -subj "/C=CA/ST=Ontario/L=Concord/O=end-points.io/OU=DevOps/CN=$FQDN"

NGINX_CONFIG="
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
    use epoll;
    accept_mutex off;
}


http {
    include       /etc/nginx/mime.types;

    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    tcp_nopush     on;

    keepalive_timeout  65;

    client_max_body_size 300m;
    client_body_buffer_size 128k;

    gzip  on;
    gzip_http_version 1.0;
    gzip_comp_level 6;
    gzip_min_length 0;
    gzip_buffers 16 8k;
    gzip_proxied any;
    gzip_types text/plain text/css text/xml text/javascript application/xml application/xml+rss application/javascript application/json;
    gzip_vary on;
    gzip_disable \"MSIE [1-6]\.\";
    include /etc/nginx/conf.d/*.conf;
}
"
echo "$NGINX_CONFIG" | sudo tee /etc/nginx/nginx.conf

JENKINS_CONFIG="upstream jenkins {
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
    # Required for new HTTP-based CLI
    proxy_http_version 1.1;
    proxy_request_buffering off;
    proxy_buffering off; # Required for HTTP-based CLI to work over SSL
  }
}
"
echo "$JENKINS_CONFIG" | sudo tee /etc/nginx/conf.d/jenkins.conf

sudo service nginx restart

# Turn on to automatically nginx starting when instance is started
sudo chkconfig nginx on