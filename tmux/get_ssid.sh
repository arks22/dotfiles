#!/bin/sh

ssid=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | awk '{$1="";print}' | sed "s/ //"`
if [ -n "$ssid" ]; then
  echo "#[fg=blue]$ssid#[default]"
else
  echo "#[fg=red]✘#[default]"
fi
