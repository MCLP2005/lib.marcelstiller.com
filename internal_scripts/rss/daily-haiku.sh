#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<__HELP__
Usage: $(basename "$0") [-d FEED_DIR] [-f FEED_FILE] [-p PROMPT_FILE] [--] [PROMPT]

Generates a daily haiku using the OpenAI API (model: gpt-5-nano with web search)
and appends it as an <item> to an RSS feed.

Options:
  -d FEED_DIR      Directory containing the RSS feed (default: current dir or FEED_DIR env)
  -f FEED_FILE     RSS filename (default: daily-haiku.xml or FEED_FILE env)
  -p PROMPT_FILE   Read prompt from the given file
  -h               Show this help

Environment:
  OPENAI_API_KEY   Required. Your OpenAI API key
  OPENAI_BASE_URL  Optional. Defaults to https://api.openai.com
  FEED_DIR         Optional default for -d
  FEED_FILE        Optional default for -f

Prompt sources (in priority order):
  1) Command-line PROMPT
  2) -p PROMPT_FILE
  3) Piped stdin

The RSS feed will have channel title "daily haiku" and link https://stillermarcel.kit.com.
Each new item title is the current date in YYYY-MM-DD; description contains the AI output.
__HELP__
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Error: required command '$1' not found" >&2; exit 1; }
}

extract_first_nonempty() {
  jq -r 'if type=="string" then . else empty end' 2>/dev/null || true
}

OPENAI_BASE_URL="${OPENAI_BASE_URL:-https://api.openai.com}"
FEED_DIR="${FEED_DIR:-.}"
FEED_FILE="${FEED_FILE:-daily-haiku.xml}"
PROMPT_FILE=""

while getopts ":d:f:p:h" opt; do
  case "$opt" in
    d) FEED_DIR="$OPTARG" ;;
    f) FEED_FILE="$OPTARG" ;;
    p) PROMPT_FILE="$OPTARG" ;;
    h) usage; exit 0 ;;
    :) echo "Error: Option -$OPTARG requires an argument" >&2; exit 1 ;;
    \?) echo "Error: Invalid option -$OPTARG" >&2; usage; exit 1 ;;
  esac
done
shift $((OPTIND-1))

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "Error: OPENAI_API_KEY is not set" >&2
  exit 1
fi

require_cmd curl
require_cmd jq
require_cmd date
require_cmd mktemp

PROMPT=""
if [[ $# -gt 0 ]]; then
  PROMPT="$*"
elif [[ -n "$PROMPT_FILE" ]]; then
  if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "Error: PROMPT file not found: $PROMPT_FILE" >&2
    exit 1
  fi
  PROMPT="$(cat "$PROMPT_FILE")"
elif [ ! -t 0 ]; then
  PROMPT="$(cat)"
else
  echo "Error: No prompt provided. Pass as argument, via -p PROMPT_FILE, or pipe via stdin." >&2
  exit 1
fi

mkdir -p "$FEED_DIR"
FEED_PATH="$FEED_DIR/${FEED_FILE}"

TODAY_YMD="$(date -u +%F)"
RFC2822_NOW="$(date -u +"%a, %d %b %Y %H:%M:%S GMT")"

API_URL="$OPENAI_BASE_URL/v1/responses"

REQUEST_JSON=$(jq -n --arg prompt "$PROMPT" '{
  model: "gpt-5-nano",
  input: $prompt,
  tools: [ {type: "web_search"} ],
  max_output_tokens: 300
}')

RESPONSE_RAW=$(curl -sS "$API_URL" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_JSON" || true)

if [[ -z "$RESPONSE_RAW" ]]; then
  echo "Error: Empty response from OpenAI API" >&2
  exit 1
fi

if echo "$RESPONSE_RAW" | jq -e .error >/dev/null 2>&1; then
  echo "Error from API: $(echo "$RESPONSE_RAW" | jq -r .error.message)" >&2
  exit 1
fi

AI_TEXT=$(echo "$RESPONSE_RAW" | jq -r '
  .output_text //
  (.content // empty | if type=="array" then .[0].text // .[0].content // empty else . end) //
  (.choices // empty | if type=="array" then .[0].message.content // .[0].text // empty else . end) //
  empty
')

if [[ -z "$AI_TEXT" || "$AI_TEXT" == "null" ]]; then
  echo "Error: Could not extract text from API response" >&2
  echo "$RESPONSE_RAW" >&2
  exit 1
fi

AI_TEXT_TRIMMED=$(printf "%s" "$AI_TEXT" | sed 's/[\r\t]\+//g')

ensure_feed_exists() {
  if [[ -f "$FEED_PATH" ]]; then
    return
  fi
  cat > "$FEED_PATH" <<'__FEED__'
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>daily haiku</title>
    <link>https://stillermarcel.kit.com</link>
    <description>AI-generated daily haiku</description>
    <lastBuildDate>REPLACED_AT_RUNTIME</lastBuildDate>
    <pubDate>REPLACED_AT_RUNTIME</pubDate>
    <ttl>1440</ttl>
  </channel>
</rss>
__FEED__
  sed -i "s/REPLACED_AT_RUNTIME/$RFC2822_NOW/g" "$FEED_PATH"
}

add_item_to_feed() {
  if grep -q "<title>$TODAY_YMD</title>" "$FEED_PATH" 2>/dev/null; then
    echo "Item for $TODAY_YMD already present; not adding duplicate" >&2
    return
  fi

  TMP_FILE=$(mktemp)
  trap 'rm -f "$TMP_FILE"' EXIT

  awk -v now="$RFC2822_NOW" -v title="$TODAY_YMD" -v link="https://stillermarcel.kit.com" -v desc="$AI_TEXT_TRIMMED" '
    BEGIN { item = "  <item>\n" \
                    "    <title>" title "</title>\n" \
                    "    <link>" link "</link>\n" \
                    "    <guid isPermaLink=\"false\">" title "</guid>\n" \
                    "    <pubDate>" now "</pubDate>\n" \
                    "    <description><![CDATA[" desc "]]></description>\n" \
                    "  </item>\n" }
    {
      if ($0 ~ /<lastBuildDate>/) {
        sub(/<lastBuildDate>.*<\/lastBuildDate>/, "<lastBuildDate>" now "</lastBuildDate>")
      }
    }
    /<\/channel>/ {
      print item
    }
    { print }
  ' "$FEED_PATH" > "$TMP_FILE"

  mv "$TMP_FILE" "$FEED_PATH"
  trap - EXIT
}

ensure_feed_exists
add_item_to_feed

echo "Added daily haiku for $TODAY_YMD to $FEED_PATH"

