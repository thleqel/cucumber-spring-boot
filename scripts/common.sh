#!/bin/bash

# Function to log a message
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Function to check if a software is installed, if not, install it
check_and_install() {
    local software=$1
    if ! command -v $software &> /dev/null
    then
        log_message "$software could not be found, installing..."
        sudo apt-get update
        sudo apt-get install -y $software
    else
        log_message "$software is already installed"
    fi
}