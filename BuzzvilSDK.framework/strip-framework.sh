# Error itms-90035 - Xcode
# https://stackoverflow.com/questions/29788601/error-itms-90035-xcode
# script 시작부분에 bin/bash넣으면 애플에서 실행파일로 간주하고 signature error를 반환한다
# https://github.com/realm/realm-cocoa/issues/1865
# 이 파일에 실행 권한도 주면 안된다
set -ex

# Signs a framework with the provided identity
code_sign() {
# Use the current code_sign_identitiy
echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements $1"
/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements "$1"
}

# Set working directory to product’s embedded frameworks
cd "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"

if [ "$ACTION" = "install" ]; then
echo "Copy .bcsymbolmap files to .xcarchive"
find . -name '*.bcsymbolmap' -type f -exec mv {} "${CONFIGURATION_BUILD_DIR}" \;
else
# Delete *.bcsymbolmap files from framework bundle unless archiving
find . -name '*.bcsymbolmap' -type f -exec rm -rf "{}" +\;
fi

echo "Stripping frameworks"

for file in $(find . -type f -perm +111); do
# Skip non-dynamic libraries
if ! [[ "$(file "$file")" == *"dynamically linked shared library"* ]]; then
continue
fi
# Get architectures for current file
archs="$(lipo -info "${file}" | rev | cut -d ':' -f1 | rev)"
stripped=""
for arch in $archs; do
if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then

# Strip non-valid architectures in-place
lipo -remove "$arch" -output "$file" "$file" || exit 1
stripped="$stripped $arch"
fi
done

# 필요없을 것 같은데 우선 주석
# https://github.com/realm/realm-cocoa/issues/3706
#if [[ "$stripped" != "" ]]; then
#echo "Stripped $file of architectures:$stripped"
#if [ "${CODE_SIGNING_REQUIRED}" == "YES" ]; then
#code_sign "${file}"
#fi
#fi

done
