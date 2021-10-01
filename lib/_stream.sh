#!/bin/bash
# 
# Executes commands to stream URL.

exec_stream() {

  print_banner
  printf "${WHITE} 📺 Your stream will start soon...${NC}"
  printf "\n\n"

  case "${URL_TYPE}" in
    # single URL
    1) youtube-dl -o - "${URL}" "${ARGS}" | vlc - ;;

    # URL batch
    2) youtube-dl -a "${BATCH_DIR}" -o - "${ARGS}" | vlc - ;;

    *) exit ;;
  esac
}
