#//-----------------------------------------------------------------------------
#//	VGUI_DLL.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(vgui2_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "vgui2_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)
include(vpc)

if( LINUXALL )
    include_directories(/usr/include/freetype2)
endif()
include_directories(${SRCDIR}/thirdparty)
#$PreprocessorDefinitions		"$BASE;DONT_PROTECT_FILEIO_FUNCTIONS"

if( LINUXALL )
    target_link_libraries(${OUTBINNAME} SDL2)
endif()

vpc_file(vgui2_src
    "Bitmap.cpp"
    "Border.cpp"
    "ScalableImageBorder.cpp"
    "ImageBorder.cpp"
    "fileimage.cpp"
    "${SRCDIR}/public/filesystem_helpers.cpp"
    "${SRCDIR}/public/filesystem_init.cpp"
    "htmlwindow.cpp" WINDOWS
    "InputWin32.cpp" WINDOWS OR X360 OR PS3 OR LINUXALL
    "inputosx.cpp" OSXALL
    "MemoryBitmap.cpp"
    "Memorybitmap.h"
    "MessageListener.cpp"
    "Scheme.cpp"
    "Surface.cpp" WINDOWS
    "System.cpp" WINDOWS OR X360 OR PS3
    "system_posix.cpp" POSIX
    "${SRCDIR}/public/UnicodeFileHelpers.cpp"
    "vgui.cpp"
    "vgui_internal.cpp"
    "vgui_key_translation.cpp"
    "VPanel.cpp"
    "VPanelWrapper.cpp"
    "keyrepeat.cpp"
)

target_sources(${OUTBINNAME} PRIVATE ${vgui2_src})

target_link_libraries(${OUTBINNAME} vgui_surfacelib_client tier2_client tier3_client libvstdlib_client)

if(WIN32)
    target_link_libraries(${OUTBINNAME} imm32)
endif()
