#!/bin/bash

is_error=0

# 1 - white 2 - red 3 - green 4 - blue 5 - purple 6 black

function get_color_font() {
    res=""
    if [[ $1 -eq 1 ]]; then
        res="\033[37m"
    elif [[ $1 -eq 2 ]]; then
        res="\033[31m"
    elif [[ $1 -eq 3 ]]; then
        res="\033[32m"
    elif [[ $1 -eq 4 ]]; then
        res="\033[34m"
    elif [[ $1 -eq 5 ]]; then
        res="\033[35m"
    elif [[ $1 -eq 6 ]]; then
        res="\033[36m"
    fi

    echo $res
}

# -------------------------------------------------------

function get_color_background() {
    res=""
    if [[ $1 -eq 1 ]]; then
        res="\033[47m"
    elif [[ $1 -eq 2 ]]; then
        res="\033[41m"
    elif [[ $1 -eq 3 ]]; then
        res="\033[42m"
    elif [[ $1 -eq 4 ]]; then
        res="\033[44m"
    elif [[ $1 -eq 5 ]]; then
        res="\033[45m"
    elif [[ $1 -eq 6 ]]; then
        res="\033[46m"
    fi

    echo $res
}

# -------------------------------------------------------

function prepare_information() {
    b_c_b=$(get_color_background "$1")  # f_c_b - font_color_before
    f_c_b=$(get_color_font "$2")        # b_c_b - backgrond_color_before
    b_c_a=$(get_color_background "$3")  # f_c_a - font_color_after
    f_c_a=$(get_color_font "$4")        # b_c_a - backgrond_color_after
    end="\033[0m" # end color stream

    before_hostname=${f_c_b}${b_c_b}${f_c_b}HOSTNAME${end}
    before_timezone=${f_c_b}${b_c_b}TIMEZONE${end}
    before_user=${f_c_b}${b_c_b}USER${end}
    before_os=${f_c_b}${b_c_b}OS${end}
    before_date=${f_c_b}${b_c_b}DATE${end}
    before_uptime=${f_c_b}${b_c_b}UPTIME${end}
    before_uptime_sec=${f_c_b}${b_c_b}UPTIME_SEC${end}
    before_ip=${f_c_b}${b_c_b}IP${end}
    before_mask=${f_c_b}${b_c_b}MASK${end}
    before_gateway=${f_c_b}${b_c_b}GATEWAY${end}
    before_ram_total=${f_c_b}${b_c_b}RAM_TOTAL${end}
    before_ram_used=${f_c_b}${b_c_b}RAM_USED${end}
    before_ram_free=${f_c_b}${b_c_b}RAM_FREE${end}
    before_space_root=${f_c_b}${b_c_b}SPACE_ROOT${end}
    before_space_root_used=${f_c_b}${b_c_b}SPACE_ROOT_USED${end}
    before_space_root_free=${f_c_b}${b_c_b}SPACE_ROOT_FREE${end}

    TIMEZONE="$(tr -d ' ' <<< "$(timedatectl | grep zone)")"
    OS=$(hostnamectl | grep Operating)

    after_hostname=${f_c_a}${b_c_a}${f_c_a}$HOSTNAME${end}
    after_timezone=${f_c_a}${b_c_a}${TIMEZONE:9}${end}
    after_user=${f_c_a}${b_c_a}$(whoami)${end}
    after_os=${f_c_a}${b_c_a}${OS:18}${end}
    after_date=${f_c_a}${b_c_a}$(date "+%d %B %Y %H:%M:%S")${end}
    after_uptime=${f_c_a}${b_c_a}$(uptime -p)${end}
    after_uptime_sec=${f_c_a}${b_c_a}$(awk '{print $1}' /proc/uptime)${end}
    after_ip=${f_c_a}${b_c_a}$(ip -br a | grep UP | awk '{print $3} ')${end}
    after_mask=${f_c_a}${b_c_a}$(ip a | grep -A 4 UP | grep -E "inet " | grep brd | awk '{print $4}')${end}
    after_gateway=${f_c_a}${b_c_a}$(ip r | grep default | awk '{print $3}')${end}
    after_ram_total=${f_c_a}${b_c_a}$(free -m | grep Mem | awk '{printf "%.3f GB", $2/1024}')${end}
    after_ram_used=${f_c_a}${b_c_a}$(free -m | grep Mem | awk '{printf "%.3f GB", $3/1024}')${end}
    after_ram_free=${f_c_a}${b_c_a}$(free -m | grep Mem | awk '{printf "%.4f GB", $4/1024}')${end}
    after_space_root=${f_c_a}${b_c_a}$(df  | grep -E "/$" | awk '{printf "%.2f MB", $2/1024}')${end}
    after_space_root_used=${f_c_a}${b_c_a}$(df | grep -E "/$" | awk '{printf "%.2f MB", $3/1024}')${end}
    after_space_root_free=${f_c_a}${b_c_a}$(df | grep -E "/$" | awk '{printf "%.2f MB", $4/1024}')${end}

    # -------------------

    HOSTNAME="${before_hostname} %-7s = $after_hostname"
    TIMEZONE="${before_timezone} %-7s = $after_timezone"
    USER="${before_user} %-11s = $after_user"
    OS="${before_os} %-13s = $after_os"
    DATE="${before_date} %-11s = $after_date"
    UPTIME="${before_uptime} %-9s = $after_uptime"
    UPTIME_SEC="${before_uptime_sec} %-5s = $after_uptime_sec"
    IP="${before_ip} %-13s = $after_ip"
    MASK="${before_mask} %-11s = $after_mask"
    GATEWAY="${before_gateway} %-8s = $after_gateway"
    RAM_TOTAL="${before_ram_total} %-6s = $after_ram_total"
    RAM_USED="${before_ram_used} %-7s = $after_ram_used"
    RAM_FREE="${before_ram_free} %-7s = $after_ram_free"
    SPACE_ROOT="${before_space_root} %-5s = $after_space_root"
    SPACE_ROOT_USED="${before_space_root_used} %-0s = $after_space_root_used"
    SPACE_ROOT_FREE="${before_space_root_free} %-0s = $after_space_root_free"
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

function checking() {
    reg="^[0-9]+$"
    var=($2 $3 $4 $5)

    if [[ $1 -eq 4 ]]; then

        for i in ${!var[@]}; do
            if [[ ${var[i]} =~ $reg ]] && [[ ${var[i]} -le 6 ]] && [[ ${var[i]} -ge 1 ]]; then
                tmp=$(expr $i % 2)
                if [[ $tmp -ne 0 ]]; then
                    if [[ ${var[$((i - 1))]} -eq ${var[i]} ]]; then
                        printf "$((i + "1")) \33[91mERROR \033[93mthe background color and font should be different - \33[91m[${var[$((i - 1))]} don't equal ${var[i]}]\033[0m\n"
                        is_error=1
                    else
                        printf "$((i + "1")) \033[92mOK\033[0m\n"
                    fi
                else
                    printf "$((i + "1")) \033[92mOK\033[0m\n"
                fi
            else
                printf "$((i + "1"))\33[91m FAIL \33[93m[${var[i]}] is not number or more than 6\033[0m\n"
                is_error=1
            fi
        done
    else
        printf "\33[91mFAIL \33[93mCount arguments is not valid! \033[96m[example $0 1 2 3 4]\33[0m\n"
        is_error=1
    fi
}

# -------------------------------------------------------

checking "$#" "$1" "$2" "$3" "$4"

if [[ $is_error -ne 1 ]]; then
    prepare_information "$1" "$2" "$3" "$4"
    print_information
fi
