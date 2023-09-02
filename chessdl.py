import os
import requests
import re
import time
import urllib.request


def download_video(vid_url, counter):
    vid_page = requests.get(vid_url).text
    vid_link = re.search(r'https://media[^&]*', vid_page).group(0)
    vid_title = re.search(r'<title>(.*?)</title>', vid_page).group(1).strip()

    vid_title_clean = vid_title.split('|')[0].strip()
    filename = f"{counter}_{vid_title_clean}.mp4"
    print(f"Downloading: {vid_title_clean}")
    urllib.request.urlretrieve(vid_link, filename)

    print("Sleeping...")
    time.sleep(10)



def download_lesson(url):
    counter = 1
    lesson_page = requests.get(url).text
    lesson_title = re.search(r'<title>(.*?)</title>', lesson_page).group(1).strip()
    dir_name = lesson_title.split('-')[0].strip()
    os.makedirs(dir_name, exist_ok=True)
    os.chdir(dir_name)

    video_links = re.findall(r'<h3 class="lesson-title">\s*<a href="(.*?)"', lesson_page)
    for link in video_links:
        download_video(link, counter)
        counter += 1

    os.chdir("..")


if __name__ == "__main__":
    URL = input("Enter the URL: ")

    if "lessons/" in URL and "/" in URL.split("lessons/")[1]:
        download_video(URL, 1)
    else:
        download_lesson(URL)
