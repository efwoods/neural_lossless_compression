#!/usr/bin/env bash

rm -rf data
unzip data.zip

get_file_size() {
  gfind "$1" -printf "%s\n"
}

# change these to match files used for encoder and decoder
encoder_file_name="./copy_coding/encode.py"
decoder_file_name="./copy_coding/decode.py"
# extracts the text of the encode.py and decode.py and formats it into a executable script that is 
#     compatible with the rest of the code (to make editor extentions useable and debugging easier).
#     This is usually not necessary but might be a helpful measure later (especially if you are writing 
#     code in other languages with compilation steps that can be added to gen_exe).
./gen_exe $encoder_file_name encode
./gen_exe $decoder_file_name decode
# TODO: I have not thought about what to do for imports for python files. 

# Create the CSV file to log compression results
csv_file="compression_results.csv"
echo "file_name,file_size,compressed_size" > "$csv_file"

total_size_raw=0
encoder_size=$(get_file_size encode)
decoder_size=$(get_file_size decode)
total_size_compressed=$((encoder_size + decoder_size))

for file in data/*
do
  echo "Processing $file"
  compressed_file_path="${file}.brainwire"
  decompressed_file_path="${file}.copy"

  ./encode "$file" "$compressed_file_path"
  ./decode "$compressed_file_path" "$decompressed_file_path"

  file_size=$(get_file_size "$file")
  compressed_size=$(get_file_size "$compressed_file_path")

  if diff -q "$file" "$decompressed_file_path" > /dev/null; then
      echo "${file} losslessly compressed from ${file_size} bytes to ${compressed_size} bytes"
      echo "$(basename "$file"),${file_size},${compressed_size}" >> "$csv_file"
  else
      echo "ERROR: ${file} and ${decompressed_file_path} are different."
      exit 1
  fi

  total_size_raw=$((total_size_raw + file_size))
  total_size_compressed=$((total_size_compressed + compressed_size))
done

compression_ratio=$(echo "scale=2; ${total_size_raw} / ${total_size_compressed}" | bc)

echo "All recordings successfully compressed."
echo "Original size (bytes): ${total_size_raw}"
echo "Compressed size (bytes): ${total_size_compressed}"
echo "Compression ratio: ${compression_ratio}"
