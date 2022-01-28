#!/usr/bin/env bash

set -x

echo "content-type: text/plain"
echo

case $DOCUMENT_URI in
    \/exit)
        kill $(cat /tmp/supervisord.pid)
        ;;
    \/stop)
        kill $(ps aux | grep '/home/pwuser/.local/bin/robot' | awk '{print $2}')
        ;;
    \/robot)
        include="$(echo "$QUERY_STRING" | grep -Eo 'include=[^\ &]*' | sed 's|include=||' | tr -cd '[:alnum:],._-')"
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

echo "ok"
exit 0
