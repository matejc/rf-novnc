#!/usr/bin/env bash
set -e

chown -R pwuser:pwuser /home/pwuser/.config

mkdir -p /home/pwuser/logs
chmod -R o+rw /home/pwuser/logs

mkdir -p /usr/share/novnc/output
chmod -R o+rw /usr/share/novnc/output

function exit_with_code {
    if [ -f /tmp/exit ]
    then
        exit $(cat /tmp/exit)
    fi
    exit 0
}

trap 'kill 0' EXIT
trap exit_with_code SIGINT SIGTERM

supervisord --configuration=/etc/supervisord.conf
