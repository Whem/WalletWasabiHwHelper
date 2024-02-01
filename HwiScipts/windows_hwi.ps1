# Function to create a full-width colored line
function WriteColoredLine {
    param (
        [string]$text,
        [ConsoleColor]$backgroundColor,
        [ConsoleColor]$foregroundColor
    )

    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    $paddedText = $text.PadRight($windowWidth, ' ')
    Write-Host $paddedText -BackgroundColor $backgroundColor -ForegroundColor $foregroundColor
}

# Function to run a command and print its output, hiding exceptions
function RunCommand {
    param (
        [string]$command
    )
    
    WriteColoredLine "`nRunning command: $command" -BackgroundColor Yellow -ForegroundColor Black

    # Redirect error output to null and capture standard output
    $output = Invoke-Expression $command 2>$null
    WriteColoredLine "`nOutput: `n$output`n" -BackgroundColor DarkGreen -ForegroundColor White
    return $output
}

# Capture start time
$startTime = Get-Date

# Ask the user for the HWI directory
$hwiDirectory = Read-Host "Please enter the directory path where hwi.exe is located"

# Change to the HWI directory
Set-Location $hwiDirectory

# Run the HWI enumerate command
$enumCommand = ".\hwi.exe --expert enumerate"
$enumOutput = RunCommand -command $enumCommand

# Check if the output is empty or null
if ([string]::IsNullOrEmpty($enumOutput)) {
    Write-Host "No output received from the enumerate command."
    exit
}

# Parse the output
$devices = $enumOutput | ConvertFrom-Json

# Check if any device is found
if ($devices.Length -eq 0) {
    Write-Host "No devices found."
    exit
}

# Using the first device
$device = $devices[0]
$devicePath = $device.path
$deviceType = $device.model

# Display device info
WriteColoredLine "`nDevice Path: $devicePath`nDevice Type: $deviceType`n" -BackgroundColor DarkGray -ForegroundColor White

# Run the setup command in interactive mode
$setupCommand = ".\hwi.exe --device-path `"$devicePath`" --device-type `"$deviceType`" setup"
RunCommand -command $setupCommand | Out-Null

# Run the setup command in interactive mode
$setupCommand = ".\hwi.exe --device-path `"$devicePath`" --device-type `"$deviceType`" --interactive setup"
RunCommand -command $setupCommand | Out-Null

# Run the setup command in interactive mode
$setupCommand = ".\hwi.exe --device-path `"$devicePath`" --device-type `"$deviceType`" --interactive restore"
RunCommand -command $setupCommand | Out-Null

# Add additional commands as needed
# Example: Wiping the device (Uncomment the line below to use it)
$wipeCommand = ".\hwi.exe --device-path `"$devicePath`" --device-type `"$deviceType`" wipe"
RunCommand -command $wipeCommand | Out-Null

# Add additional commands as needed
# Example: Wiping the device (Uncomment the line below to use it)
$wipeCommand = ".\hwi.exe --device-path `"$devicePath`" --device-type `"$deviceType`" promptpin"
RunCommand -command $wipeCommand | Out-Null


# Example: Sending a PIN (Replace 111111 with the actual PIN)
$sendPinCommand = ".\hwi.exe --device-path `"$devicePath`" --device-type `"$deviceType`" sendpin 111111"
RunCommand -command $sendPinCommand | Out-Null

# Calculate and display elapsed time
$endTime = Get-Date
$elapsedTime = $endTime - $startTime
WriteColoredLine "`nTotal running time: $($elapsedTime.ToString())" -BackgroundColor White -ForegroundColor Black
