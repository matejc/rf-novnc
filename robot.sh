#!/bin/bash

PATH="/home/pwuser/.local/bin:$PATH"
ROBOT_OUTPUT="${ROBOT_OUTPUT:-/usr/share/novnc/output}"
ROBOT_ROOT_PATH="${ROBOT_ROOT_PATH:-/home/pwuser/source}"

# This will take down the whole process tree on script exit
trap "kill 0" EXIT
trap "exit" INT TERM

if [ ! -z "$ROBOT_WATCH" ]
then

    while true
    do
        fswatch --event=Updated --insensitive --exclude='.*\.log$' --recursive --one-event $ROBOT_ROOT_PATH /tmp/robot >/dev/null
        robot $ROBOT_ARGS -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests
    done

else

    robot $ROBOT_ARGS -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests

fi

curl "http://localhost:10081/exit"
