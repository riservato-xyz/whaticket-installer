#!/bin/bash
# 
# functions for setting up app frontend

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_node_dependencies() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/frontend
  npm install
EOF
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_node_build() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/frontend
  npm install
  npm run build
EOF
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_update() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket
  git pull
  cd /home/deploy/whaticket/frontend
  npm install
  rm -rf build
  npm run build
  pm2 restart all
EOF
}


#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_set_env() {

  react_app_backend_url=whaticket

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy//home/deploy/whaticket/frontend/.env
REACT_APP_BACKEND_URL=${backend_url}
[-]EOF
EOF
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_start_pm2() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/frontend
  pm2 start server.js --name whaticket-frontend
  pm2 save
EOF
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_nginx_setup() {

  sudo su - deploy <<EOF
  sudo touch /etc/nginx/sites-available/whaticket-frontend

  server {
    server_name myapp.mydomain.com;

    location / {
      proxy_pass http://127.0.0.1:3333;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_cache_bypass $http_upgrade;
    }
  }

  sudo ln -s /etc/nginx/sites-available/whaticket-frontend /etc/nginx/sites-enabled
EOF
}
