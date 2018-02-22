#!/usr/bin/env bash

JENKINS_DOMAIN_NAME=
NGINX_SSL_DIR="/etc/nginx/ssl/jenkins"
NGINX_SSL_KEY_NAME="nginx-selfsigned.key"
NGINX_SSL_CRT_NAME="nginx-selfsigned.crt"


# Create directory to store ssl certificates
sudo mkdir -p $NGINX_SSL_DIR

# Change working directory
sudo cd $NGINX_SSL_DIR

# Generate an SSL private key
# openssl req   	tool for generate CSR
# -nodes	        secret will not encrypt
# -newkey	        creating CSR и new secret key
# rsa:2048	        gen 2048 RSA key
# -keyout	        output file for new seret key
# -out	            output file for CSR
# -subj	            subject, need fot non interactive mode
    # /C=	Country
    # /ST=	State
    # /L=	Location
    # /O=	Organization
    # /OU=	Organizational Unit
    # /CN=	Common Name example.com
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $NGINX_SSL_DIR/$NGINX_SSL_KEY_NAME -out /etc/ssl/certs/$NGINX_SSL_CRT_NAME