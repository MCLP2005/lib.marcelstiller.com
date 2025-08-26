#!/bin/bash
echo "content-type: text/css"
echo

i=0

while test $i -le 100; do
  echo .w${i} { width: ${i}vw }
  echo .h${i} { height: ${i}vh }
  (( ++i ))
done

echo "$(date +'%F %H:%M') > /data/logs/style.log