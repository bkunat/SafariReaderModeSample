# Safari Reader Mode Sample

A sample Safari Extension demonstrating how to implement a Reader Mode-like functionality using Safari App Extensions. This project shows how to extract and display article content in a clean, distraction-free popover view.

<img width="524" alt="Screenshot 2024-12-12 at 17 40 49" src="https://github.com/user-attachments/assets/6dc8f5ac-258a-44ed-b357-4ff7f6347290" />

## Features

- Extracts article content from web pages and present it in a clean, readable format in a popover

## How It Works

1. The extension adds a toolbar button to Safari
2. When clicked, it injects JavaScript into the active webpage
3. The JavaScript code:
   - Looks for structured article data (JSON-LD)
   - Falls back to searching for common article selectors
   - Removes unwanted elements (ads, social media, etc.)
   - Extracts text content from paragraphs and headings
4. The extracted content is displayed in a popover

## Requirements

- macOS 12.0 or later
- Xcode 15.0 or later

## Usage

1. Clone the repository
2. Open the project in Xcode
3. Build and run the extension
4. Enable the extension in Safari's preferences
