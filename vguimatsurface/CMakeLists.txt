#//-----------------------------------------------------------------------------
#//	VGUIMATSURFACE.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(vguimatsurface_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "vguimatsurface_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

set(NOSTINKYLINKIES "1") #this project requires precise linking

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

include_directories(../public/mathlib)

if( LINUXALL )
    include_directories(/usr/include/freetype2)
endif()
add_definitions(-DBENCHMARK -DVGUIMATSURFACE_DLL_EXPORT -DGAMEUI_EXPORTS -DDONT_PROTECT_FILEIO_FUNCTIONS -DPROTECTED_THINGS_ENABLE)
add_definitions(-DENABLE_CHROMEHTMLWINDOW)

# Fix for memory function redefinition on Windows
if( WIN32 )
    target_link_options(${OUTBINNAME} PRIVATE 
        "/FORCE:MULTIPLE"
        "/IGNORE:4006"
        "/IGNORE:4221"
    )
endif()

if( LINUXALL )
    target_link_options(${OUTBINNAME} PRIVATE "-L/usr/lib32 -L/usr/lib -L/usr/lib/i386-linux-gnu")
    target_link_libraries(${OUTBINNAME} fontconfig freetype SDL2)
endif()

vpc_file(vguimatsurface_src
    "Clip2D.cpp"
    "Cursor.cpp"
    "../public/filesystem_helpers.cpp"
    "Input.cpp"
    "MatSystemSurface.cpp"
    "../mathlib/halton.cpp"
    "memorybitmap.cpp" WINDOWS
    "../vgui2/src/htmlwindow.cpp" WINDOWS
    "../vgui2/src/vgui_key_translation.cpp"
    "../public/vgui_controls/vgui_controls.cpp"
)

target_sources(${OUTBINNAME} PRIVATE ${vguimatsurface_src})

if( LINUXALL )
    target_link_libraries(${OUTBINNAME} fontconfig freetype SDL2)
endif()

target_link_libraries(${OUTBINNAME} 
    vgui_controls_client 
    vgui_surfacelib_client 
    dmxloader_client 
    libtier0_client 
    tier2_client 
    tier3_client 
    mathlib_client 
    bitmap_client 
    libvstdlib_client
)