#!/usr/bin/env bash
echo content-type: text/html
echo
echo "<!DOCTYPE html><html><head><meta charset='utf-8'><title>Game Over</title></head><body style='background-color:black;'><div style='height:30vh'></div>"
echo "<p style='text-align:center;width:98vw;color:red;font-size:8vh'>Game Over</p>"
echo "<p style='text-align:center;width:98vw;color:white;font-size:4vh'>$(echo $QUERY_STRING | sed 's/_/ /g')</p></body></html>"

# Example usage: http://yourserver/cgi/deathscreen.cgi?You_have_died_due_to_a_trap

echo "$(date +'%F %H:%M')" >> /data/logs/deathscreen.log