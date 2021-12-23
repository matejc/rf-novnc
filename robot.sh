#!/bin/bash

PATH="/home/pwuser/.local/bin:$PATH"
ROBOT_OUTPUT="${ROBOT_OUTPUT:-/usr/share/novnc/output}"
ROBOT_ROOT_PATH="${ROBOT_ROOT_PATH:-/home/pwuser/source}"

# This will take down the whole process tree on script exit
trap "kill 0" EXIT
trap "exit" INT TERM

if [[ "$ROBOT_RUN_MODE" == "watch" ]]
then
    echo "Running in watch mode, robot will run on file change and by clicking on Run button from UI"

    while true
    do
        fswatch --event=Updated --insensitive --exclude='.*\.log$' --recursive --one-event $ROBOT_ROOT_PATH /tmp/robot >/dev/null
        robot $ROBOT_ARGS -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests
    done

elif [[ "$ROBOT_RUN_MODE" == "button" ]]
then
    echo "Running in button only mode, robot will run by clicking on Run button from UI"

    while true
    do
        fswatch --event=Updated --one-event /tmp/robot >/dev/null
        robot $ROBOT_ARGS -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests
    done

else
    echo "Running in run once mode"

    robot $ROBOT_ARGS -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests
fi

curl "http://127.0.0.1:10081/exit"
