callgate = "1"
with open('callgate.txt', 'w') as file:
    file.write(callgate)

import json
from datasets import load_dataset

def fetch_dialogue_data():
    dataset = load_dataset("daily_dialog", trust_remote_code=True)
    
    # Prepare the data to be saved as JSON
    dialogue_data = {
        "train": dataset["train"][:],  # Convert to a list of dicts
        "validation": dataset["validation"][:],
        "test": dataset["test"][:]
    }
    
    # Write the data to a JSON file
    with open("C:\LUNA-A430Ai") as json_file:
        json.dump(dialogue_data, json_file)

if __name__ == "__main__":
    fetch_dialogue_data()

callgate = "2"

# Write the variable value to a file
with open('callgate.txt', 'w') as file:
    file.write(callgate)