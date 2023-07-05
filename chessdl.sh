#!/bin/bash

URL=$1

lesson_page=$(curl -s "$1")

lesson_title=$(echo "$lesson_page" | pup 'title text{}' | sed -e 's/^ *//' -e '/^[[:space:]]*$/d')

dir_name=$(echo "$lesson_title" | cut -d "-" -f 1 | sed 's/ *$//')
mkdir "$dir_name"
cd "$dir_name"

for line in $(echo $lesson_page | pup 'h3.lesson-title a attr{href}'); do
    vid_page=$(curl -s "$line")
    vid_link=$(echo "$vid_page" | grep -o 'https://media[^&]*' | head -1)
    vid_title=$(echo "$vid_page" | pup 'title text{}' | sed -e 's/^ *//' -e '/^[[:space:]]*$/d')
    
    echo "downloading: $vid_title"
    echo $(echo "$vid_title" | cut -d "|" -f 1 | sed 's/ *$//')
    wget --show-progress $vid_link -O "$(echo "$vid_title" | cut -d "|" -f 1 | sed 's/ *$//').mp4"

    echo "sleeping..."
    sleep 10
done

cd ..