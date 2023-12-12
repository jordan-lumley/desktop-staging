#! /usr/bin/env bash

user_input() {
    RESULT=$(zenity --entry --title="$1" --text="$2")
    if [ -z "$RESULT" ]; then
        echo ""
        else 
        echo "$RESULT"
    fi
}

RES=$(user_input "Ubuntu Pro Key" "Please enter your Ubuntu Pro key:")
if [ -z "$RES" ]; then
    echo "No key provided, exiting..."
        else
    echo "Key provided: $RES"
fi
