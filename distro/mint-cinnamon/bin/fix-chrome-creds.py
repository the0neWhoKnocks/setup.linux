#! /usr/bin/env python3

##
# IMPORTANT: If you are on a system that has a password/key manager running you'll
# need to provide `--password "<KEY>"` when you run the command. For example on
# Linux XFCE, go into Settings and look up 'password'. In the password manager
# there should be a section like Passwords > Login, which may contain an entry
# for 'Chrome Safe Storage'. The password in that entry is what's needed for
# this script. If you've ported your Chrome profile form another computer, you'll
# need the key from that system to decode the data.
# If you see errors regarding 'index out of range', then it's likely the passwords
# were encoded with another key, and the result wasn't fully decoded.
# 
# cobbled together from:
#   - https://stackoverflow.com/a/23727331
#   - https://stackoverflow.com/a/71043463
#   - https://github.com/mramendi/chrome_password_grabber/blob/4fe87845e2638d0286d29c4a28da56a47b860749/chrome.py
##

import argparse, base64, json, os, platform, shutil, sqlite3
from Crypto.Cipher import AES
from Crypto.Protocol.KDF import PBKDF2
from colorama import Fore, Back, Style

currOS = platform.system()
parser = argparse.ArgumentParser(
  prog = "Fix Chrome Creds",
  description = "Strips out credentials that can't be parsed by Chrome.",
)

parser.add_argument(
  "-f",
  "--file-path",
  dest = "DB_FILE_PATH",
  help = "Absolute path to your Chrome profile's 'Login Data' file. On Linux it'd be something like '/home/<USER>/.config/google-chrome/<Default|Profile #>/Login Data', and OSX '/Users/<USER>/Library/Application Support/Google/Chrome/<Default|Profile #>/Login Data'",
  required = True,
)
parser.add_argument(
  "-p",
  "--password",
  default = "",
  dest = "USER_PASS",
  help = "The password you use to log in with. Only required on OSX",
  required = currOS == "Darwin",
)
args = parser.parse_args()

def clean(x):
  bytesLength = len(x)
  return '' if bytesLength == 0 else x[:-x[-1]].decode("utf-8")

if currOS == "Darwin" or currOS == "Linux":
  userPass = args.USER_PASS if currOS == "Darwin" or args.USER_PASS != "" else "peanuts"
  userPass = userPass.encode("utf8")
  iterations = 1003 if currOS == "Darwin" else 1
  # Default values used by both Chrome and Chromium in OSX and Linux
  salt = b"saltysalt"
  iv = b" " * 16
  length = 16
  
  key = PBKDF2(userPass, salt, length, iterations)
  
  # create a proxy work file
  newDBFilePath = os.path.expanduser("~/Desktop/Chrome_Creds.sqlite3")
  if os.path.exists(newDBFilePath): os.remove(newDBFilePath)
  shutil.copy(args.DB_FILE_PATH, newDBFilePath)
  
  # parse the data
  db = sqlite3.connect(newDBFilePath)
  cursor = db.cursor()
  goodCount = 0
  badItems = []
  print("\n ----")
  for rowId, url, username, passwordBlob in cursor.execute("SELECT id, origin_url, username_value, password_value FROM logins;"):
    try:
      # Trim off the 'v10' or 'v11' that Chrome/ium prepends
      trimmedPassword = passwordBlob[3:]
      
      cipher = AES.new(key, AES.MODE_CBC, iv)
      decryptedPassword = cipher.decrypt(trimmedPassword)
      
      print(f" {Fore.GREEN}✔{Style.RESET_ALL} {url} | '{clean(decryptedPassword)}'")
      goodCount += 1
    except Exception as err:
      print(f" {Fore.RED}✘{Style.RESET_ALL} {url} | {err}")
      badItems.append(rowId)
  
  # delete bad items
  badItems.reverse()
  for badId in badItems:
    cursor.execute(f"DELETE FROM logins WHERE id={badId};")
  cursor.connection.commit()
  
  # remove empty blocks
  db.execute(f"VACUUM;")
  
  # done with DB
  db.close()
  
  badCount = len(badItems)
  print(f" ----\n {goodCount + badCount} Credentials | {Fore.GREEN}✔ {goodCount}{Style.RESET_ALL} | {Fore.RED}✘ {badCount}{Style.RESET_ALL}")
  print(f" \n Created: {newDBFilePath}")
else:
  print("This script doesn't support Windows")
