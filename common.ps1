function Log-Message {
    param (
        [string]$message
    )
    Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - $message"
}

function Check-AndInstall {
    param (
        [string]$software
    )
    if (-Not (Get-Command $software -ErrorAction SilentlyContinue)) {
        Log-Message "$software could not be found, installing..."
        choco install $software -y
    } else {
        Log-Message "$software is already installed"
    }
}
