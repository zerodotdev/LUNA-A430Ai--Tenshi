$Host.UI.RawUI.WindowTitle = "LUNA-A430Ai | Version 1.0.0.0 "
$Host.UI.RawUI.BackgroundColor = 'White';
$Host.UI.RawUI.ForegroundColor = 'Black';

Clear-Host

# The secondary color
$AltColor = "DarkBlue"
$DevColor = "Black"
$SystemColor = "Black"
$TitleColor = "DarkBlue"
$TitleSecretColor = "Black"

# add dynamic title time here:

# Path to the "Alarm 09" sound file
$alarmSound = "C:\Windows\Media\Alarm09.wav"

# Create a SoundPlayer object
$player = New-Object System.Media.SoundPlayer
$player.SoundLocation =# Initialize variables for hours, minutes, and seconds
$alarmSound
function Hide-Cursor {
    $type = [type]::GetType("System.Console,mscorlib")
    $cursorProperty = $type.GetProperty("CursorVisible")
    $cursorProperty.SetValue($null, $false)
}

function Show-Cursor {
    $type = [type]::GetType("System.Console,mscorlib")
    $cursorProperty = $type.GetProperty("CursorVisible")
    $cursorProperty.SetValue($null, $true)
}

# Function to play a click sound asynchronously

$SoundFilePath = "C:\LUNA-A430Ai\resourses\typeclick.wav"
function Play-ClickSound {
    param (
        [string]$soundFilePath
    )
    
    if (Test-Path $soundFilePath) {
        $player = New-Object System.Media.SoundPlayer
        $player.SoundLocation = $soundFilePath
        $player.Play()  # Play the sound asynchronously

    } else {
        Write-Host "Sound file not found: $soundFilePath"
    }
}

# Function to write animated text 
function Write-AnimatedTextLong {
    param (
        [string]$text,
        [int]$delay = 20,  # Delay in milliseconds between characters
        [ConsoleColor]$ForegroundColor = "Black",
        [string]$clickSoundFilePath = "C:\LUNA-A430Ai\resourses\typeclick.wav"
    )

    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $ForegroundColor

    foreach ($char in $text.ToCharArray()) {
        Write-Host $char -NoNewline
        Start-Sleep -Milliseconds $delay
    }

    $Host.UI.RawUI.ForegroundColor = $originalColor
}

function Write-AnimatedTextShort {
    param (
        [string]$text,
        [int]$delay = 0,  # Delay in milliseconds between characters
        [ConsoleColor]$ForegroundColor = "Black",
        [string]$clickSoundFilePath = "C:\LUNA-A430Ai\typeclick.wav"
    )

    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $ForegroundColor

    foreach ($char in $text.ToCharArray()) {
        Write-Host $char -NoNewline
        Start-Sleep -Milliseconds $delay
    }

    $Host.UI.RawUI.ForegroundColor = $originalColor
}

# Set the path to your Python script and the JSON file
$pythonScriptPath = "C:\\LUNA-A430Ai\\fetch_dialogue_data.py"
$jsonFilePath = "C:\LUNA-A430Ai\resourses\dialogue_data.json"

# Run the Python script as a background job
$job = Start-Job -ScriptBlock {
   python $using:pythonScriptPath
} -Name "PythonScriptJob" | Out-Null

Hide-Cursor

do {
    Write-AnimatedTextLong "$null" -ForegroundColor $AltColor -NoNewline
    Write-Host "   " -NoNewline
    Write-Host "`rFetching dialogue data" -NoNewline;
    Write-AnimatedTextLong "." -ForegroundColor $AltColor -NoNewline
    Write-Host "   "   -NoNewline
    Write-Host "`rFetching dialogue data" -NoNewline;
    Write-AnimatedTextLong ".." -ForegroundColor $AltColor -NoNewline
    Write-Host "   "   -NoNewline
    Write-Host "`rFetching dialogue data" -NoNewline;
    Write-AnimatedTextLong "..." -ForegroundColor $AltColor -NoNewline
    Write-Host "   "   -NoNewline
    Write-Host "`rFetching dialogue data" -NoNewline;

    # Read the callgate.txt file
    $callgate = Get-Content -Path 'C:\LUNA-A430Ai\resourses\callgate.txt'

} until ($callgate -eq "2")

Show-Cursor

# Stop the job
$job = Get-Job | Where-Object { $_.ScriptBlock -match $pythonScriptPath | Out-Null}
if ($job) {
    Stop-Job -Job $job.Id | Out-Null
    Remove-Job -Job $job.Id | Out-Null

}

Write-Host "`r                          "
Write-Host "[" -NoNewline;
Write-Host "OK" -ForegroundColor $AltColor -NoNewline; 
Write-Host "]" -NoNewline;
Write-AnimatedTextLong " Dialogue data retrieved successfully   "  -ForegroundColor "Black" -NoNewline;
Write-Host "
"

# Check if the JSON file exists
if (Test-Path $jsonFilePath) {
    # Read the JSON file content
    $dialogueData = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
    Write-Host ""
    Write-Host "[" -NoNewline;
    Write-Host "OK" -ForegroundColor $AltColor -NoNewline; 
    Write-Host "]" -NoNewline;
    Write-AnimatedTextLong " JSON Dataset '" -ForegroundColor "Black" -NoNewline;
    Write-AnimatedTextLong "dialogue_data.json" -ForegroundColor $AltColor -NoNewline; 
    Write-AnimatedTextLong "' loaded successfully" -ForegroundColor "Black" -NoNewline;
    Write-Output $dialogueData
    Write-Host ""
    Start-Sleep -Seconds 1

    
} else {
    Write-Host ""
    Write-Host "> " -ForegroundColor $SystemColor
    Write-AnimatedTextLong "SYSTEM: An error occurred: JSON file not found." 
}

$primaryApiUrl = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"

# Measure the response time of the API call
$responseTime = Measure-Command {

    # Send an HTTP GET request to the API
    $response = Invoke-RestMethod -Uri $primaryApiUrl -Method Get
}

# Convert the response time from ticks to milliseconds
$responseTimeMilliseconds = $responseTime.TotalMilliseconds

# Optionally, also capture the status code and response content, maybe to be used in future
$statusCode = $response.StatusCode
$content = $response.Content

$filePath = "C:\LUNA-A430Ai\resourses\splash!.txt"

# Read all lines from the file into an array
$splashTexts = Get-Content -Path $filePath

# Get a random index
$randomIndex = Get-Random -Minimum 0 -Maximum $splashTexts.Length

# Select the splash text at the random index and save it to a variable
$randomSplashText = $splashTexts[$randomIndex]

$columnWidth = 12  # Adjust this width as needed

# Format the splash text to align to the column width
# Align right within the column width

$formattedSplashText = $randomSplashText.PadLeft($columnWidth)

Write-AnimatedTextShort "888     888     888 888b    888        d8888             d8888     d8888   .d8888b.   .d8888b.        d8888 d8b 
888" -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextLong "     t" -ForegroundColor $TitleSecretColor -NoNewline;
Write-AnimatedTextShort "88     888 8888b   888       d88888            d88888    d8" -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextLong "e" -ForegroundColor $TitleSecretColor -NoNewline;
Write-AnimatedTextShort "888  d88P  Y88b d88P  Y88b      O88888 Y8P  
888     " -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextLong "r" -ForegroundColor $TitleSecretColor -NoNewline;
Write-AnimatedTextShort "88     888 88888b  888      d88P888           d88P888   d8P 888       .d88P 888    888     d88P888     
888     888     888 888Y88b 888     d88P 888          d88P 888  d8P  888       8888  888    888    d88" -ForegroundColor $TitleColor
Write-AnimatedTextShort "i" -ForegroundColor $TitleSecretColor -NoNewline;
Write-AnimatedTextShort " 888 888 " -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextShort "
888     888     888 " -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextLong "A" -ForegroundColor $TitleSecretColor -NoNewline;
Write-AnimatedTextShort "88 Y88b888    d88P  888         d88P  888 d88   888        Y8b. " -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextLong "s" -ForegroundColor $TitleSecretColor -NoNewline;
Write-AnimatedTextShort "88    888   d88P  888 888 
888     888     888 888  Y88888   d88P   888 888888 d88P   888 8888888888 888    888 888    888  d88P   888 888 
888     Y88b. .d88P 888   Y8888  d888888888" -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextLong "m" -ForegroundColor $TitleSecretColor -NoNewline;
Write-AnimatedTextShort "       d8888888888       888  Y88b  d88P Y88b  d88P d8888888888 888 
88888888 Y88888P    888    Y888 d88P     888      d88P     888       888   Y8888P      Y8888P  d88P     888 888

" -ForegroundColor $TitleColor -NoNewline;
Write-AnimatedTextShort "["
Write-AnimatedTextShort "Tenshi" -ForegroundColor $AltColor -NoNewline;
Write-AnimatedTextShort "-Edition] | API Response Time: " -ForegroundColor "Black" -NoNewline;
Write-AnimatedTextShort "$responseTimeMilliseconds" -ForegroundColor $AltColor -NoNewline;
Write-AnimatedTextShort "ms"
Write-AnimatedTextShort " | { Programmed by, '" -ForegroundColor "Black" -NoNewline;
Write-AnimatedTextShort "zero.dev" -ForegroundColor $AltColor -NoNewline;
Write-AnimatedTextShort "' }         " -ForegroundColor "Black" -NoNewline;
Write-AnimatedTextShort "$formattedSplashText" -ForegroundColor "DarkYellow" -NoNewline;
Write-Host "
" 
Write-AnimatedTextShort "= + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = + = +" -ForegroundColor $AltColor
Write-Host ""

# API Key
$apiKey = Get-Content "C:\LUNA-A430Ai\apikey\key.txt"

# API Endpoints for different models
$secondaryApiUrl = "https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium"
$japaneseApiUrl = "https://api-inference.huggingface.co/models/rinna/japanese-gpt-1b" # To be Used in future
$textRazorApiUrl = "https://api.textrazor.com/"

# Initial context about the chatbot
$chatbotContext = "AUTOMATED MESSAGE: You are a chat-bot named Luna. Remember, your name is Luna and you should respond as Luna."
$chatbotContextja = Get-Content "C:\LUNA-A430Ai\jaTranslations\contextTranslationEncode.txt" # To be Used in future
$usermessageencodeja = Get-Content "C:\LUNA-A430Ai\jaTranslations\userMessageIndicatorTranslationEncode.txt" # To be Used in future

# Function to fetch data from the Hugging Face dataset API using Python
function Fetch-DataFromDataset {
    param (
        [string]$pythonScriptPath
    )

    Write-Host "> " -ForegroundColor $SystemColor -NoNewline
    Write-Host "SYSTEM:: Fetching data from JSON dataset..." -NoNewline
    Write-Host ""

    try {
        # Call the Python script and capture its output
        $output = python $pythonScriptPath
        $response = $output | ConvertFrom-Json

        Write-Host "> " -ForegroundColor $SystemColor -NoNewline
        Write-Host "SYSTEM: Dataset response received." -NoNewline
        Write-Host ""
        Write-Host ""

      return $response

    } catch {
        Write-Host "> " -ForegroundColor $SystemColor -NoNewline
        Write-Host "SYSTEM:  An error occurred while loading the dataset." -NoNewline
        Write-Host ""
        Write-Host ""
        Write-Host "Error details: $_"
        Write-Host ""
        return $null
    }
}

# Function to send a message to the Hugging Face API and get a response
function Send-Message {
    param (
        [string]$message,
        [string]$apiUrl,
        [string]$context
    )

    # Create the payload with the context included
    $payload = @{
        "inputs" = "$context USERMESSAGE: $message"
    } | ConvertTo-Json

    # Define headers
    $headers = @{
        "Authorization" = "Bearer $apiKey"
        "Content-Type"  = "application/json"
    }

    while ($true) {
        try {
            # Send the request
            $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $payload
            # Return the response
            return $response.generated_text

        } catch {
            # Check if the error is due to the model loading
            if ($_ -match "Model.*is currently loading") {
                Write-Host "> " -ForegroundColor Yellow -NoNewline
                Write-Host "SYSTEM:: LUNA-A430 is currently loading, retrying in 30 seconds..." -NoNewline
                Write-Host ""
                Write-Host ""

                Start-Sleep -Seconds 30
            } else {

                throw $_
            }
        }
    }
}

# Function to fetch data from Wikipedia API
function Fetch-WikipediaData {
    param (
        [string]$query
    )

    # Wiki feature to be overhauled in future / reworked
    $query = $query -replace " ", "_"

    $apiUrl = "https://en.wikipedia.org/api/rest_v1/page/summary/$query"

    try {
        # Send the request
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get

        # Return the extract
        return $response.extract

    } catch {
        if ($_ -match "Not found.") {
            Write-Host "> " -ForegroundColor $SystemColor -NoNewline
            Write-Host "SYSTEM: The requested Wikipedia page was not found." -NoNewline
            Write-Host ""
            Write-Host "Error details: $_"

        } else {
            Write-Host "> " -ForegroundColor $SystemColor -NoNewline
            Write-Host "SYSTEM: An error occurred while fetching Wiki data." -NoNewline
            Write-Host ""
            Write-Host "Error details: $_"
        }
        return $null
    }
}

# Function to handle specific predefined responses
function Get-PredefinedResponse {
    param (
        [string]$message
    )

    if ($message -like "hello" -or $message -like "hi") {
    return " Hello my name is luna, i am an AI Assistent here to help you."
    }

    else {
    if ($message -contains "how are you") {
        return " I am just a program, so I don't have feelings, but thanks for asking!"
    } elseif ($message -contains "your name") {
        return " I am Luna, your AI assistant."
    } elseif ($message -contains "created you") {
        return " I was created by zero.dev."
    } elseif ($message -contains "what can you do") {
        return " I can chat with you, provide information, and assist with various tasks. Just ask!"
    } elseif ($message -contains "tell me a joke") {
        return " Why don't scientists trust atoms? Because they make up everything!"
        return $null
    }

    }

} 

# Start the conversation
Write-Host ""
Write-Host "You can now start chatting with the LUNA-A430 AI. Type '" -NoNewline
Write-Host "exit" -ForegroundColor $AltColor -NoNewline
Write-Host "' to end the conversation. (responses can be misleading)" -NoNewline
Write-Host ""

# Play the sound
$player.Play()
Start-Sleep -Seconds 2
$player.Stop()

# Main interaction loop
while ($true) {
    if ($userInput -match "[\p{IsHiragana}\p{IsKatakana}\p{IsCJKUnifiedIdeographs}]") {
        Write-Host -ForegroundColor Yellow -NoNewline "> "
        Write-Host "SYSTEM:" -NoNewline
        Write-Host " Ja input detected. Translating..." -NoNewline;      # this feature will be added and fixed in the seccond version of tenshi
        Write-Host ""
        
        $response = Send-Message -message $userInput -apiUrl $japaneseApiUrl -context $chatbotContextja
        Write-Host -ForegroundColor Yellow -NoNewline "> "
        Write-Host "LUNA-A430:" -NoNewline
        Write-AnimatedTextLong -text "$response" -ForegroundColor White
        Write-Host ""
    }

    else {

        try {
        $Host.UI.RawUI.WindowTitle = "LUNA-A430Ai | Awaiting your imput"
        Write-Host ""
        Write-Host ""
        Write-Host -ForegroundColor $AltColor -NoNewline "> "
        $userMessage = Read-Host "You"
        Write-Host ""
        }
    
    catch {
        Write-Host "Error: $_"
    }

}

    if ($userMessage -eq "exit") {
        Write-Host "> " -ForegroundColor $SystemColor -NoNewline
        Write-Host "SYSTEM: SESSION TERMINATED | Ending process Luna.AI | " -NoNewline;
        Write-Host ""
        Write-Host ""
        Start-Sleep -Seconds 1
        break 
        return $null
    }

    if ($userMessage -eq "zero.dev") {
        Write-Host "> " -ForegroundColor $DevColor -NoNewline
        Write-Host "zerodev [developer]: wow an easter egg! ;)" -NoNewline
        Write-Host "
        "
    }

    # Check if the user message is a predefined one
    $predefinedResponse = Get-PredefinedResponse -message $userMessage
    if ($predefinedResponse) {
        Write-Host -ForegroundColor $AltColor -NoNewline "> "
        Write-Host "LUNA-A430:" -NoNewline
        Write-AnimatedTextLong $predefinedResponse -ForegroundColor Black
        continue
    }

    #Fetch response from primary AI
    $aiResponse = Send-Message -message $userMessage -apiUrl $primaryApiUrl -context $chatbotContext

    # Check for keywords for Wikipedia lookup
    if ($userMessage -contains "tell          me about" -or $userMessage -contains "who is" -or $userMessage -contains "what is") {
        $wikiQuery = $userMessage -replace "tell me about", "" -replace "who is", "" -replace "what is", "" -replace "\?", ""
        $wikiResponse = Fetch-WikipediaData -query $wikiQuery

        try {
        if ($wikiResponse) {
            do {

            $switch = 1
            $aiResponse += "`n`nHere is some additional information i found:
            `n$wikiResponse"
            $switch = 2

            } until (
            $switch = 2
            )
        }
    }

    catch {
        Write-Host "> " -ForegroundColor $SystemColor -NoNewline
                Write-Host "SYSTEM: No wiki match for requested query" -NoNewline
    }
}

    # Print the AI response
    Write-Host -ForegroundColor $AltColor -NoNewline "> " 
    Write-Host "LUNA-A430: " -NoNewline

    do {
        if ($userMessage -eq "Moon Prisim Power, Make Up!") {
            $aiResponse = Write-Host "Moon Prism Power, Make Up! Transforming into my ultimate AI form! How can I assist you today?" -ForegroundColor DarkYellow NoNewline;
    }

        if ($userMessage -eq "Artemis") {
            $aiResponse = Write-Host "Hey, im Luna Silly :)" -ForegroundColor DarkYellow -NoNewline;

        }
        
        $switch = 1
        $Host.UI.RawUI.WindowTitle = "LUNA-A430Ai | Typing..."
        Write-AnimatedTextLong  $aiResponse -ForegroundColor Black -NoNewline;
        $switch = 2

    } until (
        $switch = 2
    )
    
}