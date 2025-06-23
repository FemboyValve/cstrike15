#//-----------------------------------------------------------------------------
#//	VALVE_AVI.VPC
#//
#//	Project Script
#//
#// MGP 4/010 Updated to support Quicktime on OSX.  Win32 builds can optionally
#//   be enabled for cross platform work if quickTime is installed on the Win32
#//   PC.
#//-----------------------------------------------------------------------------

#TODO: Not Done. Moving to the tier libraries first and following the build-order -lwss

cmake_minimum_required(VERSION 3.16)
project(valve_avi_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(OUTBINNAME "valve_avi_client")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINDIR "${SRCDIR}/../game/bin")

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

if( QUICKTIME_WINDOWS )
    #$AdditionalIncludeDirectories	"$BASE,..\common\quicktime_win32\"		[$QUICKTIME_WINDOWS]
endif()
if(WINDOWS)
    target_include_directories(${OUTBINNAME} PRIVATE 
        ${SRCDIR}/dx9sdk/include
    )
endif()

#Compiler
if( LINUXALL )
    #these dont exist, might need FIXME
    include_directories(${SRCDIR}/thirdparty/sdl/include)
    include_directories(${SRCDIR}/thirdparty/sdl_mixer)
endif()


#linker
if( LINUXALL )
    #target_link_options(${OUTBINNAME} PRIVATE "-z muldefs -L${SRCDIR}/thirdparty/sdl/build/.libs")
    target_link_libraries(${OUTBINNAME} SDL2)
endif()

#source files
vpc_file(valveavi_src
    "avi.cpp" WINDOWS
    "avi_osx.cpp" OSXALL
    "bink.cpp" NOT OSXALL
    "quicktime.cpp" QUICKTIME_VIDEO OR QUICKTIME_WINDOWS

    "avi.h"
    "quicktime.h"
    "../public/avi/iavi.h"
    "../public/pixelwriter.h"

    "../public/avi/iavi.h"
	"../public/avi/ibik.h"
	"../public/avi/iquicktime.h"
)

target_sources(${OUTBINNAME} PRIVATE ${valveavi_src})

if( WINDOWS)
    target_link_libraries(${OUTBINNAME} 
    libvstdlib_client
    libtier0_client
    tier2_client 
    tier3_client
    avifil32
    vfw32
    winmm
    )

    # do we have to link against sdl and sdl_mixer libs?
    # yes but only if we use quicktime instead.
endif()

if( X360 OR POSIX )
    target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/tier2_client.a ${LIBPUBLIC}/tier3_client.a)
    if( LINUXALL )
        target_link_libraries(${OUTBINNAME} ${SRCDIR}/lib/common/libSDL2_mixer.a)
    endif()
endif()