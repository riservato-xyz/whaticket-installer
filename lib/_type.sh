#!/bin/bash

get_type() {
  
  print_banner
  printf "${WHITE} 📂 What would you like to do with the file?${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] Stream\n"
  printf "   [2] Download\n"
  printf "   [3] Download + Stream\n"
  printf "\n"
  read -p "> " TYPE
}
