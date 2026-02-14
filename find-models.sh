#!/bin/bash

API_KEY="7e6e2d05b92942a7a8c9e58d1fb87d23.aSvaGQLr2pw87cDZ"
API_BASE="https://api.lingyiwanwu.com/v1"

echo "Testing different GLM-5 model name variations..."
echo "================================================"
echo ""

# Array of possible model names to test
models=(
    "glm-5"
    "glm-5-flash"
    "glm-5-plus"
    "glm-5-pro"
    "glm5"
    "glm5-flash"
    "glm5-plus"
    "glm-4-plus"
    "glm-4-flash"
)

for model in "${models[@]}"; do
    echo "Testing model: $model"
    response=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "$API_BASE/chat/completions" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d "{
        \"model\": \"$model\",
        \"messages\": [{\"role\": \"user\", \"content\": \"Say 'OK'\"}],
        \"max_tokens\": 5
      }")

    http_status=$(echo "$response" | grep "HTTP_STATUS:" | cut -d':' -f2)
    body=$(echo "$response" | sed '/HTTP_STATUS:/d')

    if [ "$http_status" = "200" ]; then
        echo "✅ SUCCESS - Model '$model' works!"
        echo "   Response: $(echo "$body" | jq -r '.choices[0].message.content // empty' 2>/dev/null || echo "Could not parse")"
    else
        error_msg=$(echo "$body" | jq -r '.error.message // .error // empty' 2>/dev/null || echo "$body")
        echo "❌ FAILED - $error_msg"
    fi
    echo ""
done

echo "================================================"
echo "Attempting to list all available models..."
curl -s "$API_BASE/models" \
  -H "Authorization: Bearer $API_KEY" | jq -r '.data[]? | select(.id | contains("glm")) | .id' 2>/dev/null || echo "Could not list models (endpoint may not exist)"
