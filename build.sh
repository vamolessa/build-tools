OS=$1

# =============================================================================

git clone https://git.sr.ht/~lessa/absolute-unit
cd absolute-unit
./build.sh || exit 1
cd ..

git clone https://git.sr.ht/~lessa/peppito
cd peppito
git submodule set-url foundation https://git.sr.ht/~lessa/foundation
git submodule update --init --recursive
../absolute-unit/au -c clang --optimize || exit 1
cd ..

# =============================================================================

mkdir tools-$OS

cp absolute-unit/au tools-$OS
cp peppito/build/peppito tools-$OS

rm -f tools-$OS.zip
zip -9 -r tools-$OS-$BUILD_DATE.zip tools-$OS || echo "could not zip artifacts"
