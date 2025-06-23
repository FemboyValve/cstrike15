#//-----------------------------------------------------------------------------
#//	INPUTSYSTEM.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(inputsystem_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "inputsystem_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)
include(vpc)

add_definitions(-DNO_STRING_T -DVERSION_SAFE_STEAM_API_INTERFACES -DPROTECTED_THINGS_ENABLE)

if( LINUXALL )
    target_link_libraries(${OUTBINNAME} SDL2)
endif()

vpc_file(inputsystem_src
    "inputstacksystem.cpp"
    "inputsystem.cpp"
    "inputsystem.h"
    "joystick.cpp" NOT POSIX
    "joystick_osx.cpp" OSXALL
    "joystick_linux.cpp" LINUXALL
    "steamcontroller.cpp"
    "key_translation.cpp"
    "key_translation.h"
    "xcontroller.cpp" NOT POSIX
    "${SRCDIR}/common/platforminputdevice.cpp"
)

target_sources(${OUTBINNAME} PRIVATE ${inputsystem_src})

target_link_libraries(${OUTBINNAME} tier2_client mathlib_client)

if(WINDOWS)
    target_link_libraries(${OUTBINNAME} 
        ${LIBPUBLIC}/steam_api.lib
        winmm.lib      # For joystick functions
        libtier0_client   # Likely contains KeyValuesSystem
        libvstdlib_client # May also be needed
    )
endif()

if(POSIX)
    target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/libsteam_api.so)
elseif(WINDOWS)
    target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/steam_api.lib)
endif()