#!/bin/bash
# Script to create GitHub repository using token
curl -X POST \
  -H "Authorization: token $GITHUB_PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d '{
    "name": "claude-custom-instructions",
    "description": "Custom instructions and configuration management for Claude development partner workflows",
    "private": true,
    "auto_init": false
  }'
