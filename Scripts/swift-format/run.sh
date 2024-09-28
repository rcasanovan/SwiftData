#!/bin/bash

##################################################################
# Runs swift-format and replaces current files.
#
# It formats any modified swift file
##################################################################

# Get the root directory of the git repository
ROOT_DIR=$(git rev-parse --show-toplevel)

# Get modified Swift files with whitespace in path
MODIFIED_SWIFT_FILES=()
GIT_DIFF_OUTPUT=$(git diff --name-only)

while IFS= read -r line; do
  if [[ $line == *".swift"* ]]; then
    MODIFIED_SWIFT_FILES+=("$line")
  fi
done <<< "$GIT_DIFF_OUTPUT"

if [ ${#MODIFIED_SWIFT_FILES[@]} -eq 0 ]; then
  echo "There are no swift files to format!"
  exit 1
fi

echo "Swift-format version: $(swift-format --version)"

# Format the Swift files
echo "Formatting Swift files..."
for file in "${MODIFIED_SWIFT_FILES[@]}"; do
  ABSOLUTE_PATH="${ROOT_DIR}/${file}"
  if [ -f "$ABSOLUTE_PATH" ]; then
    swift-format format \
      --configuration "${ROOT_DIR}/Scripts/swift-format/.swift-format.json" \
      --in-place \
      --ignore-unparsable-files \
      "$ABSOLUTE_PATH"
  else
    echo "File does not exist or is not readable: $ABSOLUTE_PATH"
  fi
done
