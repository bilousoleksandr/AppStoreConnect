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

TEMPLATES=()
IMPORTS=()

while getopts "i::t::" opt; do
  case ${opt} in
    t) # do 'm' thing
      TEMPLATES+=("${OPTARG}")
      ;;
    i) # do 'b' thing
      IMPORTS+=("${OPTARG}")
      ;;
  esac
done

FILE_PATH=$(readlink -f "$0")
SEARCH_PATH="$(dirname "$FILE_PATH")/../../Targets"

TEMPLATES_FILES=()

for TEMPLATES_PATH in "${TEMPLATES_PATHS[@]}"; do
    for template in "${TEMPLATES[@]}"; do
        for template_file in $(find "$TEMPLATES_PATH" -type f -name "**${template}**"); do
            echo $template_file
            TEMPLATES_FILES+=("${template_file}")
        done
    done
done

template_args=()
echo "${TEMPLATES_FILES[@]}"
for template in "${TEMPLATES_FILES[@]}"; do
    template_args+=(--templates "$template")
done

output_dir=$(dirname "$SCRIPT_OUTPUT_FILE_0")


echo $SCRIPT_INPUT_FILE_LIST_1

sources_args=()
for (( i=0; i<$SCRIPT_INPUT_FILE_COUNT; i+=1))
do
    base_name="SCRIPT_INPUT_FILE"
    file_name="${base_name}_${i}"
    sources_args+=(--sources "${!file_name}")
done

echo "sources_args ${sources_args[@]}"
echo "templates ${template_args[@]}"
echo "outputs ${output_files[@]}"

wrap_with_quotes() {
    local input_strings=("$@")
    local wrapped_strings=()

    # Iterate over each string and wrap it with double quotes
    for str in "${input_strings[@]}"; do
        wrapped_strings+=("\"$str\"")
    done

    # Print the wrapped strings
    echo "${wrapped_strings[@]}"
}

imports=$(wrap_with_quotes "${IMPORTS[@]}")
imports_joined="${imports// /, }"

"${SOURCERY_PATH}" \
    --verbose \
    --logAST \
    --logBenchmarks \
    "${sources_args[@]}" \
    "${template_args[@]}" \
    "--output" "${output_dir}" \
    --args autoMockableImports=\'["${imports_joined}"]\'