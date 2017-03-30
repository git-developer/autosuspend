#!/bin/bash

command="$1"
shift

case "$command" in
    "activities")
        for activity in "$@"
        do
            echo "Activity: $activity"
        done
    ;;
    "wakeup_time")
        wakeup_time=$(date --date @$1 "+%Y-%m-%d %H:%M:%S")
        echo "Wakeup time: $wakeup_time"
    ;;
    *)
        echo "Ignoring unknown command $command"
    ;;
esac

