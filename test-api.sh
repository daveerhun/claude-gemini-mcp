#!/bin/bash

# Test Z.ai API to verify model names
API_KEY="7e6e2d05b92942a7a8c9e58d1fb87d23.aSvaGQLr2pw87cDZ"

echo "Testing GLM-5 model names..."
echo ""

# Test with glm-5-flash
echo "1. Testing glm-5-flash:"
curl -s https://api.lingyiwanwu.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "glm-5-flash",
    "messages": [{"role": "user", "content": "Say hello"}],
    "max_tokens": 10
  }' | jq '.error // .choices[0].message.content'

echo ""
echo "2. Testing glm-5-plus:"
curl -s https://api.lingyiwanwu.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "glm-5-plus",
    "messages": [{"role": "user", "content": "Say hello"}],
    "max_tokens": 10
  }' | jq '.error // .choices[0].message.content'

echo ""
echo "3. List available models (if endpoint exists):"
curl -s https://api.lingyiwanwu.com/v1/models \
  -H "Authorization: Bearer $API_KEY" | jq '.data[] | select(.id | contains("glm")) | .id'
