#!/bin/bash
#
# Ask for options

get_args() {
  
  print_banner
  printf "${WHITE} ⚙️  Is there any option to set?${GRAY_LIGHT} none"
  printf "\n\n"

  read -p "> " ARGS
}
