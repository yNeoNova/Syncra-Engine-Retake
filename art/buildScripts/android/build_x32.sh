bin/bash

echo "Building Syncra Engine for Android (x86 / 32-bit)..."

if [ ! -f "../../libs.json" ]; then
    echo "ERROR: libs.json not found in project root!"
    exit 1
fi

echo "Installing dependencies from libs.json..."

if ! command -v jq &> /dev/null; then
    echo "jq not found. Please install jq to parse JSON."
    exit 1
fi

cat ../../libs.json | jq -c '.dependencies[]' | while read -r dep; do
    NAME=$(echo $dep | jq -r '.name')
    TYPE=$(echo $dep | jq -r '.type')
    VERSION=$(echo $dep | jq -r '.version // empty')
    URL=$(echo $dep | jq -r '.url // empty')
    REF=$(echo $dep | jq -r '.ref // empty')

    if [ "$TYPE" == "haxelib" ]; then
        echo "Installing $NAME ($VERSION)..."
        haxelib install "$NAME" "$VERSION" --quiet
    elif [ "$TYPE" == "git" ]; then
        echo "Installing $NAME from $URL ($REF)..."
        haxelib git "$NAME" "$URL" "$REF" --quiet
    else
        echo "Unknown dependency type: $TYPE"
    fi
done

lime build android -32

echo "Android 32-bit build complete!"
