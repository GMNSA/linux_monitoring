#!/bin/bash

function prepare_information() {
    HOSTNAME="HOSTNAME %-7s = $HOSTNAME"

    TIMEZONE="$(tr -d ' ' <<< "$(timedatectl | grep zone)")"
    TIMEZONE="TIMEZONE %-7s = ${TIMEZONE:9}"

    USER="USER %-11s = $(whoami)"

    OS=$(cat /etc/os-release  | grep NAME=\" | awk -F '=' 'NR==1 {print $2}' | awk -F '"' '{print $2}')
    OS="OS %-13s = ${OS}"

    DATE="DATE %-11s = $(date "+%d %B %Y %H:%M:%S")"
    UPTIME="UPTIME %-9s = $(uptime -p)"
    UPTIME_SEC="UPTIME_SEC %-5s = $(awk '{print $1}' /proc/uptime)"
    IP="IP %-13s = $(ip -br a | grep UP | awk 'NR==1 {print $3}' | awk -F '/' '{print $1}')"
    tmp_ip=$(ip -br a | grep UP | awk 'NR==1 {print $3}')
    MASK="MASK %-11s = $(ipcalc "$tmp_ip" | awk '/Netmask/ {print $2}')"

    GATEWAY="GATEWAY %-8s = $(ip r | grep default | awk '{print $3}')"
    RAM_TOTAL="RAM_TOTAL %-6s = $(free -m | grep Mem | awk '{printf "%.3f GB", $2/1024}')"
    RAM_USED="RAM_USED %-7s = $(free -m | grep Mem | awk '{printf "%.3f GB", $3/1024}')"
    RAM_FREE="RAM_FREE %-7s = $(free -m | grep Mem | awk '{printf "%.4f GB", $4/1024}')"
    SPACE_ROOT="SPACE_ROOT %-5s = $(df  | grep -E "/$" | awk '{printf "%.2f MB", $2/1024}')"
    SPACE_ROOT_USED="SPACE_ROOT_USED %-0s = $(df | grep -E "/$" | awk '{printf "%.2f MB", $3/1024}')"
    SPACE_ROOT_FREE="SPACE_ROOT_FREE %-0s = $(df | grep -E "/$" | awk '{printf "%.2f MB", $4/1024}')"
}

# -------------------------------------------------------

function print_information() {
    clear
    printf "$HOSTNAME\n"
    printf "$TIMEZONE\n"
    printf "$USER\n"
    printf "$OS\n"
    printf "$DATE\n"
    printf "$UPTIME\n"
    printf "$UPTIME_SEC\n"
    printf "$IP\n"
    printf "$MASK\n"
    printf "$GATEWAY\n"
    printf "$RAM_TOTAL\n"
    printf "$RAM_USED\n"
    printf "$RAM_FREE\n"
    printf "$SPACE_ROOT\n"
    printf "$SPACE_ROOT_USED\n"
    printf "$SPACE_ROOT_FREE\n"
}

# -------------------------------------------------------

function write_to_file() {
    echo -e "\n\n"
    read -p "Do you want to save data into file? ([Y|y]/n): " result
    is_write=0


    if [[ $result == "y" ]] || [[ $result == "Y" ]]; then
        is_write=1
        filename=$(date +"%d_%m_%y_%H_%M_%S.status")
        echo "$information" >> $filename
        echo "created file $filename"
    fi
}

# -------------------------------------------------------

function main() {
    prepare_information
    print_information

    information=$(print_information)

    write_to_file
}

# run ---------------------------------------------------

main
