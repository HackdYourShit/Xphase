BUILD_COUNT=$({{counter}})

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_COUNT" "${PROJECT_DIR}/${INFOPLIST_FILE}"

