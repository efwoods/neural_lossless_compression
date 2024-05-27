from sys import argv, exit
from shutil import copy
from os import remove
from os.path import splitext
import pyflac
from pathlib import Path

def decompress_wav_to_flac(input_flac, output_file):
    # it seems the decoder doesn't like writing to files that don't end in .wav...
    # time to fight it...
    name, ext = splitext(output_file)
    output_wav = f"{name}temp.wav"
    decoder = pyflac.FileDecoder(input_file=Path(input_flac), output_file=Path(output_wav))
    decoder.process()
    copy(output_wav, output_file)
    remove(output_wav)

    


if __name__ == "__main__":
    if len(argv) < 3:
        print("Usage: python encode.py input_file output_file")
        exit(1)
    input_file = argv[1]
    output_file = argv[2]
    decompress_wav_to_flac(input_file, output_file)
