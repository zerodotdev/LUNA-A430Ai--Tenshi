$Host.UI.RawUI.WindowTitle = "LUNA-A430Ai | Version 1.0.0.0 "
$Host.UI.RawUI.BackgroundColor = 'White';
$Host.UI.RawUI.ForegroundColor = 'Black';

Clear-Host

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


Write-AnimatedTextShort "

8888888b.  888 8888888888        d8888  .d8888b.  8888888888      888       888        d8888 8888888 88888888888 
888   Y88b 888 888              d88888 d88P  Y88b 888             888   o   888       d88888   888       888     
888    888 888 888             d88P888 Y88b.      888             888  d8b  888      d88P888   888       888     
888   d88P 888 8888888        d88P 888   Y888b.   8888888         888 d888b 888     d88P 888   888       888     
8888888P   888 888           d88P  888      Y88b. 888             888d88888b888    d88P  888   888       888     
888        888 888          d88P   888        888 888      888888 88888P Y88888   d88P   888   888       888     
888        888 888         d8888888888 Y88b  d88P 888             8888P   Y8888  d8888888888   888       888     
888        888 8888888888 d88P     888   Y8888P   8888888888      888P     Y888 d88P     888 8888888     888  " -ForegroundColor "DarkBlue"

Write-AnimatedTextShort "[LUNA " -NoNewline;
Write-AnimatedTextShort "Tenshi" -ForegroundColor "DarkBlue" -NoNewline; 
Write-AnimatedTextShort "-Edition Launcher | Version 1.0.0.0]"-NoNewline;
Write-Host "
"

$Graphic = Get-Content "C:\LUNA-A430Ai\resourses\tenshi.txt" -Raw               
Write-AnimatedTextShort "$Graphic" -ForegroundColor "DarkBlue"
Start-Sleep -Seconds 100

