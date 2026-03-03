import os
import tarfile

path = "/home/awiley805/Documents"

if not os.path.exists(path):
        print("Path does not exist")

arc = []

for i in os.listdir(path):
        if i.endswith((".html", ".css", ".js" )):
                arc.append(os.path.join(path,i))

with tarfile.open("archive.tar", "w") as tar_file:
        for j in arc:
                tar_file.add(j)




