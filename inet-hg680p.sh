#!/bin/bash

# HG680P GPIO Wrapper
# by Lutfa Ilham
# mod by Adi Putra

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

SERVICE_NAME="Internet Indicator"

function loop() {
  while true; do
    hg680p.sh -lan warn
    if curl -X "HEAD" --connect-timeout 3 -so /dev/null "http://www.gstatic.com/generate_204"; then
      hg680p.sh -lan on
    else
      hg680p.sh -lan off
    fi
    sleep 1
  done
}

function loop2() {
  while true; do
    hg680p.sh -power on
    if curl -X "HEAD" --connect-timeout 3 -so /dev/null "http://www.gstatic.com/generate_204"; then
      hg680p.sh -power warn
    else
      hg680p.sh -power off
    fi
    sleep 1
  done
}


function start() {
  echo -e "Starting ${SERVICE_NAME} service ..."
  screen -AmdS internet-indicator "${0}" -l ; sleep 2;
  screen -AmdS internet-indicator "${0}" -ll
}

function stop() {
  echo -e "Stopping ${SERVICE_NAME} service ..."
  kill $(screen -list | grep internet-indicator | awk -F '[.]' {'print $1'})
}

function usage() {
  cat <<EOF
Usage:
  -r  Run ${SERVICE_NAME} service
  -s  Stop ${SERVICE_NAME} service
EOF
}

case "${1}" in
  -l)
    loop
    ;;
  -ll)
    loop2
    ;;
  -r)
    start
    ;;
  -s)
    stop
    ;;
  *)
    usage
    ;;
esac
