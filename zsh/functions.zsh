#!/bin/sh

function battery() {
  battery=`/usr/bin/pmset -g ps | awk '{ if (NR == 2) print $2 " " $3 }' | sed "s/;//g"`
  battery_quantity=`echo $battery | awk '{print $1}'`

  if [[ $battery =~ "discharging" ]]; then
    echo $battery_quantity
  else
    echo ⚡ $battery_quantity
  fi
}

function get_ssid() {
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | tr -d " " | cut -c6-
}

function is_network_connecting() {
  if [ ! `get_ssid` ]; then
    echo "✘"
  fi
}

#auto_cdでもcdでも実行後にhomeにいなければls
function chpwd() {
  echo \
    "${fg[blue]}——————————————${reset_color}${fg[black]}${bg[blue]}$PWD${reset_color}${reset_color}${fg[blue]}——————————————${reset_color}"
  [ $PWD = $HOME ] || gls -A --color=auto
}

#ディレクトリ作って入る
function mkcd() {
  mkdir $1 && cd $1
}

#カレントディレクトリを削除して抜ける
function rmc() {
  echo -n "remove current directory, OK? [y, any]"
  read answer
  if [ $answer = "y" ]; then
    rm -r $PWD && cd ..
  fi
}
