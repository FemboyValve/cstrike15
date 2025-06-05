cmake_minimum_required(VERSION 3.20)
project(appframework)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")
include(vpc)

set(SRCDIR "${CMAKE_CURRENT_SOURCE_DIR}/..")

# Source files
vpc_file(SOURCE_FILES
    "AppSystemGroup.cpp"
    "${SRCDIR}/public/filesystem_init.cpp"
    "VguiMatSysApp.cpp" WIN32
    "matsysapp.cpp" WIN32
    "WinApp.cpp" WIN32
    "posixapp.cpp" UNIX AND NOT APPLE
    "sdlmgr.cpp" SDL
    "cocoamgr.mm" APPLE AND NOT SDL
    "glmrendererinfo_osx.mm" APPLE AND SDL
)

# Header files
set(HEADER_FILES
    "${SRCDIR}/public/appframework/AppFramework.h"
    "${SRCDIR}/public/appframework/iappsystem.h"
    "${SRCDIR}/public/appframework/IAppSystemGroup.h"
    "${SRCDIR}/public/appframework/tier2app.h"
    "${SRCDIR}/public/appframework/tier3app.h"
    "${SRCDIR}/public/appframework/matsysapp.h"
    "${SRCDIR}/public/appframework/VguiMatSysApp.h"
    "${SRCDIR}/public/appframework/ilaunchermgr.h"
)

add_library(appframework STATIC ${SOURCE_FILES} ${HEADER_FILES})

# Definitions
if((WIN32 AND GL) OR UNIX)
    target_compile_definitions(appframework PRIVATE VERSION_SAFE_STEAM_API_INTERFACES)
endif()

if(CSTRIKE_TRUNK_BUILD OR CSTRIKE_STAGING_BUILD)
    target_compile_definitions(appframework PRIVATE ALLOW_TEXT_MODE=1)
endif()

# macOS frameworks
if(APPLE AND NOT IS_LIB_PROJECT)
    target_link_options(appframework PRIVATE
        "-framework" "Carbon"
        "-framework" "OpenGL"
        "-framework" "Quartz"
        "-framework" "Cocoa"
        "-framework" "IOKit"
    )
endif()

# Link libraries
if(GL AND NOT IS_LIB_PROJECT)
    target_link_libraries(appframework PRIVATE togl)
endif()

if(SDL AND NOT IS_LIB_PROJECT)
    target_link_libraries(appframework PRIVATE SDL2)
endif()