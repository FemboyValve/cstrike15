#//-----------------------------------------------------------------------------
#//	BITMAP.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(bitmap_byteswap)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
include(${CMAKE_MODULE_PATH}/detect_platform.cmake)

#build byteswap_client
set(OUTLIBNAME "bitmap_byteswap_client")

include(${CMAKE_MODULE_PATH}/source_lib_base.cmake)
include(vpc)

target_sources(${OUTLIBNAME} PRIVATE ImageByteSwap.cpp)

#build bitmap_client
set(OUTLIBNAME "bitmap_byteswap")

include(${CMAKE_MODULE_PATH}/source_lib_base.cmake)

if( LINUXALL )
    target_compile_options(${OUTLIBNAME} PRIVATE -fPIC)
endif()

vpc_file(bitmap_src
	"ImageByteSwap.cpp"	X360 OR PS3
	"bitmap.cpp"
	"floatbitmap4.cpp" WINDOWS
	"colorconversion.cpp"
	"floatbitmap.cpp"
	"floatbitmap2.cpp"
	"floatbitmap3.cpp"
	"floatbitmap_bilateralfilter.cpp"
	"floatcubemap.cpp"
	"imageformat.cpp"
)

target_sources(${OUTLIBNAME} PRIVATE ${bitmap_src})

target_sources(${OUTLIBNAME} PRIVATE "psd.cpp")
target_sources(${OUTLIBNAME} PRIVATE "psheet.cpp")
target_sources(${OUTLIBNAME} PRIVATE "resample.cpp")
target_sources(${OUTLIBNAME} PRIVATE "tgaloader.cpp")
target_sources(${OUTLIBNAME} PRIVATE "texturepacker.cpp")
target_sources(${OUTLIBNAME} PRIVATE "tgawriter.cpp")

if(WIN32)
    # Link Libraries
    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        # 32-bit Windows
        target_link_directories(${PROJECT_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/lib/public/nvtc")
    else()
        # 64-bit Windows
        target_link_directories(${PROJECT_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/lib/public/nvtc64")
    endif()
    
    target_link_libraries(${PROJECT_NAME} PRIVATE bitmap_byteswap)
endif()