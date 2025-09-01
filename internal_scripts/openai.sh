#!/bin/bash

# Usage: ./openai.sh "Your prompt here" <web_search: 1|0>

API_KEY="${OPENAI_API_KEY}"
MODEL="gpt-5-nano"
PROMPT="$1"
WEB_SEARCH="$2"

if [ -z "$API_KEY" ]; then
    echo "Error: Please set the OPENAI_API_KEY environment variable."
    exit 1
fi

if [ -z "$PROMPT" ]; then
    echo "Usage: $0 \"Your prompt here\" <web_search: 1|0>"
    exit 1
fi

if [ -z "$WEB_SEARCH" ]; then
    WEB_SEARCH=0
fi

# Add web_search parameter to payload if enabled
if [ "$WEB_SEARCH" -eq 1 ]; then
    EXTRA='"web_search": true,'
else
    EXTRA='"web_search": false,'
fi

RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "'"$MODEL"'",
        '"$EXTRA"'
        "messages": [{"role": "user", "content": "'"$PROMPT"'"}],
        "max_tokens": 512
    }')

echo "$RESPONSE" | grep -o '"content":"[^"]*"' | sed 's/"content":"//;s/"$//'