@echo off
setlocal enabledelayedexpansion

if not defined BUILD_DATE set BUILD_DATE=latest

where /q git.exe || (
	echo ERROR: "git.exe" not found
	exit /b 1
)

rem ===========================================================================

rmdir /s /q tools 2>nul
mkdir tools
pushd tools

git clone https://git.sr.ht/~lessa/copycat
pushd copycat
call build.bat || exit /b 1
popd

call git clone https://git.sr.ht/~lessa/peppito
pushd peppito
call git submodule set-url foundation https://git.sr.ht/~lessa/foundation
call git submodule update --init --recursive
call tcl.bat --release build.tcl || exit /b 1
popd

rem call git clone https://git.sr.ht/~lessa/lsp
rem pushd lsp
rem call git submodule set-url foundation https://git.sr.ht/~lessa/foundation
rem call git submodule update --init --recursive
rem call build.bat --release || exit /b 1
rem popd

popd

echo built all tools

rem ===========================================================================

rmdir /s /q tools-win 2>nul
mkdir tools-win

copy /y tools\copycat\build\copycat.exe tools-win || exit /b 1
copy /y tools\peppito\build\peppito.exe tools-win || exit /b 1
rem copy /y tools\lsp\build\lsp.exe tools-win || exit /b 1

echo created tools-win dir

tar.exe -cavf tools-win-%BUILD_DATE%.zip tools-win || exit /b 1
echo created tools-win-%BUILD_DATE%.zip

rem ===========================================================================

where /q install_bin && (
	pushd tools-win
	for %%f in (*) do call install_bin %%f
	popd
	echo tools installed!
) || echo install_bin not found: skipping install step

rem reset errorlevel
call (exit /b 0)

rem ===========================================================================

echo FINISHED!
