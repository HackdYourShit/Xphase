BUILD_COUNT=$({{counter}})

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_COUNT" "${INFOPLIST_FILE}"

