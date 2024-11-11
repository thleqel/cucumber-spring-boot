#!/bin/bash

# Source the common and api scripts
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/api.sh"

# Check and install required software
check_and_install "curl"
check_and_install "jq"
check_and_install "unzip"
report_file="$CUCUMBER_REPORTS_PATH"

# Send a POST request
upload_result "$report_file"

# Read cucumber-report.json, find tags and execution time, and send a PUT request

if [ ! -f "$report_file" ]; then
    log_message "Report file not found: $report_file"
    exit 1
fi

jq -c '.[] | .elements[]' "$report_file" | while read -r scenario; do
    tags=$(echo "$scenario" | jq -r '.tags[].name' | tr '\n' ' ')
    name=$(echo "$scenario" | jq -r '.name')
    duration=$(echo "$scenario" | jq -r '.steps[].result.duration' | awk '{sum += $1} END {print sum / 1000000000}')
    test_case_key=$(echo "$tags" | grep -o '@TestCaseKey=[^ ]*' | sed 's/@TestCaseKey=//')
    log_message "Test case key: $test_case_key"
    log_message "Getting execution key for test case $test_case_key"
    get_execution_key $test_case_key
    log_message "Updating $EXECUTION_KEY with duration $duration"
    update_execution $EXECUTION_KEY $duration
done
