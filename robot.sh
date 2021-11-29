#!/bin/bash
set -e

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
        fswatch --event=Updated --insensitive --exclude='.*\.log$' --recursive --one-event $ROBOT_ROOT_PATH >/dev/null
        robot $ROBOT_ARGS -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests || true
    done

else

    robot $ROBOT_ARGS -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests

fi
