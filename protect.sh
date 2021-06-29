#!/bin/bash

# FACILITATES PASSWORD PROTECTION OF SELECTED PAGES AND FILES.

# When working with protected pages, you must first unencrypt the protected
# pages and files as follows:
#
#   ./unprotect.sh <passphrase>
#   rm -rf protected # Can be done to clean up if the above is successful
#
# You can now edit the files files stored in the "unprotected" folder (make
# sure not to commit them to the repository). Once you are done, you encrypt as
# follows:
#
#   ./protect.sh <passphrase>
#
# And commit. HTML files will be accessible as password-protected HTML files
# that can be linked to from other Jekyll pages, where the contents is stored
# in AES-encrypted format, and decrypted on client-side. A copy is also stored
# to a .enc file for retrieving the original HTML file by the unprotect.sh
# script. Other files are simply encrypted by 7zip, which is accessible
# cross-platform.
#
# See unprotected/redirect_example.html for an example of how to make a
# protected link.
#
# Relies on StatiCrypt (https://github.com/robinmoisson/staticrypt), OpenSSL
# and 7zip.

shopt -s extglob

mkdir -p protected
cd unprotected

for file in *.html
do
    openssl enc -aes256 -pbkdf2 -pass "pass:$1" -in "$file" -out "../protected/$file.enc"
    staticrypt "$file" $1 -eo "../protected/$file"
done

for file in *.!(html) # Not HTML
do
    7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on -mhe=on -p"$1" "../protected/$file.7z" $file
done
