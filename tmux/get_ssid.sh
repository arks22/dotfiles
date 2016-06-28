#!/bin/sh

ssid=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | awk '{print $2}'`
if [ $ssid ]; then
  echo "#[fg=blue]$ssid#[default]"
else
  echo "#[fg=red]✘#[default]"
fi
