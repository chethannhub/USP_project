#!/bin/bash

# Function to categorize files
categorize_files() {
    local DIR=$1

    # Define categories and their file extensions
    declare -A CATEGORIES=(
        ["Documents"]="pdf docx txt"
        ["Images"]="jpg jpeg png gif"
        ["Videos"]="mp4 mkv avi"
        ["Others"]=""
    )

    # Create category folders
    for CATEGORY in "${!CATEGORIES[@]}"; do
        mkdir -p "$DIR/$CATEGORY"
    done

    # Move files to respective categories
    for CATEGORY in "${!CATEGORIES[@]}"; do
        for EXT in ${CATEGORIES[$CATEGORY]}; do
            find "$DIR" -maxdepth 1 -type f -iname "*.$EXT" -exec mv {} "$DIR/$CATEGORY/" \;
        done
    done

    # Move uncategorized files to "Others"
    find "$DIR" -maxdepth 1 -type f -exec mv {} "$DIR/Others/" \;

    # Notify user
    zenity --info --text="Files have been categorized successfully!"
}

# Main program
DIR=$(zenity --file-selection --directory --title="Select Directory to Categorize")

# Check if user canceled
if [ -z "$DIR" ]; then
    zenity --error --text="No directory selected! Exiting..."
    exit 1
fi

categorize_files "$DIR"

