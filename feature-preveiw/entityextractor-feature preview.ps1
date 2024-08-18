# Set the console title
$Host.UI.RawUI.WindowTitle = "Entity Extractor | 1.0.0"

# Print ASCII Art Text
Write-Host ":::::::::: ::::    ::: ::::::::::: ::::::::::: ::::::::::: :::   :::       :::::::::: :::    ::: ::::::::::: 
:+:        :+:+:   :+:     :+:         :+:         :+:     :+:   :+:       :+:        :+:    :+:     :+:     
+:+        :+:+:+  +:+     +:+         +:+         +:+      +:+ +:+        +:+         +:+  +:+      +:+     
+#++:++#   +#+ +:+ +#+     +#+         +#+         +#+       +#++:         +#++:++#     +#++:+       +#+     
+#+        +#+  +#+#+#     +#+         +#+         +#+        +#+          +#+         +#+  +#+      +#+     
#+#        #+#   #+#+#     #+#         #+#         #+#        #+#          #+#        #+#    #+#     #+#     
########## ###    ####     ###     ###########     ###        ###          ########## ###    ###     ###   "

# Your TextRazor API key
$api_key = "PUT_YOUR_TEXT_RAZOR_API_KEY_HERE"

# Define the TextRazor API endpoint for entity extraction
$endpoint = "https://api.textrazor.com/"

while ($true) {
    # Prompt user for input
    Write-Host ""
    $user_prompt = Read-Host -Prompt "Enter your prompt (or type 'exit' to quit)"
    
    if ($user_prompt -eq 'exit') {
        break
    }

    Write-Host ""

    # Define the body of the request
    $body = @{
        text = $user_prompt
        extractors = "entities"
    }

    # Convert body to form-urlencoded string
    $form_encoded_body = ($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$([System.Net.WebUtility]::UrlEncode($_.Value))" }) -join "&"

    try {
        # Make the API request
        $response = Invoke-RestMethod -Uri $endpoint `
            -Method Post `
            -Headers @{ "x-textrazor-key" = $api_key; "Content-Type" = "application/x-www-form-urlencoded" } `
            -Body $form_encoded_body

        # Check if response contains entities
        if ($response.response -and $response.response.entities) {
            $entities = $response.response.entities

            # Print the table header
            Write-Output ("{0,-3} {1,-45} {2,-25} {3,10} {4,-45}" -f "ID", "Type", "Matched Text", "Confidence", "Wiki Link")
            Write-Output ("{0,-3} {1,-45} {2,-25} {3,10} {4,-45}" -f "---", "---", "---", "----------", "---------------------------------------------")
            
            # Print each entity in a formatted table
            foreach ($entity in $entities) {
                $id = $entity.id
                $type = $entity.type -join ', '
                $matchedText = $entity.matchedText
                $confidence = [math]::Round($entity.confidenceScore, 2)
                $wikiLink = if ($entity.wikiLink) { $entity.wikiLink } else { "" }

                Write-Output ("{0,-3} {1,-45} {2,-25} {3,10} {4,-45}" -f `
                    $id, $type, $matchedText, $confidence, $wikiLink)
            }
        } else {
            Write-Output "No entities found."
        }
    }
    catch {
        Write-Output "Error: $_"
    }
}
