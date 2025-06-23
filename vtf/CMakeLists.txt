#//-----------------------------------------------------------------------------
#//	VTF.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(vtf_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTLIBNAME "vtf_client")

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_lib_base.cmake)
include(vpc)

vpc_file(vtf_src
    "convert_x360.cpp" 
    "s3tc_decode.cpp" WINDOWS
    "vtf.cpp"
    "vtf_x360.cpp" X360
    "vtf_ps3.cpp" PS3

    "s3tc_decode.h"
    "../public/vtf/vtf.h"

    "cvtf.h"
)

target_sources(${OUTLIBNAME} PRIVATE ${vtf_src})

if(WINDOWS)
    target_include_directories(${OUTLIBNAME} PRIVATE "${CMAKE_SOURCE_DIR}/dx9sdk/include")
    target_compile_definitions(${OUTLIBNAME} PRIVATE "fopen=dont_use_fopen")
endif()

if( LINUXALL )
    target_compile_options(${OUTLIBNAME} PRIVATE -fPIC)
endif()

if( WINDOWS )
    #	$Folder "Link Libraries" [$X360]
    #	{
    #		$File	"$SRCDIR\lib\public\bitmap_360.lib"
    #		$File	"$SRCDIR\lib\public\mathlib_360.lib"
    #		$File	"$SRCDIR\lib\public\tier2_360.lib"
    #	}
endif()