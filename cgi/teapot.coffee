#!/bin/bash

echo "content-type: text/plain"
echo "Status: 418 I'm a teapot"
echo

echo "$(date +'%F %H:%M')" >> /data/logs/teapot.log"