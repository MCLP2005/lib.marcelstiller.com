#!/bin/bash

output_dir="/var/www/html/rss"
rss_file="$output_dir/haiku.xml"
entry_content="$1"
timestamp=$(date -Ru)
title="Daily Haiku - $(date '+%Y-%m-%d')"
link="https://stillermarcel.kit.com/"
guid="$link"

# Create RSS file if it doesn't exist
if [ ! -f "$rss_file" ]; then
    cat > "$rss_file" <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
<title>Daily Haiku RSS Feed</title>
<link>https://lib.marcelstiller.com/rss/haiku/</link>
<description>Automatically generated Haiku feed</description>
<lastBuildDate>$timestamp</lastBuildDate>
</channel>
</rss>
EOF
fi

# Insert new item before </channel>
tmpfile=$(mktemp)
awk -v content="$entry_content" -v title="$title" -v link="$link" -v guid="$guid" -v timestamp="$timestamp" '
/<\/channel>/ {
    print "  <item>"
    print "    <title>" title "</title>"
    print "    <link>" link "</link>"
    print "    <guid>" guid "</guid>"
    print "    <pubDate>" timestamp "</pubDate>"
    print "    <description><![CDATA[" content "]]></description>"
    print "  </item>"
}
{ print }
' "$rss_file" > "$tmpfile"

mv "$tmpfile" "$rss_file"