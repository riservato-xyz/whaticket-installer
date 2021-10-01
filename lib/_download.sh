#!/bin/bash
# 
# Manages and starts download.

get_destination() {
  print_banner
  printf "${WHITE} 📨 Destination:${GRAY_LIGHT} ~/Videos"
  printf "\n\n"
  read -p "> " DIR

  if [ -z "${DIR}" ]; then 
    DIR="~/Videos";
  elif [[ ${DIR} =~ "./" ]]; then
    DIR="~/Videos/${DIR}"; 
  fi

  readonly DIR
}

start_download() {

  print_banner
  printf "${WHITE} 📩 Your download will start soon...${NC}"
  printf "\n\n"

  # stream after downloading?
  if [ "${TYPE}" == 3 ] ; then 
    ARGS="${ARGS} --exec vlc"
  fi

  # single or batch download?
  case "${URL_TYPE}" in
    1) # single url
      youtube-dl "${URL}" -o "${DIR}/%(autonumber)s-%(title)s.%(ext)s" "${ARGS}"
      ;;

    2) # URL batch
      youtube-dl -a "${BATCH_DIR}" -o "${DIR}/%(autonumber)s-%(title)s.%(ext)s" "${ARGS}" 
      ;;
      
    *) exit ;;
  esac
}

exec_download() {
  get_destination
  start_download
}
