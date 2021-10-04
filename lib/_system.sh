#!/bin/bash
# 
# system management

#######################################
# creates user
# Arguments:
#   None
#######################################
system_create_user() {

  deploy_password=123
  deploy_password=$(openssl passwd -crypt $deploy_password)

  sudo su - root <<EOF
  useradd -m -p $deploy_password -s /bin/bash -G sudo deploy
  usermod -aG sudo deploy
EOF
}

#######################################
# clones repostories using git
# Arguments:
#   None
#######################################
system_git_clone() {

  sudo su - deploy <<EOF
  git clone https://github.com/canove/whaticket /home/deploy/whaticket/
EOF
}

#######################################
# updates system
# Arguments:
#   None
#######################################
system_update() {

  sudo su - root <<EOF
  apt -y update && apt -y upgrade
EOF
}

#######################################
# installs node
# Arguments:
#   None
#######################################
system_node_install() {

  sudo su - root <<EOF
  curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  apt-get install -y nodejs
EOF
}

#######################################
# installs docker
# Arguments:
#   None
#######################################
system_docker_install() {

  sudo su - root <<EOF
  apt install -y apt-transport-https \
                 ca-certificates curl \
                 software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

  apt update
  apt install docker-ce

  systemctl status docker
  usermod -aG docker deploy
EOF
}

#######################################
# installs pm2
# Arguments:
#   None
#######################################
system_pm2_install() {

  sudo su - root <<EOF
  npm install -g pm2
  pm2 startup ubuntu -u deploy
  env PATH=\$PATH:/usr/bin pm2 startup ubuntu -u deploy --hp /home/deploy
EOF
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_snapd_install() {

  sudo su - root <<EOF
  apt update
  apt install snapd
  snap install core
  snap refresh core
EOF
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_certbot_install() {

  deploy_email=deploy@whaticket.com

  sudo su - root <<EOF
  apt-get remove certbot
  snap install --classic certbot
  ln -s /snap/bin/certbot /usr/bin/certbot
EOF
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_nginx_install() {

  sudo su - root <<EOF
  apt install nginx
  rm /etc/nginx/sites-enabled/default
EOF
}

#######################################
# restarts nginx
# Arguments:
#   None
#######################################
system_nginx_restart() {

  sudo su - root <<EOF
  nginx -t
  service nginx restart
EOF
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
system_nginx_conf() {

sudo su - root << EOF

cat > /etc/nginx/nginx.conf << 'END'
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    client_max_body_size 20M;
}
END

EOF
}
