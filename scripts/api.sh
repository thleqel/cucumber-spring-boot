#!/bin/bash

upload_result() {
    local file_path=$1

    local description="Created automatically for test automation execution results"
    local token=$API_TOKEN
    local headers="Authorization: Bearer $token"
    local folder_id=$FOLDER_ID
    local test_cycle_prefix=$TEST_CYCLE_PREFIX
    local project_key=$PROJECT_KEY
    local timestamp=$(date +"%d/%m/%Y %H%M%S")
    local test_cycle_name="${test_cycle_prefix} ${timestamp}"
    local url="${BASE_URL}/automations/executions/cucumber"
    local params="projectKey=$project_key&autoCreateTestCases=false"

    local test_cycle=$(jq -n --arg name "$test_cycle_name" --arg desc "$description" --arg folderId "$folder_id" '{name: $name, description: $desc, folderId: $folderId}')
    local data="--form file=@$file_path --form testCycle=\"$test_cycle\";type=application/json"

    # Capture the response
    local response=$(curl -X POST "$url" -H "$headers" --data-urlencode "$params" -d "$data")

    # Extract the key using jq
    local key=$(echo "$response" | jq -r '.testCycle.key')

    # Export the key as an environment variable
    export TEST_CYCLE_KEY="$key"
}

get_execution_key() {
    local test_case_key=$1

    local token=$API_TOKEN
    local project_key=$PROJECT_KEY
    local headers="Authorization: Bearer $token"
    local params="projectKey=$project_key&testCase=$test_case_key&testCycle=$TEST_CYCLE_KEY"
    local url="${BASE_URL}/testexecutions"

    # Capture the response
    local response=$(curl -X GET "$url" -H "$headers" --data-urlencode "$params")

    # Extract the first execution key using jq
    local execution_key=$(echo "$response" | jq -r '.values[0].key')

    # Export the execution key as an environment variable
    export EXECUTION_KEY="$execution_key"
}

update_execution() {
    local test_execution_id_or_key=$1
    local execution_time=$2

    local token=$API_TOKEN
    local environment_name=$ENV
    local headers="Authorization: Bearer $token"
    local data=$(jq -n --arg env "$environment_name" --arg time "$execution_time" '{environmentName: $env, executionTime: $time}')
    local url="${BASE_URL}/testexecutions/${test_execution_id_or_key}"

    # Capture the response
    local response=$(curl -X PUT "$url" -H "$headers" -H "Content-Type: application/json" -d "$data")

    echo "$response"
}

# Example usage
# upload_result "/path/to/file"
# get_execution_key "TEST_CASE_KEY"
# update_execution "TEST_EXECUTION_ID_OR_KEY" "12345"