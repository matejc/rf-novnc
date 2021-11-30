#!/usr/bin/env bash
set -e

chown -R pwuser:pwuser /home/pwuser/.config

mkdir -p /home/pwuser/logs
chmod -R o+rw /home/pwuser/logs

mkdir -p /usr/share/novnc/output
chmod -R o+rw /usr/share/novnc/output

trap 'kill $(cat /tmp/supervisord.pid)' EXIT
trap 'exit 0' SIGINT SIGTERM

if [ -f /home/pwuser/requirements.txt ]
then
    su - pwuser -c "python3 -m pip install --user -r /home/pwuser/requirements.txt"
fi

exec supervisord --configuration=/etc/supervisord.conf
