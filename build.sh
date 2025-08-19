cd "$(dirname "$0")"

OS=$1

# =============================================================================

git clone https://git.sr.ht/~lessa/absolute-unit
pushd absolute-unit
./build.sh || exit 1
popd

git clone https://git.sr.ht/~lessa/peppito
pushd peppito
git submodule set-url foundation https://git.sr.ht/~lessa/foundation
../absolute-unit/au --optimize || exit 1
popd

# =============================================================================

mkdir tools-$OS

cp absolute-unit/au tools-$OS
cp peppito/build/peppito tools-$OS

rm -f tools-$OS.zip
zip -9 -r tools-$OS.zip tools-$OS || echo "could not zip artifacts"
