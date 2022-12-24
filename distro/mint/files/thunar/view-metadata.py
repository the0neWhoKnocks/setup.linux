#!/usr/bin/env python3

##
# Debug script:
# - Run `tail -f ~/.xsession-errors`
# - Execute the action from Thunar, close the newly opened window to see any
#   printed output from the script.
##

import json, os, sys

filePath = sys.argv[1]
fileName = sys.argv[2]
rawMetadata = os.popen(f'ffprobe -v quiet -print_format json -show_format -show_streams "{filePath}"').read()
metadata = json.loads(rawMetadata)

## Uncomment to print raw data
# print( json.dumps(metadata, indent=2) )

fileType = 'audio'
fileStream = None
if metadata['streams']:
  for stream in metadata['streams']:
    if stream['codec_type'] == 'video':
      fileType = 'video'
      fileStream = stream
      break
    elif stream['codec_type'] == 'audio': # there can be multiple audio tracks in a video, this is only for music files
      fileStream = stream

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

if fileType == 'video':
  addField('Dimensions', f"{fileStream['coded_width']}x{fileStream['coded_height']}")

addField('Codec', fileStream['codec_name'])

tags = metadata['format']['tags']
if tags:
  for key in sorted(tags.keys()):
    addField(key, tags[key])

output = ''
for key, val in fields:
  output += f"{key.ljust(longestKey, ' ')} | {val}\n"

os.system(f'printf "{output}" | zenity --width=400 --height=400 --window-icon="/usr/share/icons/Mint-Y/status/32/dialog-information.png" --title="{fileName}" --text-info --no-wrap --font="DejaVu Sans Mono"')
