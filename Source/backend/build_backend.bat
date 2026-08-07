@echo off
setlocal EnableExtensions EnableDelayedExpansion
pushd "%~dp0"

set "MSYS_ROOT=C:\msys64"
set "UCRT_PACKAGES=mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-gcc-libs mingw-w64-ucrt-x86_64-binutils mingw-w64-ucrt-x86_64-crt mingw-w64-ucrt-x86_64-headers mingw-w64-ucrt-x86_64-gmp mingw-w64-ucrt-x86_64-mpfr mingw-w64-ucrt-x86_64-mpc mingw-w64-ucrt-x86_64-isl mingw-w64-ucrt-x86_64-libiconv mingw-w64-ucrt-x86_64-gettext-runtime mingw-w64-ucrt-x86_64-zlib mingw-w64-ucrt-x86_64-zstd mingw-w64-ucrt-x86_64-tzdata mingw-w64-ucrt-x86_64-windows-default-manifest mingw-w64-ucrt-x86_64-winpthreads mingw-w64-ucrt-x86_64-libwinpthread"
set "CXX="
set "OBJDUMP="
set "STRIP="
set "OUTPUT=backend.exe"
set "TEMP_OUTPUT=backend.build.exe"
set "SOURCE_DIR=nes_ace"
set "ENTRY_POINT=typescript_link.cpp"
set "STAGING_DIR=%~dp0..\packaging\backend"
set "BUILD_LOG=%TEMP%\nes_ace_backend_build_%RANDOM%_%RANDOM%.log"
set "IMPORT_LOG=%TEMP%\nes_ace_backend_imports_%RANDOM%_%RANDOM%.log"
set "BUILD_FAILURE="

call :find_toolchain
if errorlevel 1 goto :build_failed

echo.
echo Building %OUTPUT%...

del /q "%TEMP_OUTPUT%" >nul 2>&1

"%CXX%" ^
	-std=c++26 ^
	-O2 ^
	-g3 ^
	-Wall ^
	-Wextra ^
	-Wpedantic ^
	-Wconversion ^
	-Wsign-conversion ^
	-Warith-conversion ^
	-Wshadow ^
	-Wformat=2 ^
	-Wundef ^
	-Wcast-align=strict ^
	-Wcast-qual ^
	-Wold-style-cast ^
	-Woverloaded-virtual ^
	-Wnon-virtual-dtor ^
	-Wzero-as-null-pointer-constant ^
	-Wduplicated-cond ^
	-Wduplicated-branches ^
	-Wlogical-op ^
	-Wnull-dereference ^
	-Wdouble-promotion ^
	-Wuseless-cast ^
	-Wsuggest-override ^
	-Wswitch-enum ^
	-Wdangling-reference ^
	-Wdefaulted-function-deleted ^
	-Wno-error ^
	-I "%SOURCE_DIR%" ^
	-isystem "." ^
	"%ENTRY_POINT%" ^
	"%SOURCE_DIR%\nes_ace.assembler.cpp" ^
	"%SOURCE_DIR%\nes_ace.convert_tas.cpp" ^
	"%SOURCE_DIR%\nes_ace.database.cpp" ^
	"%SOURCE_DIR%\nes_ace.generate_ppu.cpp" ^
	"%SOURCE_DIR%\nes_ace.glossary.cpp" ^
	"%SOURCE_DIR%\nes_ace.tas_input.cpp" ^
	-o "%TEMP_OUTPUT%" ^
	-static-libgcc ^
	-static-libstdc++ ^
	-lstdc++exp ^
	> "%BUILD_LOG%" 2>&1

set "BUILD_RESULT=!errorlevel!"
if exist "%BUILD_LOG%" type "%BUILD_LOG%"
del /q "%BUILD_LOG%" >nul 2>&1

if not "!BUILD_RESULT!"=="0" (
	set "BUILD_FAILURE=the compiler returned exit code !BUILD_RESULT!"
	goto :build_failed
)

if defined STRIP (
	"%STRIP%" "%TEMP_OUTPUT%" >nul 2>&1
)

move /y "%TEMP_OUTPUT%" "%OUTPUT%" >nul 2>&1
if errorlevel 1 (
	set "BUILD_FAILURE=unable to replace %OUTPUT%; close any running NES ACE or backend process"
	goto :build_failed
)

"%OBJDUMP%" -p "%OUTPUT%" > "%IMPORT_LOG%" 2>&1
if errorlevel 1 (
	if exist "%IMPORT_LOG%" type "%IMPORT_LOG%"
	set "BUILD_FAILURE=objdump could not inspect %OUTPUT%"
	goto :build_failed
)

if exist "%STAGING_DIR%" rmdir /s /q "%STAGING_DIR%"
if exist "%STAGING_DIR%" (
	set "BUILD_FAILURE=unable to remove the previous package staging directory"
	goto :build_failed
)

mkdir "%STAGING_DIR%" >nul 2>&1
if errorlevel 1 (
	set "BUILD_FAILURE=unable to create the package staging directory"
	goto :build_failed
)

copy /y "%OUTPUT%" "%STAGING_DIR%\%OUTPUT%" >nul
if errorlevel 1 (
	set "BUILD_FAILURE=unable to copy %OUTPUT% into package staging"
	goto :build_failed
)

for %%D in (libstdc++-6.dll libgcc_s_seh-1.dll libwinpthread-1.dll libatomic-1.dll) do (
	findstr /I /C:"DLL Name: %%D" "%IMPORT_LOG%" >nul
	if not errorlevel 1 (
		call :stage_runtime "%%D"
		if errorlevel 1 goto :build_failed
	)
)

del /q "%IMPORT_LOG%" >nul 2>&1

echo.
echo Build succeeded: %CD%\%OUTPUT%
echo Package staging refreshed: %STAGING_DIR%
popd
endlocal
exit /b 0

:find_toolchain
set "PATH_CXX="
set "TOOLCHAIN_DIAGNOSTIC="

for %%I in (g++.exe) do set "PATH_CXX=%%~$PATH:I"
if defined PATH_CXX (
	call :try_toolchain "!PATH_CXX!"
	if not errorlevel 1 exit /b 0
)

if exist "%MSYS_ROOT%\ucrt64\bin\g++.exe" (
	call :try_toolchain "%MSYS_ROOT%\ucrt64\bin\g++.exe"
	if not errorlevel 1 exit /b 0
)

if exist "%LOCALAPPDATA%\Programs\MSYS2\ucrt64\bin\g++.exe" (
	call :try_toolchain "%LOCALAPPDATA%\Programs\MSYS2\ucrt64\bin\g++.exe"
	if not errorlevel 1 exit /b 0
)

if defined TOOLCHAIN_DIAGNOSTIC (
	set "BUILD_FAILURE=!TOOLCHAIN_DIAGNOSTIC!"
) else (
	set "BUILD_FAILURE=g++ was not found"
)

exit /b 1

:try_toolchain
set "CANDIDATE_CXX=%~1"
set "CANDIDATE_BIN="
set "NORMALIZED_CXX="
set "PRIMARY_CXX="
set "CXX_VERSION_FILE=%TEMP%\nes_ace_build_gcc_%RANDOM%_%RANDOM%.txt"

if not exist "%CANDIDATE_CXX%" exit /b 1

for %%I in ("%CANDIDATE_CXX%") do (
	set "NORMALIZED_CXX=%%~fI"
	set "CANDIDATE_BIN=%%~dpI"
)
for %%I in ("%MSYS_ROOT%\ucrt64\bin\g++.exe") do set "PRIMARY_CXX=%%~fI"

if /I "!NORMALIZED_CXX!"=="!PRIMARY_CXX!" (
	call :msys_toolchain_is_intact
	if errorlevel 1 (
		set "TOOLCHAIN_DIAGNOSTIC=the MSYS2 UCRT64 compiler contains missing or damaged files; run setup.bat from the repository root"
		exit /b 1
	)
)

"%CANDIDATE_CXX%" -dumpfullversion > "!CXX_VERSION_FILE!" 2>nul
if errorlevel 1 (
	del /q "!CXX_VERSION_FILE!" >nul 2>&1
	set "TOOLCHAIN_DIAGNOSTIC=GCC could not start; run setup.bat from the repository root to repair the toolchain"
	exit /b 1
)
del /q "!CXX_VERSION_FILE!" >nul 2>&1

if not exist "!CANDIDATE_BIN!objdump.exe" (
	set "TOOLCHAIN_DIAGNOSTIC=objdump was not found beside the selected GCC installation; run setup.bat from the repository root"
	exit /b 1
)

"!CANDIDATE_BIN!objdump.exe" --version >nul 2>&1
if errorlevel 1 (
	set "TOOLCHAIN_DIAGNOSTIC=objdump could not start; run setup.bat from the repository root to repair the toolchain"
	exit /b 1
)

set "CXX=%CANDIDATE_CXX%"
set "OBJDUMP=!CANDIDATE_BIN!objdump.exe"
set "STRIP="
if exist "!CANDIDATE_BIN!strip.exe" set "STRIP=!CANDIDATE_BIN!strip.exe"
set "PATH=!CANDIDATE_BIN!;%PATH%"
exit /b 0

:msys_toolchain_is_intact
if not exist "%MSYS_ROOT%\usr\bin\bash.exe" exit /b 1

"%MSYS_ROOT%\usr\bin\bash.exe" -lc ^
	"pacman -Qk %UCRT_PACKAGES% >/dev/null 2>&1"
exit /b %errorlevel%

:stage_runtime
set "RUNTIME_NAME=%~1"
set "RUNTIME_PATH="
set "TOOLCHAIN_BIN="

for %%P in ("%CXX%") do set "TOOLCHAIN_BIN=%%~dpP"

if exist "!TOOLCHAIN_BIN!!RUNTIME_NAME!" (
	set "RUNTIME_PATH=!TOOLCHAIN_BIN!!RUNTIME_NAME!"
) else (
	for /f "delims=" %%P in ('"!CXX!" -print-file-name^=!RUNTIME_NAME!') do set "RUNTIME_PATH=%%P"
)

if not defined RUNTIME_PATH (
	set "BUILD_FAILURE=required runtime !RUNTIME_NAME! was not found"
	exit /b 1
)

if /I "!RUNTIME_PATH!"=="!RUNTIME_NAME!" (
	set "BUILD_FAILURE=required runtime !RUNTIME_NAME! was not found"
	exit /b 1
)

if not exist "!RUNTIME_PATH!" (
	set "BUILD_FAILURE=required runtime !RUNTIME_NAME! was not found"
	exit /b 1
)

copy /y "!RUNTIME_PATH!" "%CD%\!RUNTIME_NAME!" >nul
if errorlevel 1 (
	set "BUILD_FAILURE=unable to copy runtime !RUNTIME_NAME! beside %OUTPUT%"
	exit /b 1
)

copy /y "!RUNTIME_PATH!" "!STAGING_DIR!\!RUNTIME_NAME!" >nul
if errorlevel 1 (
	set "BUILD_FAILURE=unable to stage runtime !RUNTIME_NAME!"
	exit /b 1
)

exit /b 0

:build_failed
del /q "%TEMP_OUTPUT%" >nul 2>&1
del /q "%BUILD_LOG%" >nul 2>&1
del /q "%IMPORT_LOG%" >nul 2>&1

echo.
if defined BUILD_FAILURE (
	echo Build failed: !BUILD_FAILURE!
) else (
	echo Build failed
)

popd
endlocal
exit /b 1
