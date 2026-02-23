#!/bin/bash

# --- CONFIGURATION FROM GITLAB VARS ---
HUB_USER="${DOCKERHUB_USER}"
HUB_PASSWORD="${DOCKERHUB_API_KEY}"
# GitLab's project name variable is CI_PROJECT_NAME
# Note: Docker Hub repos are lowercase; we use 'tr' to ensure a match.
REPO=$(echo "${CI_PROJECT_NAME}" | tr '[:upper:]' '[:lower:]')

# Your SemVer Regex
PROTECT_REGEX="^?[0-9]+\.[0-9]+\.[0-9]+(?:-(?:alpha|beta|rc|preview|prerelease)(?:\.[0-9]+[a-z]*)?)?(?:\+[a-zA-Z0-9-.]+)?$"

echo "Starting cleanup for $HUB_USER/$REPO..."

# --- 1. Get Authentication Token ---
TOKEN=$(curl -s -H "Content-Type: application/json" \
  -X POST \
  -d '{"username": "'$HUB_USER'", "password": "'$HUB_PASSWORD'"}' \
  https://hub.docker.com/v2/users/login/ | jq -r .token)

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
    echo "Error: Could not authenticate. Check DOCKERHUB_USER and DOCKERHUB_API_KEY."
    exit 1
fi

# --- 2. Fetch and Loop through Tags ---
# This pulls the 100 most recent tags
RAW_TAGS=$(curl -s -H "Authorization: JWT $TOKEN" \
  "https://hub.docker.com/v2/repositories/$HUB_USER/$REPO/tags/?page_size=100" \
  | jq -r '.results[].name')

for TAG in $RAW_TAGS; do
    # 1. Skip if it matches your SemVer regex
    if [[ $TAG =~ $PROTECT_REGEX ]]; then
        echo "KEEPING (Protected): $TAG"
        continue
    fi

    # 2. Skip 'latest'
    if [[ "$TAG" == "latest" ]]; then
        echo "KEEPING (Latest): $TAG"
        continue
    fi

    # 3. If it reached here, it's a Commit SHA or junk tag. Delete it.
    echo "DELETING (No Match): $TAG"
    
    DELETE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
      -H "Authorization: JWT $TOKEN" \
      "https://hub.docker.com/v2/repositories/$HUB_USER/$REPO/tags/$TAG/")

    if [ "$DELETE_RESPONSE" == "204" ]; then
        echo "Successfully deleted $TAG"
    else
        echo "Failed to delete $TAG (HTTP $DELETE_RESPONSE)"
    fi
done

echo "Cleanup finished."