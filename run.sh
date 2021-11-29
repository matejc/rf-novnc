#!/usr/bin/env bash
set -e

chown -R pwuser:pwuser /home/pwuser/.config

mkdir -p /home/pwuser/logs
chmod -R o+rw /home/pwuser/logs

mkdir -p /usr/share/novnc/output
chmod -R o+rw /usr/share/novnc/output

trap 'kill $(cat /tmp/supervisord.pid)' EXIT
trap 'exit 0' SIGINT SIGTERM

exec supervisord --configuration=/etc/supervisord.conf
