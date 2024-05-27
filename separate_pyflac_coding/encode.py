import pyflac
from pathlib import Path
from sys import argv, exit

def compress_wav_to_flac(input_wav, output_flac, compression_level=9):
    encoder = pyflac.FileEncoder(
        input_file=Path(input_wav),
        output_file=Path(output_flac),
        compression_level=compression_level
    )
    encoder.process()


if __name__ == "__main__":
    if len(argv) < 3:
        print("Usage: python encode.py input_file output_file")
        exit(1)
    input_file = argv[1]
    output_file = argv[2]
    compress_wav_to_flac(input_file, output_file)
