#!/bin/sh

function battery() {
  result=`/usr/bin/pmset -g ps | awk '{ if (NR == 2) print $2 " " $3 }' | sed "s/;//g"`
  battery=`echo $result | awk '{print $1}'`

  if [[ $result =~ "discharging" ]]; then
    echo $battery
  else
    echo $battery ⚡
  fi
}

function get_ssid() {
  result=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | tr -d " " | cut -c6-`
  if [ $result ]; then
    echo $result
  else
    echo No network
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
function rms() {
  echo -n "remove current directory, OK? [y, any]"
  read answer
  if [ $answer = "y" ]; then
    rm -r $PWD && cd ..
  fi
}
