OS=$1

# =============================================================================

rm -f tools
mkdir tools
pushd tools

git clone https://git.sr.ht/~lessa/peppito
pushd peppito
git submodule set-url foundation https://git.sr.ht/~lessa/foundation
git submodule set-url absolute-unit https://git.sr.ht/~lessa/absolute-unit
git submodule update --init --recursive
./build.sh -c clang --release || exit 1
popd

popd

# =============================================================================

mkdir tools-$OS

cp tools/peppito/build/peppito tools-$OS

rm -f tools-$OS.zip
zip -9 -r tools-$OS-$BUILD_DATE.zip tools-$OS || echo "could not zip artifacts"
