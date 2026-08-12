import os

dirs = []
emptyDirs = []

def identifyDirs():
    for i in os.listdir():
        if os.path.isdir(i):
            dirs.append(i)

def identifyEmptyDirs():
    for i in dirs:
        with os.scandir(i) as entries:
            if not any(entries):
                emptyDirs.append(i)

def removeEmptyDirs():
    for i in emptyDirs:
        print("Deleting: " + i)
        os.rmdir(i)

identifyDirs()
identifyEmptyDirs()
removeEmptyDirs()
