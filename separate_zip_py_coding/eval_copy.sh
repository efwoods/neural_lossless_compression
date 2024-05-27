#!/usr/bin/env bash

rm -rf data
unzip data.zip

get_file_size() {
  gfind "$1" -printf "%s\n"
}

compression_arguments_given=0

# Check if the correct number of arguments is provided
if [ "$#" -ne 0 ]; then
  if [ "$#" -ne 2 ]; then
    echo "Usage: $0 \nOR Usage: $0 compression_method compression_effort"
    exit 1
  else
    compression_arguments_given=1
    compression_method="$1"
    compression_effort="$2"
    mkdir -p "./results"
    csv_file="./results/compression_results_${compression_method}_${compression_effort}.csv"
  fi
else
  csv_file="compression_results.csv"
fi

# change these to match files used for encoder and decoder
encoder_file_name="./separate_zip_py_coding/encode.py"
decoder_file_name="./separate_zip_py_coding/decode.py"
# extracts the text of the encode.py and decode.py and formats it into a executable script that is 
#     compatible with the rest of the code (to make editor extentions useable and debugging easier).
#     This is usually not necessary but might be a helpful measure later (especially if you are writing 
#     code in other languages with compilation steps that can be added to gen_exe).
./gen_exe $encoder_file_name encode
./gen_exe $decoder_file_name decode
# TODO: I have not thought about what to do for imports for python files. 

# Create the CSV file to log compression results

rm -rf csv_file
echo "file_name,file_size,compressed_size,time_taken_ns" > "$csv_file"

total_size_raw=0
encoder_size=$(get_file_size encode)
decoder_size=$(get_file_size decode)
total_size_compressed=$((encoder_size + decoder_size))

for file in data/*
do
  echo "Processing $file"
  compressed_file_path="${file}.brainwire"
  decompressed_file_path="${file}.copy"

  start_time=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
  # echo "start_time: ${start_time}"
  if [ "$compression_arguments_given" -eq 1 ]; then
    ./encode "$file" "$compressed_file_path" $compression_method $compression_effort
    ./decode "$compressed_file_path" "$decompressed_file_path" $compression_method $compression_effort
  else
    ./encode "$file" "$compressed_file_path"
    ./decode "$compressed_file_path" "$decompressed_file_path"
  fi
  end_time=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
  # echo "end_time: ${end_time}"
  elapsed_time_ns=$(echo "($end_time - $start_time) * 1000000000" | bc)

  file_size=$(get_file_size "$file")
  compressed_size=$(get_file_size "$compressed_file_path")

  if diff -q "$file" "$decompressed_file_path" > /dev/null; then
      echo "${file} losslessly compressed from ${file_size} bytes to ${compressed_size} bytes in ${elapsed_time_ns} nanoseconds"
      echo "$(basename "$file"),${file_size},${compressed_size},${elapsed_time_ns}" >> "$csv_file"
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
