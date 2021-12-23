#!/usr/bin/env bash

set -x

echo -en "HTTP/1.0 200 OK\r\n"

read -r line
case $line in
    GET\ \/exit\ HTTP\/1*)
        kill $(cat /tmp/supervisord.pid)
        ;;
    GET\ \/robot*\ HTTP\/1*)
        include="$(echo "$line" | grep -Eo 'include=[^\ &]*' | sed 's|include=||' | tr -cd '[:alnum:],._-')"
        if [ -z "$include" ]
        then
            echo > /tmp/robot
        else
            echo "--include $include" > /tmp/robot
        fi
        ;;
    *)
        exit 2
        ;;
esac
