#!/bin/bash

# Read version from params.yml
VERSION=$(grep "version:" params.yml | awk '{print $2}')
SIZE=$(grep "${VERSION}:" params.yml | awk '{print $2}')

# API URL (replace <API_URL> with the actual URL provided in the project overview)
API_URL="<API_URL>?size=${SIZE}"

# Fetch data from API
NEW_DATA=$(curl -s "$API_URL")

# Format data with jq and save to temporary file
echo "$NEW_DATA" | jq '.' > datahub/new_data.json

# Check if datahub/data.json exists and if it’s different from new data
if [ -f "datahub/data.json" ]; then
  if cmp -s datahub/new_data.json datahub/data.json; then
    echo "No changes; data has not changed."
    rm datahub/new_data.json
    exit 0
  fi
fi

# If different or no existing data.json, replace it
mv datahub/new_data.json datahub/data.json
echo "Data updated in datahub/data.json"
