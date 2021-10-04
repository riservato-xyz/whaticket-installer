#!/bin/bash
#
# Variables to be used for background styling.

# app variables
readonly mysql_root_password=$(openssl rand -base64 32)
readonly mysql_password=$(openssl rand -base64 32)

readonly jwt_secret=$(openssl rand -base64 32)
readonly jwt_refresh_secret=$(openssl rand -base64 32)

readonly db_pass=$(openssl rand -base64 32)

readonly db_user=whaticket
readonly db_name=whaticket
