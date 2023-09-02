#!/bin/bash

counter=1

download_lesson() {
    local lesson_url=$1
    local lesson_page=$(curl -s "$lesson_url")
    local lesson_title=$(echo "$lesson_page" | pup 'title text{}' | sed -e 's/^ *//' -e '/^[[:space:]]*$/d')
    local dir_name=$(echo "$lesson_title" | cut -d "-" -f 1 | sed 's/ *$//')

    mkdir "$dir_name"
    cd "$dir_name"

    for line in $(echo $lesson_page | pup 'h3.lesson-title a attr{href}'); do
        download_video "$line"
    done

    cd ..
}

download_video() {
    local vid_url=$1
    local vid_page=$(curl -s "$vid_url")
    local vid_link=$(echo "$vid_page" | grep -o 'https://media[^&]*' | head -1)
    local vid_title=$(echo "$vid_page" | pup 'title text{}' | sed -e 's/^ *//' -e '/^[[:space:]]*$/d')

    echo "Downloading: $vid_title"
    local sanitized_title=$(echo "$vid_title" | cut -d "|" -f 1 | sed 's/ *$//')
    local filename="${counter}_${sanitized_title}.mp4"

    wget --show-progress "$vid_link" -O "$filename" 

    echo "Sleeping..."
    sleep 10

    ((counter++))
}

main() {
    if [ -z "$1" ]; then
        echo "Usage: $0 <URL>"
        exit 1
    fi

    URL="$1"

    if [[ $URL == *"lessons/"*"/"* ]]; then
        download_video "$URL"
    else
        download_lesson "$URL"
    fi
}

main "$@"
