#!/usr/bin/env bash

compression_methods=("ZIP_DEFLATED" "ZIP_BZIP2" "ZIP_LZMA" "ZIP_STORED")
# compression_methods=("ZIP_DEFLATED")

# for method in "${compression_methods[@]}"; do
#     for ((i=0; i<=9; i++)); do
#         echo "Method: $method, Effort: $i"
#     done
# done
cd ../

for method in "${compression_methods[@]}"; do
    for ((i=0; i<=9; i++)); do
        ./eval.sh $method $i
    done
done