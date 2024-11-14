# Load the common and api scripts
. "$(Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)\common.ps1"
. "$(Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)\api.ps1"

# Check and install required software
Check-AndInstall "curl"
Check-AndInstall "jq"
Check-AndInstall "unzip"
$reportFile = $env:CUCUMBER_REPORTS_PATH

# Send a POST request
Upload-Result -filePath $reportFile

# Read cucumber-report.json, find tags and execution time, and send a PUT request
if (-Not (Test-Path $reportFile)) {
    Log-Message "Report file not found: $reportFile"
    exit 1
}

$scenarios = Get-Content $reportFile | ConvertFrom-Json | ForEach-Object { $_.elements } | ForEach-Object { $_ }
foreach ($scenario in $scenarios) {
    $tags = $scenario.tags.name -join ' '
    $name = $scenario.name
    $duration = ($scenario.steps.result.duration | Measure-Object -Sum).Sum / 1000000000
    $testCaseKey = $tags -match '@TestCaseKey=([^ ]+)' | Out-Null; $matches[1]
    Log-Message "Test case key: $testCaseKey"
    Log-Message "Getting execution key for test case $testCaseKey"
    $executionKey = Get-ExecutionKey -testCaseKey $testCaseKey
    Log-Message "Updating $executionKey with duration $duration"
    Update-Execution -testExecutionIdOrKey $executionKey -executionTime $duration
}
