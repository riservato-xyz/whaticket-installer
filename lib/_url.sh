#!/bin/bash
# 
# Manages URLs to be used later by youtube-dl.

get_single_url() {
  print_banner
  printf "${WHITE} 🔗 Type in video URL:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " URL

  # replaces "@y" keyword by Invidious's domanin
  if [[ "${URL}" == *"@y "* ]]; then
    URL="${URL/@y /'https://invidious.snopyta.org/watch?v='}"
  fi
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
get_batch_url() {
  print_banner
  printf "${WHITE} 📄 Batch file location:${GRAY_LIGHT} default-bl.txt"
  printf "\n\n"
  read -p "> " BATCH_DIR

  if [ -z "${BATCH_DIR}" ]; then 
    BATCH_DIR="${PROJECT_ROOT}"/default-bl.txt
    echo "${BATCH_DIR}"
  fi
}

get_url() {
  
  print_banner
  printf "${WHITE} 🧐 How would you like to do it?${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] Single URL\n"
  printf "   [2] URL batch file\n"
  printf "\n"
  read -p "> " URL_TYPE

  case "${URL_TYPE}" in
    1) get_single_url ;;

    2) get_batch_url ;;

    *) exit ;;
  esac
}
