import os

songsCSV = open("songs_list.csv", 'w')
songsCSV.write("#Language, Song Name, Extension")

language = ""

for dirName, subDirList, fileList in os.walk(os.getcwd()):
    language = dirName.strip("")
    for fname in fileList:
        if not "DS_Store" in fname:
            parts = fname.split('.')
            songsCSV.write(language + ", " + parts[0] + ", " + parts[1] + '\n')
