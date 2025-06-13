#!/bin/bash

echo "=== Building Android 64-bit APK ==="

# Install dependencies
echo "Installing Haxelib dependencies from libs.json..."

LIBS_JSON="libs.json"

if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq."
    exit 1
fi

jq -c '.dependencies[]' "$LIBS_JSON" | while read -r lib; do
    NAME=$(echo "$lib" | jq -r '.name')
    TYPE=$(echo "$lib" | jq -r '.type')
    VERSION=$(echo "$lib" | jq -r '.version')
    REF=$(echo "$lib" | jq -r '.ref // empty')
    URL=$(echo "$lib" | jq -r '.url // empty')

    if [ "$TYPE" == "haxelib" ]; then
        if [ "$VERSION" != "null" ] && [ "$VERSION" != "" ]; then
            haxelib install "$NAME" "$VERSION"
        else
            haxelib install "$NAME"
        fi
    elif [ "$TYPE" == "git" ]; then
        if [ "$URL" != "" ]; then
            if [ "$REF" != "" ]; then
                haxelib git "$NAME" "$URL" "$REF"
            else
                haxelib git "$NAME" "$URL"
            fi
        fi
    fi
done

# Build APK
lime build android -64

echo "=== Build complete! APK for 64-bit generated. ==="
