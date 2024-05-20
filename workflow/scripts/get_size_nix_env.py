import os
import subprocess
import sys
import tempfile
from subprocess import check_output

def get_size(start_path: str):
    """Get the size of the folder `start_path`"""
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(start_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            # skip if it is symbolic link
            if not os.path.islink(fp):
                total_size += os.path.getsize(fp)

    return total_size

def build_shell(shell: str, system: str) -> str:
    tmp = f"output_shell_build_{system}_{shell}"
    subprocess.call(f"nix build .#devShells.{system}.{shell} -o {tmp}", shell=True)
    nix_store_path = os.readlink(tmp)
    os.remove(tmp)
    return nix_store_path

def print_total_size(store_path: str) -> int:
    # Get the store reference of the store provided store path
    output = check_output("nix-store -qR {}".format(store_path), shell=True)

    total_size = 0
    for path in output.decode().splitlines():
        total_size += get_size(path)

    return total_size

def main():
    args = sys.argv
    shell = args[1]
    system = args[2]
    total = print_total_size(build_shell(shell, system))
    print(f"{shell}, {system}, {total}")

main()
