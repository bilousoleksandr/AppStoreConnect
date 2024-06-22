#!/bin/bash

MISE_PATH="${HOME}/.local/bin/mise"
SOURCERY_PATH="$("$MISE_PATH" which "sourcery")"

if [ -n "$SOURCERY_PATH" ]; then
    echo "The path to sourcery is: $SOURCERY_PATH"
else
    exit "Sourcery not found in PATH"
fi

SOURCERY_DIR=$(dirname "${SOURCERY_PATH}")
SOURCERY_COMMUNITY_TEMPLATES="${SOURCERY_DIR}/../Templates"
LOCAL_TEMPLATES="$(dirname "$0")/Templates"

echo "Templates found"
ls -l "$SOURCERY_COMMUNITY_TEMPLATES"
ls -l "$LOCAL_TEMPLATES"

TEMPLATES_PATHS=(
    "$SOURCERY_COMMUNITY_TEMPLATES"
    "$LOCAL_TEMPLATES"
)

FILE_PATH=$(readlink -f "$0")
SEARCH_PATH="$(dirname "$FILE_PATH")/../../Targets"

get_basename_without_extension() {
    local file_path="$1"
    
    # Extract the base name and remove the extension
    local base_name=$(basename "$file_path")
    local name_without_extension="${base_name%.*}"

    echo "$name_without_extension"
}

generate_mocks() {
    local dir_path="$1"
    GENERATED_DIR_PATH="${dir_path}/Generated"
    mkdir -p "${GENERATED_DIR_PATH}"

    for TEMPLATES_PATH in "${TEMPLATES_PATHS[@]}"; do
        for template in $(find "$TEMPLATES_PATH" -type f); do
            TEMPLATE_NAME=$(get_basename_without_extension "${template}")
            touch "${GENERATED_DIR_PATH}/${TEMPLATE_NAME}.generated.swift"
        done
    done 
}

find_and_generate_mocks_for_dirs() {
    local pattern="$1"
    for target_directory_path in $(find "$SEARCH_PATH" -type d -name "${pattern}"); do
        echo $target_directory_path
        generate_mocks "${target_directory_path}"
    done
}

find_and_generate_mocks_for_dirs "Sources"
find_and_generate_mocks_for_dirs "Mocks"