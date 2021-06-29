#!/bin/bash

# See protect.sh for instructions.

mkdir -p unprotected
cd protected

for file in *.enc
do
    base=$(basename "$file" .enc)
    openssl enc -d -aes256 -pbkdf2 -pass "pass:$1" -in "$file" -out "../unprotected/$base"
done

for file in *.7z
do
    base=$(basename "$file" .7z)
    7z x -o"../unprotected/" -p"$1" "$file" 
done
