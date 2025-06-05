@echo off
echo Generating build files using Visual Studio 2015 (32-bit)...
cmake -G "Visual Studio 14 2015" -A Win32 -B build
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] CMake generation failed.
    pause
    exit /b %errorlevel%
)

echo.
echo [SUCCESS] CMake project files generated in the "build" directory.

pause
