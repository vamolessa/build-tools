@echo off
setlocal enabledelayedexpansion

cd %~dp0

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

call git clone https://git.sr.ht/~lessa/absolute-unit au || exit /b 1
cd au
call build.bat || exit /b 1
cd ..

call git clone https://git.sr.ht/~lessa/peppito || exit /b 1
cd peppito
git submodule set-url foundation https://git.sr.ht/~lessa/foundation
git submodule update --init --recursive
..\au\au --optimize || exit /b 1
cd ..

rem ===========================================================================

mkdir tools-win

copy /y au\au.exe tools-win
copy /y peppito\build\peppito.exe tools-win

if "%GITHUB_WORKFLOW%" neq "" (
	%SZIP% a -y -mx=9 tools-win.zip tools-win || exit /b 1
)
