#!/bin/bash

KEY_STATUS=$(xset -q | grep Caps)
CAPS_LOCK=$(echo ${KEY_STATUS} | awk -v caps=4 '{print $caps}')
NUM_LOCK=$(echo ${KEY_STATUS} | awk -v num=8 '{print $num}')
# SCRL_LOCK=$(echo ${KEY_STATUS} | awk -v scrl=12 '{print $scrl}')

# xfce4-genmon-plugin uses https://docs.gtk.org/Pango/pango_markup.html for styling
if [[ "${CAPS_LOCK}" == "on" ]]; then
  CAPS_TXT="<span bgcolor=\"#ccc\" fgcolor=\"#000\"> Cap </span>"
else
  CAPS_TXT=" Cap "
fi

if [[ "${NUM_LOCK}" == "on" ]]; then
  NUM_TXT="<span bgcolor=\"#ccc\" fgcolor=\"#000\"> Num </span>"
else
  NUM_TXT=" Num "
fi

# if [[ "${SCRL_LOCK}" == "on" ]]; then
#   SCRL_TXT="1"
# else
#   SCRL_TXT="X"
# fi

# panel
echo -e "<txt> ${CAPS_TXT} ${NUM_TXT} </txt>"
# tooltip
echo -e "<tool>Caps lock and number lock status</tool>"