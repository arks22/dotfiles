#!/bin/sh

function battery() {
  result=`/usr/bin/pmset -g ps | awk '{ if (NR == 2) print $2 " " $3 }' | sed "s/;//g"`
  echo $result
}

function wifi() {
  result=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | tr -d " " | cut -c6-`
  if [ $result ]; then
    echo $result
  else
    echo No network
  fi
}

