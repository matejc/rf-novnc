#!/bin/bash

PATH="/home/pwuser/.local/bin:$PATH"
ROBOT_OUTPUT="${ROBOT_OUTPUT:-/usr/share/novnc/output}"
ROBOT_ROOT_PATH="${ROBOT_ROOT_PATH:-/home/pwuser/source}"

run_robot() {
    robot $ROBOT_ARGS $(cat /tmp/robot) -d $ROBOT_OUTPUT $ROBOT_ROOT_PATH/tests
    echo $? > /tmp/exit
    echo -e "\nExited with $(cat /tmp/exit)\n---\n"
    echo > /tmp/robot
}

# This will take down the whole process tree on script exit
trap "kill 0" EXIT
trap "exit" INT TERM

if [[ "$ROBOT_RUN_MODE" == "watch" ]]
then
    echo -e "Running in watch mode, robot will run on file change and by clicking on Run button from UI\n---\n"

    while true
    do
        fswatch --event=Updated --insensitive --exclude='.*\.log$' --recursive --one-event $ROBOT_ROOT_PATH /tmp/robot >/dev/null
        run_robot
    done

elif [[ "$ROBOT_RUN_MODE" == "button" ]]
then
    echo -e "Running in button only mode, robot will run by clicking on Run button from UI\n---\n"

    while true
    do
        fswatch --event=Updated --one-event /tmp/robot >/dev/null
        run_robot
    done

else
    echo -e "Running in run once mode\n---\n"

    run_robot
fi

curl "http://127.0.0.1:10081/exit"
