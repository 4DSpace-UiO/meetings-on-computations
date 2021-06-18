#!/bin/bash

# FACILITATES PASSWORD PROTECTION OF SELECTED PAGES.

# First, you must unencrypt the protected pages as follows:
#
#   ./unprotect.sh <passphrase>
#
# The HTML files will now be stored in the "unprotected" folder (which must not
# be committed), where you can modify them, delete them or add more of them.
# Once you are done, you encrypt and commit as follows:
#
#   ./protect.sh <passphrase>
#
# Relies on OpenSSL and StatiCrypt (https://github.com/robinmoisson/staticrypt)

mkdir -p protected
cd unprotected
for file in *.html
do
    openssl enc -aes256 -pbkdf2 -pass "pass:$1" -in "$file" -out "../protected/$file.enc"
    staticrypt "$file" $1 -eo "../protected/$file"
done


