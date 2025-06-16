cmake_minimum_required(VERSION 3.20)
project(dedicated_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "dedicated_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)
include(vpc)

include_directories(${SRCDIR}/engine)
add_definitions(-DDEDICATED -DLAUNCHERONLY)

#linker
if( WINDOWS )
    target_link_libraries(${OUTBINNAME} wsock32.lib odbc32.lib odbccp32.lib winmm.lib)
endif()
if( OSXALL )
    #$SystemLibraries                     "iconv" [$OSXALL]
endif()

vpc_file(dedicated_src
    "dedicated.rc" WINDOWS
    "isys.h"
    "sys_linux.cpp" POSIX
    "filesystem.cpp"
    "${SRCDIR}/public/filesystem_init.cpp"
    "${SRCDIR}/common/netapi.cpp"
    "${SRCDIR}/common/SteamAppStartup.cpp"
    "sys_common.cpp"
    "sys_ded.cpp"
    "sys_subproc.cpp"
    "sys_windows.cpp"
    "console/conproc.cpp"
    "console/textconsole.cpp"
    "console/TextConsoleUnix.cpp" POSIX
    "console/TextConsoleWin32.cpp" WINDOWS
    "vgui/CreateMultiplayerGameServerPage.cpp" WINDOWS OR POSIX
    "vgui/MainPanel.cpp" WINDOWS OR POSIX 
    "${SRCDIR}/public/vgui_controls/vgui_controls.cpp" WINDOWS OR POSIX
    "vgui/vguihelpers.cpp" WINDOWS OR POSIX
    "${SRCDIR}/filesystem/filetracker.cpp"
    "${SRCDIR}/filesystem/basefilesystem.cpp"
    "${SRCDIR}/filesystem/basefilesystemasync.cpp"
    "${SRCDIR}/filesystem/filesystem_stdio.cpp"
    "${SRCDIR}/filesystem/filesystem_steam.cpp" NOT POSIX
    "${SRCDIR}/filesystem/filesystemasync.cpp"
    "${SRCDIR}/public/zip_utils.cpp"
    "${SRCDIR}/filesystem/linux_support.cpp" POSIX
)

target_sources(${OUTBINNAME} PRIVATE ${dedicated_src})

#SKIPPING - NEED THESE FIRST
#$Lib	appframework
#$Lib	dmxloader
#$ImplibExternal	steam_api							[ ( $WIN32 || $POSIX || $PS3 ) && !$NO_STEAM ]
#$ImplibExternal	steam_api64							[ $WIN64 && !$NO_STEAM ]
#$Lib	mathlib
#$Lib 	tier2
#$Lib	tier3
#$Lib 	vpklib
#$Lib	vgui_controls [$WINDOWS||$OSXALL]

if( (NOT DEFINED NO_STEAM) OR (${NO_STEAM})  )
    #grug
else()
    message(FATAL_ERROR "CMake steam_api integration is disabled.")
endif()

target_link_libraries(${OUTBINNAME} appframework_client dmxloader_client mathlib_client tier2_client tier3_client libvstdlib_client vpklib_client)

if( WINDOWS OR OSXALL )
    target_link_libraries(${OUTBINNAME} vgui_controls_client)
endif()