#!/bin/bash
#
# Print banner art.

#######################################
# Print a board. 
# Globals:
#   BG_BROWN
#   NC
#   WHITE
#   CYAN_LIGHT
#   RED
#   YELLOW
# Arguments:
#   None
#######################################
print_banner() {
  clear

  printf "\n\n"

  printf "             ${BG_BROWN}                                                     ${NC} 
             ${BG_BROWN}  ${NC}                                                 ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC} ${WHITE}I WILL NOT BE MEAN TO GOOD PEOPLE.${NC}              ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC} ${WHITE}I WILL NOT BE MEAN TO GOOD PEOPLE.${NC}              ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC} ${WHITE}I WILL NOT BE MEAN TO GOOD PEOPLE.${NC}              ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC} ${WHITE}I WILL NOT BE MEAN TO GOOD PEOPLE.${NC}              ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC} ${WHITE}I WILL NOT BE MEAN TO GOOD PEOPLE.${NC}              ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC} ${WHITE}I WILL NOT BE MEAN TO ${CYAN_LIGHT}G${RED}O${YELLOW}O${NC}                       ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC}                                                 ${BG_BROWN}  ${NC}
             ${BG_BROWN}  ${NC}                                           ${WHITE}━━━━${NC}  ${BG_BROWN}  ${NC}
             ${BG_BROWN}                                                     ${NC}

"

  printf "\n"
}
