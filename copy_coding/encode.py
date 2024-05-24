from shutil import copy
from sys import argv, exit

def copy_file(input_file, output_file):
    try:
        copy(input_file, output_file)
    except IOError as e:
        print(f"Unable to copy file. {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    if len(argv) != 3:
        print("Usage: python copy_file.py input_file output_file")
        exit(1)

    input_file = argv[1]
    output_file = argv[2]

    copy_file(input_file, output_file)