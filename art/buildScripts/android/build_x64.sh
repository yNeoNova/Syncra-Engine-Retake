#!/bin/bash

echo "=== Building Android 64-bit APK ==="

# Install dependencies (same as you have now)

# Build APK
lime build android -64

# Define output path
OUTPUT_DIR="/docs/builds"
mkdir -p "$OUTPUT_DIR"

# Find the APK and move it to OUTPUT_DIR
APK_PATH=$(find export/ -type f -name "*.apk" | head -n 1)

if [ -f "$APK_PATH" ]; then
    cp "$APK_PATH" "$OUTPUT_DIR/SyncraEngine-x64.apk"
    echo "APK copied to $OUTPUT_DIR/SyncraEngine-x64.apk"
else
    echo "No APK generated."
fi

echo "=== Build complete! APK for 64-bit generated. ==="
