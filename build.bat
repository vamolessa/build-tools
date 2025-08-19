@echo off
setlocal enabledelayedexpansion

where /q git.exe || (
	echo ERROR: "git.exe" not found
	exit /b 1
)

if exist "%ProgramFiles%\7-Zip\7z.exe" (
	set SZIP="%ProgramFiles%\7-Zip\7z.exe"
) else (
	where /q 7za.exe || (
		echo ERROR: 7-Zip installation or "7za.exe" not found
		exit /b 1
	)
	set SZIP=7za.exe
)

rem ===========================================================================

call git clone https://git.sr.ht/~lessa/absolute-unit
pushd absolute-unit
clang au.c -o au.exe
popd

git clone https://git.sr.ht/~lessa/copycat
pushd copycat
clang -o copycat.exe -I vendor -luser32 -lgdi32 main.c
popd

call git clone https://git.sr.ht/~lessa/peppito
pushd peppito
call git submodule set-url foundation https://git.sr.ht/~lessa/foundation
call git submodule update --init --recursive
..\absolute-unit\au -c clang --release || exit /b 1
popd

rem ===========================================================================

mkdir tools-win

copy /y absolute-unit\au.exe tools-win
copy /y copycat\copycat.exe tools-win
copy /y peppito\build\peppito.exe tools-win

if "%GITHUB_WORKFLOW%" neq "" (
	%SZIP% a -y -mx=9 tools-win-%BUILD_DATE%.zip tools-win || exit /b 1
)
