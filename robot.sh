#!/bin/bash

PATH="/home/pwuser/.local/bin:$PATH"
ROBOT_OUTPUT="${ROBOT_OUTPUT:-/home/pwuser/output}"
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
    echo -e "\nRunning in watch mode, robot will run on file change and by clicking on Run button from UI\n---\n"

    while true
    do
        fswatch --event=Updated --insensitive --exclude='.*\.log$' --recursive --one-event $ROBOT_ROOT_PATH /tmp/robot >/dev/null
        run_robot
    done

elif [[ "$ROBOT_RUN_MODE" == "button" ]]
then
    echo -e "\nRunning in button only mode, robot will run by clicking on Run button from UI\n---\n"

    while true
    do
        fswatch --event=Updated --one-event /tmp/robot >/dev/null
        run_robot
    done

elif [[ "$ROBOT_RUN_MODE" == "once" ]] || [ -z "$ROBOT_RUN_MODE" ]
then
    echo -e "\nRunning in run once mode\n---\n"

    run_robot
else
    echo -e "\nError: Invalid run mode ($ROBOT_RUN_MODE)\n"
    echo "1" > /tmp/exit
fi

curl --silent \
    --max-time 2 \
    --retry 5 \
    --retry-connrefused \
    --retry-delay 0 \
    --retry-max-time 10 \
    "http://127.0.0.1:80/exit"
