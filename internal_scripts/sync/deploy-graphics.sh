#!/bin/bash
serverlist=$(cat ~/server.list)
repo="~/lib.marcelstiller.com/" # not used yet but might become usefull in the future

for s in $serverlist; do
    scp $s:/var/www/html/monitoring/graphics/local.svg /tmp/graphics/monitoring/$s.svg
done

for s in $serverlist; do
    scp /tmp/graphics/monitoring/*.svg $s:/var/www/html/monitoring/graphics/
done

