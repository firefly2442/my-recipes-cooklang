import subprocess
from pathlib import Path

folder_path = Path("/recipes")

for file in folder_path.iterdir():
    if file.is_file() and file.suffix == ".cook":
        print(f"Processing file: {file}")

        with open(file, 'r') as readfile:
            text = readfile.read()

        # replace cooklang characters with spaces
        for replaceme in ['.', '#', '{', '}', '@']:
            text = text.replace(replaceme, ' ')

        # Pass the processed text to aspell
        process = subprocess.run(['aspell', '--lang', 'en', '--ignore-case', 'list'], input=text, text=True, capture_output=True)
        print(process.stdout)