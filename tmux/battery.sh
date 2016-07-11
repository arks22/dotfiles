#!/bin/sh

battery=`/usr/bin/pmset -g ps | awk '{ if (NR == 2) print $2 " " $3 }' | sed -e "s/;//g" -e "s/%//"`
battery_quantity=`echo $battery | awk '{print $1}'`
if [[ ! $battery =~ "discharging" ]]; then
  echo "#[fg=yellow]⚡ #[default]#[fg=cyan]$battery_quantity%#[default]"
elif [ $battery_quantity -le 10 ]; then
  echo "#[fg=red]$battery_quantity%#[default]"
else
  echo "#[fg=cyan]$battery_quantity%#[default]"
fi
