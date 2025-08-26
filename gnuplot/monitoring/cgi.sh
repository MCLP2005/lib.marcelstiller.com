#!/bin/bash

logdir="/data/logs"

deathscreen="$logdir/deathscreen.log"
style="$logdir/style.log"
teapot="$logdir/teapot.log"

deathscreen=$(cat $deathscreen | uniq -c | sed 's/^ *//;s/ *$//;s/\t/_/g')
style=$(cat $style | uniq -c | sed 's/^ *//;s/ *$//;s/\t/_/g')
teapot=$(cat $teapot | uniq -c | sed 's/^ *//;s/ *$//;s/\t/_/g')

echo $deathscreen | while IFS='_' read dt d ; do
    echo $style | while IFS='_' read st s ; do
        echo $teapot | while IFS='_' read tt t ; do
            if test "$dt" = "$st" && test "$dt" = "$tt"; then
                echo "$dt;$t;$d;$s" > /data/logs/cgi.log
            fi
        done
    done
done