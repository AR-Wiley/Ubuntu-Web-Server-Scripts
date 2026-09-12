import os

path = "/home/awiley805/Desktop/NewDir"
sub_dir = ["documents", "videos", "pictures", "logs", "misc"]

def validatePath(path)
        if not os.path.exists(path):
                print("Path does not exist...")
                print("Creating path...")
                try:
                        os.makedirs(path)
                        print("Path has been created")
                        print(path)
                except Exception as e:
                        print(f"An error has occured: {e}")
        else:
                print(path)


def createSubDir(path, sub_dir):

        for i in sub_dir:
                try:
                        os.makedirs(os.path.join(path, i))
                        print(f"Sub-Directory '{i}' created successfully")
                except FileExistsError:
                        print(f"Sub-Directroy '{i}' already exists")
                except Exception as e:
                        print(f"An error has occured: {e}")



