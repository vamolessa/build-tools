@echo off
setlocal enabledelayedexpansion

if not defined BUILD_DATE (set BUILD_DATE=latest)

where /q git.exe || (
	echo ERROR: "git.exe" not found
	exit /b 1
)

if not defined SZIP ( where /q 7z.exe && (set SZIP=7z.exe) )
if not defined SZIP ( if exist "%ProgramFiles%\7-Zip\7z.exe" (set SZIP="%ProgramFiles%\7-Zip\7z.exe") )
if not defined SZIP ( where /q 7za.exe && (set SZIP=7za.exe) )
if not defined SZIP (
	echo ERROR: 7-Zip installation or "7za.exe" not found
	exit /b 1
)

rem ===========================================================================

rmdir /s /q tools 2>nul
mkdir tools
pushd tools

git clone https://git.sr.ht/~lessa/copycat
echo AFTER CLONE
pushd copycat
echo AFTER PUSHD
call build.bat || exit /b 1
echo AFTER COPYCAT BUILD.BAT
popd

echo BEFORE PEPPITO

call git clone https://git.sr.ht/~lessa/peppito
pushd peppito
call git submodule set-url foundation https://git.sr.ht/~lessa/foundation
call git submodule set-url absolute-unit https://git.sr.ht/~lessa/absolute-unit
call git submodule update --init --recursive
call build -c clang --release || exit /b 1
popd

popd

rem ===========================================================================

mkdir tools-win

copy /y tools\copycat\build\copycat.exe tools-win
copy /y tools\peppito\build\peppito.exe tools-win

%SZIP% a -y -mx=9 tools-win-%BUILD_DATE%.zip tools-win || exit /b 1

rem ===========================================================================

echo FINISHED!
