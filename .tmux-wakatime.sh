#!/bin/bash

source "$(dirname "$0")/config.sh"

# Fetch today's total coding time
TIME_CODING=$(curl -s -u "$API_KEY:" "https://wakatime.com/api/v1/users/current/summaries?range=Today" | jq -r '.data[].grand_total.text')

# Default text if no data
if [[ -z "$TIME_CODING" || "$TIME_CODING" == "null" ]]; then
  TIME_CODING="No Data"
fi

echo "$TIME_CODING"
