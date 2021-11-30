#!/usr/bin/env bash
set -e

trap 'kill $(cat /tmp/supervisord.pid)' EXIT
trap 'exit 0' SIGINT SIGTERM

while [ ! -f /home/pwuser/exit ]
do
    sleep 1
done
