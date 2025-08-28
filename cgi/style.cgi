#!/bin/bash
echo "content-type: text/css"
echo

echo "/* Usage guide
# .w{n} sets width to n vw (viewport) -> .w20 sets width to 20% of the viewport width (screen width)
# .h{n} sets height to n vh (viewport) -> .h30 sets height to 30% of the viewport height (screen height)
# .max-h{n} sets max-height to n vh (viewport) -> .max-h30 sets max-height to 30% of the viewport height (screen height)
# .min-h{n} sets min-height to n vh (viewport) -> .min-h30 sets min-height to 30% of the viewport height (screen height)
# .max-w{n} sets max-width to n vw (viewport) -> .max-w30 sets max-width to 30% of the viewport width (screen width)
# .min-w{n} sets min-width to n vw (viewport) -> .min-w30 sets min-width to 30% of the viewport width (screen width)
# .p{n} sets padding to n em -> .p1 sets padding to 1em
# .m{n} sets margin to n em -> .m1 sets margin to 1em
# .b{n} sets border-width to n px -> .b2 sets border-width to 2px
# .br{n} sets border-radius to n em -> .br1 sets border-radius to 1em
# .fs{n} sets font-size to n em -> .fs1 sets font-size to 1em
# .lh{n} sets line-height to n em -> .lh1 sets line-height to 1em
# .ls-{n} sets letter-spacing to n px -> .ls-1 sets letter-spacing to 1px
# .text-{n} sets font-size to n px -> .text-1 sets font-size to 1px
*/

"

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
  echo
  (( ++i ))
done

echo "$(date +'%F %H:%M')" >> /data/logs/style.log