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

ls -l "$SOURCERY_COMMUNITY_TEMPLATES"
ls -l "$LOCAL_TEMPLATES"

TEMPLATES_PATH=(
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
    GENERATED_DIR_PATH="${dir}/Generated"
    echo $GENERATED_DIR_PATH
    mkdir -p "$GENERATED_DIR_PATH"

}

for dir in $(find "$SEARCH_PATH" -type d -name "Sources"); do
    generate_mocks "${dir}"
done

for dir in $(find "$SEARCH_PATH" -type d -name "Mocks"); do
    generate_mocks "${dir}"
done