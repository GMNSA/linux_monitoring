# Используем официальный nginx образ в качестве базового образа
FROM ubuntu

USER root

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /home

# Копируем зависимости/пакеты проекта в образ
# COPY ./nginx/nginx.conf           /etc/nginx/nginx.conf
# COPY ./server/main.c              /home/
# COPY ./compile_run_mini_server.sh /home/

# Устанавливаем зависимости проекта
RUN apt-get update && apt-get install --yes gcc vim net-tools iproute2 procps systemd ipcalc bc file tzdata

# Запускаем compile_run_mini_server
