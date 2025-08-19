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

git clone https://git.sr.ht/~lessa/absolute-unit || exit /b 1
cd "absolute-unit"
call build.bat || exit /b 1
cd ..

git clone https://git.sr.ht/~lessa/peppito || exit /b 1
cd peppito
git submodule set-url foundation https://git.sr.ht/~lessa/foundation
git submodule update --init --recursive
../absolute-unit/au --optimize || exit /b 1
cd ..

rem ===========================================================================

mkdir tools-win

copy /y absolute-unit\au.exe tools-win
copy /y peppito\build\peppito.exe tools-win

if "%GITHUB_WORKFLOW%" neq "" (
	%SZIP% a -y -mx=9 tools-win.zip tools-win || exit /b 1
)
