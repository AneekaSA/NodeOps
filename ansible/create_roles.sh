#!/bin/bash

# Roles to create
ROLES=("common" "docker" "node-app")

# Base directory (adjust if different)
BASE_DIR="."

# Loop through roles and create directories/files
for role in "${ROLES[@]}"; do
  mkdir -p "$BASE_DIR/roles/$role/tasks"
  touch "$BASE_DIR/roles/$role/tasks/main.yml"
done

echo "Ansible roles structure created successfully!"
