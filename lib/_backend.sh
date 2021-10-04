#!/bin/bash
# 
# functions for setting up app backend

#######################################
# creates mysql db using docker
# Arguments:
#   None
#######################################
backend_mysql_create() {

  sudo su - deploy <<EOF
  docker run --name whaticketdb \
             -e MYSQL_ROOT_PASSWORD=strongpassword \
             -e MYSQL_DATABASE=whaticket \
             -e MYSQL_USER=whaticket \
             -e MYSQL_PASSWORD=whaticket \
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

  sudo su - deploy <<EOF
  NODE_ENV=
  BACKEND_URL=https://api.mydomain.com      #USE HTTPS HERE, WE WILL ADD SSL LATTER
  FRONTEND_URL=https://myapp.mydomain.com   #USE HTTPS HERE, WE WILL ADD SSL LATTER, CORS RELATED!
  PROXY_PORT=443                            #USE NGINX REVERSE PROXY PORT HERE, WE WILL CONFIGURE IT LATTER
  PORT=8080

  DB_HOST=localhost
  DB_DIALECT=
  DB_USER=
  DB_PASS=
  DB_NAME=

  JWT_SECRET=3123123213123
  JWT_REFRESH_SECRET=75756756756
EOF
}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {

  sudo su - deploy <<EOF
  cd whaticket/backend
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

  sudo su - business <<EOF
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
  cd whaticket/backend
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

  sudo su - business <<EOF
  git pull
  cd ./backend
  npm install
  rm -rf dist
  npm run build
  npx sequelize db:migrate
  npx sequelize db:seed
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
  cd whaticket/backend
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
  cd whaticket/backend
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
  cd whaticket/backend
  sudo npm install -g pm2
  pm2 start dist/server.js --name whaticket-backend
EOF
}

#######################################
# sets backend proxy configuration
# Arguments:
#   None
#######################################
backend_nginx_setup() {

  sudo su - deploy <<EOF
  sudo touch /etc/nginx/sites-available/whaticket-backend

  server {
    server_name api.mydomain.com;

    location / {
      proxy_pass http://127.0.0.1:8080;
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

  sudo ln -s /etc/nginx/sites-available/whaticket-backend /etc/nginx/sites-enabled
EOF
}
