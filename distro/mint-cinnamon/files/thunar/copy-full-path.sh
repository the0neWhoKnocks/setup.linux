#!/bin/bash

# Linux has three clipboards: 'primary', 'secondary', and 'clipboard'.
# By default, xclip will feed into the primary clipboard, which you can paste 
# with the middle mouse button, and is overwritten whenever you highlight a 
# piece of text. The third clipboard, called 'clipboard', is the typical 
# `CTRL+C`/`CTRL+V` clipboard.

echo "${1}" | xclip
echo "${1}" | xclip -select clipboard
