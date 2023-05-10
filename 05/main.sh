#!/bin/bash

# wc    (DESCRIPTION)
# -c 	--bytes 	Отобразить размер объекта в байтах
# -m 	--count 	Показать количесто символов в объекте
# -l 	--lines 	Вывести количество строк в объекте
# -w 	--words 	Отобразить количество слов в объекте
begin=`date +%s.%N`

s_color="\33[96m"
end_col="\33[0m";

# -------------------------------------------------------

function find_count_directories() {
    n_dir=$(find $1 -type d | wc -l)
    printf "${s_color}Total number of folders (including all nested ones) = $n_dir${end_col}\n"
}

# -------------------------------------------------------

function top_5_largest_fields_decreased() {
    #du $1 -h | sort -nr | head -5 | awk '{gsub(/^[0-9]+[.]?[0-9]+/, " & ")} {printf "%s - %s, %s %s\n", NR, $3, $1, $2}'
    du $1 -h | sort -nr | head -5 | awk '{printf "%s - %s, %s\n", NR, $2, $1}'
    printf "etc up to 5\n"
}

# -------------------------------------------------------

function find_count_files() {
    n_dir=$(find $1 -type f | wc -l)
    printf "${s_color}Total number of files = $n_dir${end_col}\n"
}

# -------------------------------------------------------

function find_config_files() {
    conf_files=$(find $1 -maxdepth 1 -type f -name '*.conf' | wc -l)
    printf "Configuration files (with the .conf extension) = %i\n" $conf_files

    text_files=$(file $1* | grep "text" | wc -l)
    printf "Text files = %i\n" $text_files

    exec_files=$(file $1* | grep "executable" | wc -l)
    printf "Executable files = %i\n" $exec_files

    log_files=$(find $1 -maxdepth 1 -type f -name '*.log' | wc -l)
    printf "Log files (with the extension .log) = %i\n" $log_files

    archive_files=$(file $1* | grep "archive" | wc -l)
    printf "Archive files = %i\n" $archive_files

    symbol_files=$(file $1* | grep " link " | wc -l)
    printf "Symbolic links = %i\n" $symbol_files
}

# -------------------------------------------------------

function top_10_largest_files_decreased() {
    printf "TOP 10 files of mzximum size arranged in descending order (path, size and type):\n"

    find . -maxdepth 1 -type f -exec du -ah {} \; | sort -r -n | head -10 | awk '
    BEGIN {i=1}

    # body
    {
        printf "%s - %s, ", i, $(2)
        split($(2), a, ".");
        if (length(a[3]) == 0) {
                printf "%s\n", $(1)
        } else {
            printf "%s, %s\n", $(1), a[3]
        }
        ++i;
    }
'

    printf "etc up to 10\n"
}

## -------------------------------------------------------

function top_10_largest_files_excecutables_decreased() {
    find $1 -maxdepth 1 -type f -printf "%p %s\n" | sort -nr -k2 | numfmt --to=iec --field=2 |  head -10 |  awk '
    { printf "%s %s\n", $1, $2}
    ' | awk '{
    f_exec = ("file " $1 " | grep executable")
    if ((f_exec | getline res) > 0) {
        #print length(res) " " $1 " \t" res
        cmd = "md5sum " $1
        (cmd | getline result )
        split(result, g, " ")
        printf "%s %s %s\n", $1, $2, g[1]
        }
    }' | nl | awk '{
        printf "%s - %s, %s, %s\n", $1, $2, $3, $4
    }'

    printf "etc up to 10\n"
}

## -------------------------------------------------------

#function script_execution_time() {
#    # ???
#}

# -------------------------------------------------------

function main() {
    if [ $# -eq 1 ]; then
        if [ -d "$1" ]; then
            #printf "\33[92mOK \33[95m$1\33[0m\n"
            if [ ${1: -1} = "/" ]; then
                find_count_directories $1
                top_5_largest_fields_decreased $1
                find_count_files $1
                find_config_files $1
                top_10_largest_files_decreased $1
                top_10_largest_files_excecutables_decreased $1
            else
                printf "\33[91mFAIL \33[93mDirectory must be end with \"/\"  \033[96m[example $0 /var/log/]\33[0m\n"
            fi
        else
            printf "\33[91mFAIL\33[0m \33[93m[Path not exist - $1]\33[0m\n"
        fi
    else
        printf "\33[91mFAIL \33[93mCount arguments is not valid! \033[96m[example $0 /var/log/]\33[0m\n"
    fi
}

main "$@"

end=`date +%s.%N`
execut_file=$(echo "$end-$begin" | bc -l | numfmt --format="%0.1f")
printf "Script execution time (in seconds) = %s\n" $execut_file
