import os
import requests
import re
import time
import urllib.request


def download_lesson_videos(url):
    lesson_page = requests.get(url).text

    lesson_title = re.search(r'<title>(.*?)</title>', lesson_page).group(1).strip()

    dir_name = lesson_title.split('-')[0].strip()
    os.makedirs(dir_name, exist_ok=True)
    os.chdir(dir_name)

    video_links = re.findall(r'<h3 class="lesson-title">\s*<a href="(.*?)"', lesson_page)
    for link in video_links:
        vid_page = requests.get(link).text
        vid_link = re.search(r'https://media[^&]*', vid_page).group(0)
        vid_title = re.search(r'<title>(.*?)</title>', vid_page).group(1).strip()

        vid_title_clean = vid_title.split('|')[0].strip()
        print(f"Downloading: {vid_title_clean}")
        urllib.request.urlretrieve(vid_link, f"{vid_title_clean}.mp4")

        print("Sleeping...")
        time.sleep(10)

    os.chdir("..")


if __name__ == "__main__":
    URL = input("Enter the URL: ")
    download_lesson_videos(URL)
