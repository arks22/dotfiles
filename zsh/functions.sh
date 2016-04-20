#!/bin/sh

function battery() {
  /usr/bin/pmset -g ps | awk '{ if (NR == 2) print $2 " " $3 }' | sed "s/;//g"
}

function wifi() {
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | tr -d " " | cut -c6-
}

