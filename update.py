import subprocess

updates = ["apt update","apt upgrade -y","apt autoremove -y","apt clean"]

def update(lst):

        for i in lst:

                command = ["bash", "-c", i]

                try:
                        subprocess.run(command, check=True)
                        print(f"Success: {i}")
                except subprocess.CalledProcessError:
                        print(f"Failed: {i}")


update(updates)
