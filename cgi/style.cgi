#!/bin/bash
echo "content-type: text/css"
echo

i=0

while test $i -le 100; do
  echo .w${i} { width: ${i}vw }
  echo .h${i} { height: ${i}vh }
  echo .min-h${i} { min-height: ${i}vh }
  echo .max-h${i} { max-height: ${i}vh }
  echo .min-w${i} { min-width: ${i}vw }
  echo .max-w${i} { max-width: ${i}vw }
  echo .b${i} { border-width: ${i}px }
  echo .br${i} { border-radius: ${i}em }
  echo .m${i} { margin: ${i}em }
  echo .p${i} { padding: ${i}em }
  echo .fs${i} { font-size: ${i}em }
  echo .lh${i} { line-height: ${i}em }
  echo .ls-${i} { letter-spacing: ${i}px }
  echo .text-${i} { font-size: ${i}px }
  (( ++i ))
done

echo "$(date +'%F %H:%M')" >> /data/logs/style.log