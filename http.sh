#!/usr/bin/env bash

set -x

echo -en "HTTP/1.0 200 OK\r\n"

read -r line
case $line in
    GET\ \/exit\ HTTP\/1*)
        kill $(cat /tmp/supervisord.pid)
        ;;
    GET\ \/robot\ HTTP\/1*)
        date > /tmp/robot
        ;;
    *)
        exit 2
        ;;
esac
