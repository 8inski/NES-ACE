@echo off
setlocal EnableExtensions EnableDelayedExpansion
pushd "%~dp0"

rem ============================================================================
rem NES ACE First-Time Setup
rem ============================================================================

set "MIN_NODE_MAJOR=22"
set "MIN_NODE_MINOR=12"
set "MIN_GCC_VERSION=16.1"
set "MSYS_ROOT=C:\msys64"
set "ORIGINAL_PATH=%PATH%"
set "UCRT_PACKAGES=mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-gcc-libs mingw-w64-ucrt-x86_64-binutils mingw-w64-ucrt-x86_64-crt mingw-w64-ucrt-x86_64-headers mingw-w64-ucrt-x86_64-gmp mingw-w64-ucrt-x86_64-mpfr mingw-w64-ucrt-x86_64-mpc mingw-w64-ucrt-x86_64-isl mingw-w64-ucrt-x86_64-libiconv mingw-w64-ucrt-x86_64-gettext-runtime mingw-w64-ucrt-x86_64-zlib mingw-w64-ucrt-x86_64-zstd mingw-w64-ucrt-x86_64-tzdata mingw-w64-ucrt-x86_64-windows-default-manifest mingw-w64-ucrt-x86_64-winpthreads mingw-w64-ucrt-x86_64-libwinpthread"

call :print_header
call :check_platform
if errorlevel 1 goto :setup_failed

call :refresh_path
call :ensure_node
if errorlevel 1 goto :setup_failed

call :ensure_gcc
if errorlevel 1 goto :setup_failed

call :refresh_path

where npm.cmd >nul 2>&1
if errorlevel 1 (
    echo.
    echo Setup failed: npm was not found after installing Node.js
    goto :setup_failed
)

echo.
echo Installing Exact JavaScript Dependencies From Source\package-lock.json...
pushd "Source"
call npm.cmd ci
if errorlevel 1 (
    popd
    echo.
    echo Setup failed: npm ci returned an error
    goto :setup_failed
)

popd

echo.
echo ============================================================================
echo Setup Complete
echo ============================================================================
echo.
echo NES ACE is ready to run
echo.
echo Next command:
echo.
echo     npm start
echo.

set "FINAL_PATH=%PATH%"
popd
endlocal & set "PATH=%FINAL_PATH%" & cd /d "%~dp0Source"
exit /b 0

:print_header
echo.
echo ============================================================================
echo NES ACE Setup
echo ============================================================================
echo.
echo This script checks the required development tools, installs or repairs
echo missing tools, and installs the JavaScript dependencies used by the project
echo.
exit /b 0

:check_platform
if /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" exit /b 0
if /I "%PROCESSOR_ARCHITEW6432%"=="AMD64" exit /b 0

echo Setup failed: NES ACE requires 64-bit Windows 10 or Windows 11
exit /b 1

:ensure_winget
where winget.exe >nul 2>&1
if not errorlevel 1 exit /b 0

echo.
echo WinGet was not immediately available
echo Attempting to register the built-in Windows App Installer package...

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" ^
    >nul 2>&1

timeout /t 3 /nobreak >nul
call :refresh_path

where winget.exe >nul 2>&1
if not errorlevel 1 exit /b 0

echo.
echo Setup cannot continue because WinGet is unavailable
echo.
echo WinGet is included with App Installer on current Windows 10 and Windows 11
echo Install or update App Installer from the Microsoft Store, then run setup.bat again
echo.
echo Opening the official App Installer page...
start "" "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
exit /b 1

:ensure_node
call :node_is_supported
if not errorlevel 1 (
    for /f "delims=" %%V in ('node.exe --version') do set "NODE_VERSION=%%V"
    echo Node.js !NODE_VERSION! found
    exit /b 0
)

echo.
echo Node.js %MIN_NODE_MAJOR%.%MIN_NODE_MINOR% or newer was not found
call :ensure_winget
if errorlevel 1 exit /b 1

echo Installing the current Node.js LTS release through WinGet...
winget.exe install ^
    --id OpenJS.NodeJS.LTS ^
    --exact ^
    --source winget ^
    --architecture x64 ^
    --silent ^
    --accept-package-agreements ^
    --accept-source-agreements

call :refresh_path
call :node_is_supported
if not errorlevel 1 goto :node_ready

echo Attempting to upgrade an existing Node.js LTS installation...
winget.exe upgrade ^
    --id OpenJS.NodeJS.LTS ^
    --exact ^
    --source winget ^
    --architecture x64 ^
    --silent ^
    --accept-package-agreements ^
    --accept-source-agreements

call :refresh_path
call :node_is_supported
if errorlevel 1 (
    echo.
    echo Setup failed: Node.js %MIN_NODE_MAJOR%.%MIN_NODE_MINOR% or newer is still unavailable
    exit /b 1
)

:node_ready
for /f "delims=" %%V in ('node.exe --version') do set "NODE_VERSION=%%V"
echo Node.js !NODE_VERSION! ready
exit /b 0

:node_is_supported
where node.exe >nul 2>&1
if errorlevel 1 exit /b 1

where npm.cmd >nul 2>&1
if errorlevel 1 exit /b 1

node.exe -e "const [major, minor] = process.versions.node.split('.').map(Number); process.exit(major > %MIN_NODE_MAJOR% || (major === %MIN_NODE_MAJOR% && minor >= %MIN_NODE_MINOR%) ? 0 : 1)" >nul 2>&1
exit /b %errorlevel%

:ensure_gcc
call :find_supported_gcc
if not errorlevel 1 (
    echo GCC !GCC_VERSION! found at !GCC_PATH!
    exit /b 0
)

echo.
echo A complete MinGW-w64 GCC %MIN_GCC_VERSION% or newer toolchain was not found
echo Installing or repairing the MSYS2 UCRT64 toolchain...
call :ensure_winget
if errorlevel 1 exit /b 1

if not exist "%MSYS_ROOT%\usr\bin\bash.exe" (
    echo Installing MSYS2 through WinGet...
    winget.exe install ^
        --id MSYS2.MSYS2 ^
        --exact ^
        --source winget ^
        --architecture x64 ^
        --silent ^
        --location "%MSYS_ROOT%" ^
        --accept-package-agreements ^
        --accept-source-agreements

    if errorlevel 1 (
        echo.
        echo Setup failed: WinGet could not install MSYS2
        exit /b 1
    )
)

if not exist "%MSYS_ROOT%\usr\bin\bash.exe" (
    echo.
    echo Setup failed: MSYS2 was not found at %MSYS_ROOT% after installation
    exit /b 1
)

echo Updating the MSYS2 package database and base system...
"%MSYS_ROOT%\usr\bin\bash.exe" -lc "pacman -Syuu --noconfirm"

rem A Second Pass Completes Updates That Replace the MSYS2 Runtime
"%MSYS_ROOT%\usr\bin\bash.exe" -lc "pacman -Syuu --noconfirm"
if errorlevel 1 (
    echo.
    echo Setup failed: MSYS2 could not complete its system update
    exit /b 1
)

echo Reinstalling the UCRT64 compiler and its required packages...
"%MSYS_ROOT%\usr\bin\bash.exe" -lc ^
    "pacman -S --noconfirm %UCRT_PACKAGES%"
if errorlevel 1 (
    echo.
    echo Setup failed: MSYS2 could not install or repair the UCRT64 compiler toolchain
    exit /b 1
)

call :refresh_path
call :find_supported_gcc
if errorlevel 1 (
    echo.
    echo Setup failed: GCC %MIN_GCC_VERSION% or newer could not compile and run the C++26 test program
    echo The MSYS2 toolchain may still contain missing or damaged files
    exit /b 1
)

echo GCC !GCC_VERSION! ready at !GCC_PATH!
exit /b 0

:find_supported_gcc
set "GCC_PATH="
set "GCC_VERSION="
set "PATH_GCC="

if exist "%MSYS_ROOT%\ucrt64\bin\g++.exe" (
    call :test_gcc "%MSYS_ROOT%\ucrt64\bin\g++.exe"
    if not errorlevel 1 exit /b 0
)

if exist "%LOCALAPPDATA%\Programs\MSYS2\ucrt64\bin\g++.exe" (
    call :test_gcc "%LOCALAPPDATA%\Programs\MSYS2\ucrt64\bin\g++.exe"
    if not errorlevel 1 exit /b 0
)

for %%I in (g++.exe) do set "PATH_GCC=%%~$PATH:I"
if defined PATH_GCC (
    call :test_gcc "!PATH_GCC!"
    if not errorlevel 1 exit /b 0
)

exit /b 1

:test_gcc
set "GCC_CANDIDATE=%~1"
set "CANDIDATE_VERSION="
set "GCC_VERSION_FILE=%TEMP%\nes_ace_gcc_version_%RANDOM%_%RANDOM%.txt"
set "GCC_BIN="
set "PRIMARY_GCC="
set "NORMALIZED_GCC="

for %%I in ("%GCC_CANDIDATE%") do (
    set "NORMALIZED_GCC=%%~fI"
    set "GCC_BIN=%%~dpI"
)
for %%I in ("%MSYS_ROOT%\ucrt64\bin\g++.exe") do set "PRIMARY_GCC=%%~fI"

if /I "%NORMALIZED_GCC%"=="%PRIMARY_GCC%" (
    call :msys_toolchain_is_intact
    if errorlevel 1 exit /b 1
)

set "PATH=%GCC_BIN%;%PATH%"

"%GCC_CANDIDATE%" -dumpfullversion > "%GCC_VERSION_FILE%" 2>nul
if errorlevel 1 (
    del "%GCC_VERSION_FILE%" >nul 2>&1
    exit /b 1
)

set /p "CANDIDATE_VERSION="<"%GCC_VERSION_FILE%"
del "%GCC_VERSION_FILE%" >nul 2>&1

if not defined CANDIDATE_VERSION exit /b 1

powershell.exe -NoProfile -Command ^
    "try { if ([version]'%CANDIDATE_VERSION%' -ge [version]'%MIN_GCC_VERSION%') { exit 0 } } catch {}; exit 1" ^
    >nul 2>&1
if errorlevel 1 exit /b 1

if not exist "%GCC_BIN%objdump.exe" (
    where objdump.exe >nul 2>&1
    if errorlevel 1 exit /b 1
)

call :gcc_smoke_test "%GCC_CANDIDATE%"
if errorlevel 1 exit /b 1

set "GCC_PATH=%GCC_CANDIDATE%"
set "GCC_VERSION=%CANDIDATE_VERSION%"
exit /b 0

:msys_toolchain_is_intact
if not exist "%MSYS_ROOT%\usr\bin\bash.exe" exit /b 1

"%MSYS_ROOT%\usr\bin\bash.exe" -lc ^
    "pacman -Qk %UCRT_PACKAGES% >/dev/null 2>&1"
exit /b %errorlevel%

:gcc_smoke_test
setlocal EnableDelayedExpansion

set "SMOKE_CXX=%~1"
set "SMOKE_DIR=%TEMP%\nes_ace_gcc_smoke_%RANDOM%_%RANDOM%"
set "SMOKE_SOURCE=!SMOKE_DIR!\smoke.cpp"
set "SMOKE_OUTPUT=!SMOKE_DIR!\smoke.exe"
set "SMOKE_LOG=!SMOKE_DIR!\build.log"

mkdir "!SMOKE_DIR!" >nul 2>&1
if errorlevel 1 (
    endlocal
    exit /b 1
)

> "!SMOKE_SOURCE!" (
    echo #include ^<inplace_vector^>
    echo #include ^<print^>
    echo int main^(^) {
    echo     std::inplace_vector^<int, 1^> values;
    echo     values.push_back^(1^);
    echo     std::println^("{}", values.front^(^)^);
    echo     return 0;
    echo }
)

"!SMOKE_CXX!" ^
    -std=c++26 ^
    "!SMOKE_SOURCE!" ^
    -o "!SMOKE_OUTPUT!" ^
    -static-libgcc ^
    -static-libstdc++ ^
    -lstdc++exp ^
    > "!SMOKE_LOG!" 2>&1

set "SMOKE_RESULT=!errorlevel!"

if "!SMOKE_RESULT!"=="0" (
    "!SMOKE_OUTPUT!" >nul 2>&1
    set "SMOKE_RESULT=!errorlevel!"
)

if not "!SMOKE_RESULT!"=="0" (
    echo.
    echo GCC C++26 smoke test failed
    if exist "!SMOKE_LOG!" type "!SMOKE_LOG!"
    rmdir /s /q "!SMOKE_DIR!" >nul 2>&1
    endlocal
    exit /b 1
)

rmdir /s /q "!SMOKE_DIR!" >nul 2>&1
endlocal
exit /b 0

:refresh_path
set "MACHINE_PATH="
set "USER_PATH="

for /f "usebackq delims=" %%P in (`powershell.exe -NoProfile -Command "[Environment]::GetEnvironmentVariable('Path', 'Machine')"`) do set "MACHINE_PATH=%%P"
for /f "usebackq delims=" %%P in (`powershell.exe -NoProfile -Command "[Environment]::GetEnvironmentVariable('Path', 'User')"`) do set "USER_PATH=%%P"

set "PATH=%MSYS_ROOT%\ucrt64\bin;C:\Program Files\nodejs;%MACHINE_PATH%;%USER_PATH%;%ORIGINAL_PATH%"
exit /b 0

:setup_failed
echo.
echo ============================================================================
echo Setup Failed
echo ============================================================================
echo.
echo Resolve the error shown above, then run setup.bat again
echo.
popd
endlocal
exit /b 1
