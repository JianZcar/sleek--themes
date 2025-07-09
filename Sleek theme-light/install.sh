#!/bin/bash
ROOT_UID=0
THEME_DIR="/usr/share/grub/themes"
THEME_NAME="sleek"
MAX_DELAY=20

#colors
CDEF=" \033[0m"                                     # default color
CCIN=" \033[0;36m"                                  # info color
CGSC=" \033[0;32m"                                  # success color
CRER=" \033[0;31m"                                  # error color
CWAR=" \033[0;33m"                                  # warning color
b_CDEF=" \033[1;37m"                                # bold default color
b_CCIN=" \033[1;36m"                                # bold info color
b_CGSC=" \033[1;32m"                                # bold success color
b_CRER=" \033[1;31m"                                # bold error color
b_CWAR=" \033[1;33m"  

# echo like ...  with  flag type  and display message  colors
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;          # print success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;          # print error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;          # print warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;          # print info message
    *)
    echo -e "$@"
    ;;
  esac
}

# checking command availability
function has_command() {
  command -v $1 > /dev/null
}

prompt -w "\nChecking for root access...\n"
if [ "$UID" -eq "$ROOT_UID" ]; then
  prompt -i "\nChecking for the existence of themes directory...\n"
  [[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
  mkdir -p "${THEME_DIR}/${THEME_NAME}" 
  prompt -i "\nInstalling ${THEME_NAME} theme...\n"
  cp -a "$(dirname "$(realpath "$0")")/${THEME_NAME}/"* "${THEME_DIR}/${THEME_NAME}"

  #set theme
  prompt -i "\nSetting ${THEME_NAME} as default...\n"
  echo -e 'set theme=/usr/share/grub/themes/sleek/theme.txt\nexport theme\n' | tee -a /etc/grub.d/40_custom > /dev/null
  prompt -i "\n finalizing your installation .......\n \n."
  prompt -s "\n\t          ****************************\n\t          *  successfully installed  *\n\t          ****************************\n"
else

  # Error message
  prompt -e "\n [ Error! ] -> Run me as root  \n \n "

fi
