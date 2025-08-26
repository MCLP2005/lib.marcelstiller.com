#!/bin/bash

# This script deploys the generated graphics to all servers listed in server.list

serverlist=$(cat ~/server.list)
repo="~/lib.marcelstiller.com/" # not used yet but might become usefull in the future

echo $serverlist | while IFS=';' read host name info; do 
    scp $host:/var/www/html/monitoring/graphics/local.svg /tmp/graphics/monitoring/$name.svg # Copy local.svg from remote host to local tmp directory
done

echo $serverlist | while IFS=';' read host name info; do
    scp /tmp/graphics/monitoring/*.svg $host:/var/www/html/monitoring/graphics/ # Copy all SVG files from local tmp directory to remote host
done

