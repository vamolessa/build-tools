OS=$1

# =============================================================================

rm -f tools
mkdir tools
pushd tools

git clone https://git.sr.ht/~lessa/absolute-unit
pushd absolute-unit
./build.sh || exit 1
popd

git clone https://git.sr.ht/~lessa/peppito
pushd peppito
git submodule set-url foundation https://git.sr.ht/~lessa/foundation
git submodule update --init --recursive
../absolute-unit/au -c clang --release || exit 1
popd

popd

# =============================================================================

mkdir tools-$OS

cp tools/absolute-unit/au tools-$OS
cp tools/peppito/build/peppito tools-$OS

rm -f tools-$OS.zip
zip -9 -r tools-$OS-$BUILD_DATE.zip tools-$OS || echo "could not zip artifacts"
