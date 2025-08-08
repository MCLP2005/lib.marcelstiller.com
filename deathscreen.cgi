#!/usr/bin/env bash
echo content-type: text/html
echo
echo "<!DOCTYPE html><html><head><meta charset='utf-8'><title>Game Over</title></head><body style='background-color:black;'><div style='height:30vh'></div>"
echo "<p style='text-align:center;width:98vw;color:red;font-size:8vh'>Game Over</p>"
echo "<p style='text-align:center;width:98vw;color:white;font-size:4vh'>$(echo $QUERY_STRING | sed 's/_/ /g')</p></body></html>"
