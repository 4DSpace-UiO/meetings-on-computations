#!/bin/bash

# See protect.sh for instructions.

mkdir -p unprotected
cd protected
for file in *.enc
do
    base=$(basename "$file" .enc)
    openssl enc -d -aes256 -pbkdf2 -pass "pass:$1" -in "$file" -out "../unprotected/$base"
done


