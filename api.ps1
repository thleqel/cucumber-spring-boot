function Upload-Result {
    param (
        [string]$filePath
    )

    $description = "Created automatically for test automation execution results"
    $token = $env:API_TOKEN
    $headers = @{ "Authorization" = "Bearer $token" }
    $folderId = $env:FOLDER_ID
    $testCyclePrefix = $env:TEST_CYCLE_PREFIX
    $projectKey = $env:PROJECT_KEY
    $timestamp = Get-Date -Format "dd/MM/yyyy HHmmss"
    $testCycleName = "$testCyclePrefix $timestamp"
    $url = "$env:BASE_URL/automations/executions/cucumber"
    $params = @{ "projectKey" = $projectKey; "autoCreateTestCases" = "false" }

    $testCycle = @{
        name = $testCycleName
        description = $description
        folderId = $folderId
    } | ConvertTo-Json

    $data = @{
        file = Get-Item $filePath
        testCycle = $testCycle
    }

    # Capture the response
    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Form $data

    # Extract the key using jq
    $key = $response.testCycle.key

    # Export the key as an environment variable
    $env:TEST_CYCLE_KEY = $key
}

function Get-ExecutionKey {
    param (
        [string]$testCaseKey
    )

    $token = $env:API_TOKEN
    $projectKey = $env:PROJECT_KEY
    $headers = @{ "Authorization" = "Bearer $token" }
    $params = @{ "projectKey" = $projectKey; "testCase" = $testCaseKey; "testCycle" = $env:TEST_CYCLE_KEY }
    $url = "$env:BASE_URL/testexecutions"

    # Capture the response
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -Body $params

    # Extract the first execution key using jq
    $executionKey = $response.values[0].key

    return $executionKey
}

function Update-Execution {
    param (
        [string]$testExecutionIdOrKey,
        [string]$executionTime
    )

    $token = $env:API_TOKEN
    $environmentName = $env:ENV
    $headers = @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" }
    $data = @{
        environmentName = $environmentName
        executionTime = $executionTime
    } | ConvertTo-Json
    $url = "$env:BASE_URL/testexecutions/$testExecutionIdOrKey"

    # Capture the response
    $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -Body $data

    return $response
}
