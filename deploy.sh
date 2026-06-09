#!/usr/bin/env bash
set -e
REPO="northsouth-loyalty-workflow"
USER=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | python3 -c "import sys,json;print(json.load(sys.stdin)['login'])")
echo "Deploying for: $USER"
curl -s -X POST https://api.github.com/user/repos \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO\",\"description\":\"NorthSouth Coffee 5-Agent Loyalty Workflow\",\"auto_init\":false,\"private\":false}" > /dev/null
CONTENT=$(base64 -w 0 index.html)
curl -s -X PUT "https://api.github.com/repos/$USER/$REPO/contents/index.html" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"message\":\"deploy: 5-agent loyalty workflow\",\"content\":\"$CONTENT\"}" > /dev/null
curl -s -X POST "https://api.github.com/repos/$USER/$REPO/pages" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"source":{"branch":"main","path":"/"}}' > /dev/null
echo "Live at: https://$USER.github.io/$REPO"
