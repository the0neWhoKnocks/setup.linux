#!/usr/bin/env python3

import json, os, sys

filePath = sys.argv[1]
fileName = sys.argv[2]
rawMetadata = os.popen(f'ffprobe -v quiet -print_format json -show_format -show_streams "{filePath}"').read()
metadata = json.loads(rawMetadata)

fields = []
longestKey = 0
def addField(key, val):
  global longestKey
  fields.append([key, val])
  
  keyLen = len(key)
  if keyLen > longestKey:
    longestKey = keyLen

addField('Path', filePath)

duration = metadata['format']['duration']
if duration:
  mins = float(duration) / 60
  secs = (mins % 1) * 60
  hrs = '00'
  
  if mins > 60:
    hrs = mins / 60
    mins = mins - (int(hrs) * 60)
  
  addField(
    'Duration',
    f"{str(int(hrs)).zfill(2)}h:{str(int(mins)).zfill(2)}m:{str(int(secs)).zfill(2)}s"
  )

tags = metadata['format']['tags']
if tags:
  for key in sorted(tags.keys()):
    addField(key, tags[key])

output = ''
for key, val in fields:
  output += f"{key.ljust(longestKey, ' ')} | {val}\n"

os.system(f'printf "{output}" | zenity --width=400 --height=400 --window-icon="/usr/share/icons/Mint-Y/status/32/dialog-information.png" --title="{fileName}" --text-info --no-wrap --font="DejaVu Sans Mono"')
