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
    echo "Enter name of vm:"
    read -r vm_name
    echo "Initializing ${vm_name}!"
    VBoxManage startvm "${vm_name}" --type headless
    echo 
    run_gui
}

run_gui() {
    echo "Operate VM with GUI?: y/N"
    echo "1. Yes"
    echo "2. No"
    read -r decision

    if [[ $decision == "y" ]]; then
        VBoxManage controlvm "${vm_name}" gui
    else
        echo "Who needs a GUI anyways..."
    fi
}

close_vm() {
    echo "Enter name of vm:"
    read -r vm_name
    echo "Terminating ${vm_name}!"
    VBoxManage controlvm "${vm_name}" poweroff --type headless
}

pause_vm() {
    echo "Enter name of vm:"
    read -r vm_name
    echo "Pausing ${vm_name}!"
    VBoxManage controlvm "${vm_name}" pause --type headless
}

list_vms() {
    echo "Listing all vms:"
    VBoxManage list vms
}

dango_init(){
    echo "hello im dango !"
    sleep "${SHORT_DELAY}"
    echo "Select an operation (number): "
    echo
    echo "1. List VMs" 
    echo "2. Start VM" 
    echo "3. Stop VM"
    echo "4. Pause VM" 
    echo "5. Exit :-("
    read -r selection

    if [[ "$selection" == 1 ]]; then
        list_vms
    elif [[ ${selection} == 2 ]]; then
        start_vm
    elif [[ ${selection} == 3 ]]; then
        close_vm
    elif [[ ${selection} == 4 ]]; then
        pause_vm
    else
        echo "Well what did you start me up for..."
    fi
}

dango_init
