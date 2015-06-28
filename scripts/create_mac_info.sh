#!/bin/bash
function create_plist {
  local FILE="$1"
  local PLUGIN_NAME="$2"
  local VERSION="$3"
  local AUTHOR="$4"
  # Here document
  cat << EOF > $FILE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>$PLUGIN_NAME</string>
  <key>CFBundleDisplayName</key>
  <string>$PLUGIN_NAME</string>
  <key>CFBundleExecutable</key>
  <string>$PLUGIN_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>com.$AUTHOR.$PLUGIN_NAME</string>
  <key>CFBundleVersion</key>
  <string>$VERSION</string>
  <key>CFBundleShortVersionString</key>
  <string>$VERSION</string>
  <key>CFBundlePackageType</key>
  <string>BNDL</string>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleSignature</key>
  <string>????</string>
  <key>DTCompiler</key>
  <string>com.apple.compilers.llvm.clang.1_0</string>
  <key>NSHumanReadableCopyright</key>
  <string>$AUTHOR</string>
</dict>
</plist>
EOF
}

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 [plugin_name] [version (e.g. 1.0.3)] [author]"
  exit 1
else
  PLUGIN_NAME="$1"
  VERSION=$2
  AUTHOR="$3"
  CONTENTS_DIR="$PLUGIN_NAME.vst/Contents"
  INFO_FILE="$CONTENTS_DIR/Info.plist"
  if [ -d $CONTENTS_DIR ]; then
    create_plist $INFO_FILE $PLUGIN_NAME $VERSION $AUTHOR
  else
    echo "Error: Bundle missing Contents directory"
    exit 1
  fi
  exit 0
fi
