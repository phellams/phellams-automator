#!/bin/bash

# --- CONFIGURATION FROM GITLAB VARS ---
HUB_USER="${DOCKERHUB_USER}"
HUB_PASSWORD="${DOCKERHUB_API_KEY}"
# Ensure the repo name is lowercase to match Docker Hub standards
REPO=$(echo "${CI_PROJECT_NAME}" | tr '[:upper:]' '[:lower:]')

# --- UPDATED REGEX ---
# 1. Made 'v' optional at the start
# 2. Replaced \d with [0-9] for Bash compatibility
PROTECT_REGEX="^v?[0-9]+\.[0-9]+\.[0-9]+(?:-(?:alpha|beta|rc|preview|prerelease)(?:\.[0-9]+[a-z]*)?)?(?:\+[a-zA-Z0-9-.]+)?$"

echo "Starting cleanup for $HUB_USER/$REPO..."

# 1. Get Authentication Token
TOKEN=$(curl -s -H "Content-Type: application/json" \
  -X POST \
  -d "{\"username\": \"$HUB_USER\", \"password\": \"$HUB_PASSWORD\"}" \
  https://hub.docker.com/v2/users/login/ | jq -r .token)

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
    echo "Error: Could not authenticate. Check credentials."
    exit 1
fi

# 2. Fetch Tags
RAW_TAGS=$(curl -s -H "Authorization: JWT $TOKEN" \
  "https://hub.docker.com/v2/repositories/$HUB_USER/$REPO/tags/?page_size=100" \
  | jq -r '.results[].name')

# 3. Filter and Delete
for TAG in $RAW_TAGS; do
    # Check against Regex
    if [[ $TAG =~ $PROTECT_REGEX ]]; then
        echo ">> KEEPING (Matches SemVer): $TAG"
        continue
    fi

    # Explicit check for 'latest'
    if [ "$TAG" == "latest" ]; then
        echo ">> KEEPING (Latest): $TAG"
        continue
    fi

    # If it reached here, delete it
    echo "!! DELETING (No Match): $TAG"
    
    # HTTP DELETE request
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
      -H "Authorization: JWT $TOKEN" \
      "https://hub.docker.com/v2/repositories/$HUB_USER/$REPO/tags/$TAG/")

    if [ "$STATUS" == "204" ] || [ "$STATUS" == "200" ]; then
        echo "Successfully deleted $TAG"
    else
        echo "Failed to delete $TAG (HTTP $STATUS)"
    fi
done

echo "Cleanup finished."