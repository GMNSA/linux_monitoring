FROM ubuntu
USER root
WORKDIR /home
COPY ./01 /home
COPY ./02 /home
COPY ./03 /home
COPY ./04 /home
COPY ./05 /home
RUN apt-get update && apt-get install --yes vim net-tools iproute2 procps systemd ipcalc bc file
