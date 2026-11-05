#!/bin/bash

# if anything fails -> exit
set -eou pipefail

# Constants
readonly SHORT_DELAY=1
readonly LONG_DELAY=2
readonly EXIT_FAILURE=1

# for checking if the user will have the programs like gh cli, jq etc
check_program() {
  if ! command -v "$1" > /dev/null 2>&1; then
    echo "${red}Looks like you don't have $1 (⌣́_⌣̀)${reset}"
    echo "Install $1 and come back."
    exit "${EXIT_FAILURE}"
  fi
}

check_program "VBoxManage"

start_vm() {
    VBoxManage startvm "UbuntuSERVER Clone" --type headless
}

close_vm() {
    VBoxManage controlvm "UbuntuSERVER Clone" poweroff --type headless
}

pause_vm() {
    VBoxManage controlvm "UbuntuSERVER Clone" pause --type headless
}

list_vms() {
    VBoxManage list vms
}
