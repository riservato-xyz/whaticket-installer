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

  sudo su - deploy <<EOF
  sudo npm install -g pm2
  pm2 startup ubuntu -u $(whoami)
  sudo env PATH=\$PATH:/usr/bin \
       pm2 startup ubuntu -u $(whoami) --hp /home/$(whoami)
EOF
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_snapd_install() {

  sudo su - deploy <<EOF
  sudo apt update
  sudo apt install snapd
  sudo snap install core
  sudo snap refresh core
EOF
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_certbot_install() {

  sudo su - deploy <<EOF
  sudo apt-get remove certbot
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot
  sudo certbot --nginx
EOF
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_nginx_install() {

  sudo su - deploy <<EOF
  sudo apt install nginx
  sudo rm /etc/nginx/sites-enabled/default
EOF
}

#######################################
# restarts nginx
# Arguments:
#   None
#######################################
system_nginx_restart() {

  sudo su - deploy <<EOF
  sudo nginx -t
  sudo service nginx restart
EOF
}
