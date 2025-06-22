#//-----------------------------------------------------------------------------
#//	LAUNCHER.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(launcher_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "launcher_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

set(NOSTINKYLINKIES "1") #link this project carefully ourselves

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(vpc)
if( LINUXALL )
    # We run from the ./game dir, but want to look in the ./game/bin directory when loading libraries.
    # To dump rpath/runpath of a library, use "chrpath --list blah.so" or "objdump -x blah.so" or "readelf -d bin/launcher.so"
    #		$GCC_ExtraLinkerFlags		"-Wl,--enable-new-dtags -Wl,-z,origin -Wl,-rpath,'$$ORIGIN' -L/usr/lib32 -L/usr/lib" [$LINUXALL]
    #target_compile_options(${OUTBINNAME} PRIVATE "-Wl,--enable-new-dtags -Wl,-z,origin -Wl,-rpath,'$ORIGIN' -L/usr/lib32 -L/usr/lib")
    # This should be done before the target gets added.
    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    set(CMAKE_INSTALL_RPATH "$ORIGIN")
endif()
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

add_definitions(-DLAUNCHERONLY -DINCLUDE_SCALEFORM -DALLOW_TEXT_MODE=1)

# Add source files
vpc_file(launcher_src
"${SRCDIR}/public/filesystem_init.cpp"
"launcher.cpp"
"reslistgenerator.cpp"
)

target_sources(${OUTBINNAME} PRIVATE ${launcher_src})

# Link tier libraries - ORDER MATTERS! Link tier0 first, then tier1, etc.
target_link_libraries(${OUTBINNAME} 
    libtier0_client
    tier1_client 
    tier2_client 
    tier3_client 
    appframework_client 
    interfaces_client
    libvstdlib_client
    mathlib_client
)

# Platform-specific system libraries
if(WINDOWS)
    target_link_libraries(${OUTBINNAME} 
        shlwapi.lib 
        winmm.lib 
        wsock32.lib 
        odbc32.lib 
        odbccp32.lib
        ${SRCDIR}/dx9sdk/lib/dinput8.lib
    )
    # Link to proprietary steamapi
    target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/steam_api.lib)
elseif(POSIX)
    target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/libsteam_api.so) # Link to proprietary steamapi
endif()

if( LINUXALL )
    target_link_libraries(${OUTBINNAME} SDL2)
endif()

if( NOT IS_LIB_PROJECT AND GL )
    target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/libtogl_client.so) # Link to precompiled togl
endif()