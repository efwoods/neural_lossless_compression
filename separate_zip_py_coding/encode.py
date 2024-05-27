from sys import argv, exit
from zipfile import ZipFile, ZIP_DEFLATED, ZIP_STORED, ZIP_BZIP2, ZIP_LZMA
from os.path import exists

def compress(input_file, output_file, compression_method, compression_effort):
    compression_effort = 6 if not compression_effort else compression_effort
    if compression_method == "ZIP_DEFLATED":
        compression_method = ZIP_DEFLATED
    elif compression_method == "ZIP_BZIP2":
        compression_method = ZIP_BZIP2
    elif compression_method == "ZIP_LZMA":
        compression_method = ZIP_LZMA
    else:
        compression_method = ZIP_STORED
    with ZipFile(output_file, 'w', compression=compression_method, compresslevel=compression_effort) as zf:
        zf.write(input_file)


if __name__ == "__main__":
    if len(argv) < 3 or len(argv) > 5:
        print("Usage: python encode.py input_file output_file [compression_method] [compression_effort]")
        exit(1)

    input_file = argv[1]
    output_file = argv[2]
    if len(argv) > 3:
        compression_method = argv[3]
    else:
        compression_method = None
    if len(argv) > 4:
        compression_effort = int(argv[4])
    else:
        compression_effort = None
    

    compress(input_file, output_file, compression_method, compression_effort)