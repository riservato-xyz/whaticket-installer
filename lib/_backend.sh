#!/bin/bash
# 
# functions for setting up app backend

#######################################
# creates mysql db using docker
# Arguments:
#   None
#######################################
backend_mysql_create() {

  mysql_root_password=strongpassword
  mysql_password=whaticket

  sudo su - deploy <<EOF
  docker run --name whaticketdb \
             -e MYSQL_ROOT_PASSWORD=${mysql_root_password} \
             -e MYSQL_DATABASE=whaticket \
             -e MYSQL_USER=whaticket \
             -e MYSQL_PASSWORD=${mysql_password} \
             -p 3306:3306 \
             -d mariadb:latest \
             --restart always \
             --character-set-server=utf8mb4 \
             --collation-server=utf8mb4_bin
EOF
}

#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_env() {

  backend_url=https://api.mydomain.com
  frontend_url=https://myapp.mydomain.com

  db_user=whaticket
  db_pass=whaticket
  db_name=whaticket

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/whaticket/backend/.env
NODE_ENV=
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=443
PORT=8080

DB_HOST=localhost
DB_DIALECT=
DB_USER=${db_user}
DB_PASS=${db_pass}
DB_NAME=${db_name}

JWT_SECRET=3123123213123
JWT_REFRESH_SECRET=75756756756
[-]EOF
EOF
}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npm install
EOF
}

#######################################
# Ask for file location containing
# multiple URL for streaming.
# Globals:
#   WHITE
#   GRAY_LIGHT
#   BATCH_DIR
#   PROJECT_ROOT
# Arguments:
#   None
#######################################
backend_puppeteer_dependencies() {

  sudo su - deploy <<EOF
  sudo apt-get install -y libxshmfence-dev \
                          libgbm-dev \
                          wget \
                          unzip \
                          fontconfig \
                          locales \
                          gconf-service \
                          libasound2 \
                          libatk1.0-0 \
                          libc6 \
                          libcairo2 \
                          libcups2 \
                          libdbus-1-3 \
                          libexpat1 \
                          libfontconfig1 \
                          libgcc1 \
                          libgconf-2-4 \
                          libgdk-pixbuf2.0-0 \
                          libglib2.0-0 \
                          libgtk-3-0 \
                          libnspr4 \
                          libpango-1.0-0 \
                          libpangocairo-1.0-0 \
                          libstdc++6 \
                          libx11-6 \
                          libx11-xcb1 \
                          libxcb1 \
                          libxcomposite1 \
                          libxcursor1 \
                          libxdamage1 \
                          libxext6 \
                          libxfixes3 \
                          libxi6 \
                          libxrandr2 \
                          libxrender1 \
                          libxss1 \
                          libxtst6 \
                          ca-certificates \
                          fonts-liberation \
                          libappindicator1 \
                          libnss3 \
                          lsb-release \
                          xdg-utils
EOF
}

#######################################
# compiles backend code
# Arguments:
#   None
#######################################
backend_node_build() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npm install
  npm run build
EOF
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_update() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket
  git pull
  cd /home/deploy/whaticket/backend
  npm install
  rm -rf dist 
  npm run build
  #npx sequelize db:migrate
  #npx sequelize db:seed
  pm2 restart all
EOF
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
backend_db_migrate() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npx sequelize db:migrate
EOF
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
backend_db_seed() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npx sequelize db:seed:all
EOF
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2() {

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  sudo npm install -g pm2
  pm2 start dist/server.js --name whaticket-backend
EOF
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup() {

  backend_url=https://api.mydomain.com
  backend_url=$(echo "${backend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/whaticket-backend << 'END'
server {
  server_name $backend_url;

  location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}
END

sudo ln -s /etc/nginx/sites-available/whaticket-backend /etc/nginx/sites-enabled
EOF
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
backend_certbot_setup() {

  deploy_email=deploy@whaticket.com

  backend_url=https://api.mydomain.com
  backend_url=$(echo "${backend_url/https:\/\/}")

  frontend_url=https://myapp.mydomain.com
  frontend_url=$(echo "${frontend_url/https:\/\/}")

  echo $deploy_email
  echo $backend_url
  echo $frontend_url

  sudo su - root <<EOF
  certbot -m $deploy_email \
          --nginx \
          --agree-tos \
          --non-interactive \
          --domains $backend_url,$frontend_url
EOF
}
