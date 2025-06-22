#//-----------------------------------------------------------------------------
#//	DATACACHE.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(datacache_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "datacache_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)
include(vpc)

add_definitions(-DMDLCACHE_DLL_EXPORT)

if( LINUXALL )
    target_compile_options(${OUTBINNAME} PRIVATE -shared -fPIC)
endif()

# Add linker flags to handle multiply defined symbols on Windows
if(WIN32)
    target_link_options(${OUTBINNAME} PRIVATE 
        "/FORCE:MULTIPLE"  # Allow multiple symbol definitions
        # Alternative: Use /IGNORE:4006 to ignore specific warnings
        # "/IGNORE:4006"
    )
endif()

vpc_file(datacache_src 
    "datacache.cpp"
    "mdlcache.cpp"
    "mdlcombine.cpp"
    "vtfcombine.cpp"
    "resourceaccesscontrol.cpp"
    "precachesystem.cpp"
    "${SRCDIR}/public/studio.cpp"
    "${SRCDIR}/public/studio_virtualmodel.cpp"
    "${SRCDIR}/common/studiobyteswap.cpp"
    "${SRCDIR}/utils/common/datalinker.cpp"
)

target_sources(${OUTBINNAME} PRIVATE ${datacache_src})

target_link_libraries(${OUTBINNAME} 
    tier2_client 
    tier3_client 
    mathlib_client 
    libvstdlib_client
)