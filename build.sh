OS=$1

if [ -z $OS ]; then
	OS=unix
fi

if [ -z $BUILD_DATE ]; then
	BUILD_DATE=latest
fi

# =============================================================================

rm -rf tools
mkdir tools
pushd tools

git clone https://git.sr.ht/~lessa/peppito
pushd peppito
git submodule set-url foundation https://git.sr.ht/~lessa/foundation
git submodule update --init --recursive
chmod a+x foundation/bootstrap.sh && foundation/bootstrap.sh || exit 1
chmod a+x tcl && ./tcl --release build.tcl || exit 1
popd

#git clone https://git.sr.ht/~lessa/lsp
#pushd lsp
#git submodule set-url foundation https://git.sr.ht/~lessa/foundation
#git submodule update --init --recursive
#chmod a+x build.sh
#./build.sh --release || exit 1
#popd

popd

echo "built all tools"

# =============================================================================

rm -rf tools-$OS
mkdir tools-$OS

cp tools/peppito/build/peppito tools-$OS || exit 1
#cp tools/lsp/build/lsp tools-$OS || exit 1

echo "created tools-$OS dir"

rm -f tools-$OS.zip
zip -9 -r tools-$OS-$BUILD_DATE.zip tools-$OS || exit 1
echo "created tools-$OS-$BUILD_DATE.zip"

# =============================================================================

echo "FINISHED!"
