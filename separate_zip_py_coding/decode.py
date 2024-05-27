from sys import argv, exit
from zipfile import ZipFile

def decompress(input_file, output_file):
    with ZipFile(input_file, 'r') as zf:
        zip_info = zf.infolist()[0]
        with zf.open(zip_info) as source, open(output_file, 'wb') as target:
            target.write(source.read())

if __name__ == "__main__":
    if len(argv) < 3:
        print("Usage: python decode.py input_file output_file")
        exit(1)

    input_file = argv[1]
    output_file = argv[2]

    decompress(input_file, output_file)